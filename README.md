# trucky-nix

Nix Flake for [Trucky](https://truckyapp.com/)

## Usage
Run without installing:
```bash
nix run github:quixaq/trucky-nix
```

## Installation
Add this to your `flake.nix` inputs:
```nix
inputs.trucky-nix.url = "github:quixaq/trucky-nix";
```
And import it as a module. It will add trucky to your system packages:
```nix
outputs = { nixpkgs, trucky-nix, ... }: {
  nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
    modules = [
      ./configuration.nix
      trucky-nix.nixosModules.default
    ];
  };
};
```
