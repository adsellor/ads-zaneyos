{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  mpv,
  libappindicator,
  libsoup_3,
  makeWrapper,
  nodejs,
  webkitgtk_6_0,
  libadwaita,
  libepoxy,
  gettext,
  wrapGAppsHook4,
  glib-networking,
  gsettings-desktop-schemas,
  ...
}:
rustPlatform.buildRustPackage (finalAttrs: {
  name = "stremio-linux-shell";
  version = "1.0.0-beta.12";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-linux-shell";
    rev = "main";
    hash = "sha256-07b7Ye75zoZ46Ar8DsL8+Q1RjtbJ4DmuLvXe8k+R4IA=";
  };

  cargoHash = "sha256-BgzOAU9TcUom8aVgFxXebUsZV2KprQeYIgJ8Mrcs/GA=";

  buildInputs = [
    webkitgtk_6_0
    libadwaita
    libepoxy
    libsoup_3
    openssl
    mpv
    glib-networking
    gsettings-desktop-schemas
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    makeWrapper
    pkg-config
    gettext
  ];

  postInstall = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mv $out/bin/stremio-linux-shell $out/bin/stremio
    cp $src/data/com.stremio.Stremio.desktop $out/share/applications/com.stremio.Stremio.desktop
    cp $src/data/icons/com.stremio.Stremio.svg $out/share/icons/hicolor/scalable/apps/com.stremio.Stremio.svg

    wrapProgram $out/bin/stremio \
       --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libappindicator mpv ]} \
       --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
       --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules"
    '';

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    license = with lib.licenses; [
      gpl3Only
      unfree
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
      { name = "nuko"; }
    ];
    platforms = lib.platforms.linux;
  };
})
