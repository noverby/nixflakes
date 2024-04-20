{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}: let
  pname = "breezy-desktop";
  uuid = "breezydesktop@org.xronlinux";
in
  stdenv.mkDerivation {
    inherit pname;
    version = "";

    src = fetchFromGitHub {
      owner = "wheaney";
      repo = pname;
      rev = "140f4d21ab85fc3e0ca75c2226981c2845a4ccdd";
      sha256 = "sha256-C4y2WgrfBf3hR0DHanxutep5CYV/JxJtYp9fVu1f+mo=";
    };

    nativeBuildInputs = with pkgs; [buildPackages.glib];
    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions/
      cp -r -T gnome/${uuid} $out/share/gnome-shell/extensions/${uuid}
    '';
    meta = {
      description = "Breezy GNOME XR Desktop";
      longDescription = "XR virtual desktop for GNOME.";
      homepage = "https://github.com/wheaney/breezy-desktop";
      license = lib.licenses.gpl2Plus; # https://wiki.gnome.org/Projects/GnomeShell/Extensions/Review#Licensing
      maintainers = with lib.maintainers; [piegames];
    };
    passthru = {
      extensionPortalSlug = pname;
      extensionUuid = uuid;
    };
  }
