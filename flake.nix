/*
  trucky-nix v0.1.2
  Copyright (C) 2026  Quixaq

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
