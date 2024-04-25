{
  description = "My flake with dream2nix packages";

  inputs = {
    dream2nix.url = "github:nix-community/dream2nix";
    nixpkgs.follows = "dream2nix/nixpkgs";
  };

  outputs =
    inputs@{
      self,
      dream2nix,
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = lib.genAttrs systems;
      inherit (self) outputs;
    in
    {

      formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      # All packages defined in ./packages/<name> are automatically added to the flake outputs
      # e.g., 'packages/hello/default.nix' becomes '.#packages.hello'
      defaultPackage = forEachSystem (
        system:
        dream2nix.lib.evalModules {
          packageSets.nixpkgs = inputs.dream2nix.inputs.nixpkgs.legacyPackages.${system};
          modules = [
            ./default.nix
            {
              paths.projectRoot = ./.;
              # can be changed to ".git" or "flake.nix" to get rid of .project-root
              paths.projectRootFile = "flake.nix";
              paths.package = ./.;
            }
          ];
        }
      );

      inherit (self) outputs;
      hydraJobs = import ./hydra/jobs.nix { inherit inputs outputs; };
    };
}
