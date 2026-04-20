{
  description = "Trucky";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system}.default = pkgs.appimageTools.wrapType2 {
        pname = "trucky";
        version = "latest";
        src = pkgs.fetchurl {
          url = "https://client-download.truckyapp.com/linux/latest/Trucky.AppImage";
          hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # update-target
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

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/trucky";
      };
    };
}
