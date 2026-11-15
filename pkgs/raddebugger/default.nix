{
  lib,
  clangStdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  freetype,
  libX11,
  libXext,
  libXfixes,
  libGL,
  zenity,
  llvm,
  nix-update-script,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "raddebugger";
  version = "0.9.29-alpha";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQNicRWKdIamDeQU1RRceRR2QgoUlomQYoeCgepO10w=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    freetype
    libX11
    libXext
    libXfixes
    libGL
  ];

  # build.sh embeds `git describe` output, but the fetched source has no .git.
  postPatch = ''
    patchShebangs build.sh
    substituteInPlace build.sh \
      --replace-fail 'git_hash=$(git describe --always --dirty)' 'git_hash=v${finalAttrs.version}' \
      --replace-fail 'git_hash_full=$(git rev-parse HEAD)' 'git_hash_full=v${finalAttrs.version}'
  '';

  buildPhase = ''
    runHook preBuild
    AR=$AR ./build.sh raddbg radbin release
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/raddbg build/radbin -t $out/bin
    install -Dm644 data/logo.png $out/share/icons/hicolor/256x256/apps/raddbg.png
    runHook postInstall
  '';

  # zenity backs the Linux file picker and message boxes;
  # llvm-symbolizer turns crash reports into readable call stacks.
  postFixup = ''
    for prog in $out/bin/*; do
      wrapProgram $prog --prefix PATH : ${
        lib.makeBinPath [
          zenity
          llvm
        ]
      }
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native, user-mode, multi-process, graphical debugger";
    homepage = "https://github.com/EpicGames/raddebugger";
    changelog = "https://github.com/EpicGames/raddebugger/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "raddbg";
  };
})
