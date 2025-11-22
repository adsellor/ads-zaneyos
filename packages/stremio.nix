{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  gtk4,
  mpv,
  libappindicator,
  makeWrapper,
  nodejs,
  webkitgtk_6_0,
  libadwaita,
  libepoxy,
  gettext,
  # fetchurl,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  name = "stremio-linux-shell";
  version = "1.0.0-beta.12";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    rev = "master";
    hash = "sha256-07b7Ye75zoZ46Ar8DsL8+Q1RjtbJ4DmuLvXe8k+R4IA=";
  };

  cargoHash = "sha256-BgzOAU9TcUom8aVgFxXebUsZV2KprQeYIgJ8Mrcs/GA=";

  buildInputs = [
    openssl
    gtk4
    mpv
    webkitgtk_6_0
    libadwaita
    libepoxy
  ];

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    gettext
  ];

  #postPatch = ''
  #  substituteInPlace ./src/config.rs \
  #    --replace-fail \
  #      'let file = data_dir.join(SERVER_FILE);' \
  #      'let file = PathBuf::from(r"${server}");'

  #  substituteInPlace ./src/server.rs \
  #    --replace-fail \
  #      'let should_download = self.config.version() != Some(latest_version.clone());' \
  #      'let should_download = false;'
  #'';

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps

    mv $out/bin/stremio-linux-shell $out/bin/stremio
    cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    wrapProgram $out/bin/stremio \
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator ]} \
       --prefix PATH : ${lib.makeBinPath [ nodejs ]}
    '';

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    # (Server-side) 4.x versions of the web UI are closed-source
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      unfree
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
      { name = "nuko"; }
    ];
    platforms = lib.platforms.linux;
  };
})
