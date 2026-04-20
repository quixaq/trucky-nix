{
  description = "Trucky";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.appimageTools.wrapType2 {
          pname = "trucky";
          version = "latest";
          src = pkgs.fetchurl {
            url = "https://client-download.truckyapp.com/linux/latest/Trucky.AppImage";
            hash = "sha256-V4wKsBMfv5jjciMOYJTCQ5JEIsxQqFH4iiEgm0z+gNc="; # update-target
            curlOpts = "-L -A 'Mozilla/5.0'";
          };

          extraPkgs =
            pkgs:
            with pkgs;
            (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
            ++ [
              libunwind
              libusb1
              libsecret
              systemd
            ];
        };

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/trucky";
        };
      }
    );
}
