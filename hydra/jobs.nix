{ inputs, outputs }:
let
  inherit (inputs.nixpkgs.lib) mapAttrs;
  systems = [ "x86_64-linux" ];
  generate = arg: builtins.mapAttrs arg (builtins.intersectAttrs systems inputs.nixpkgs.legacyPackages);
in
{
  packages = outputs.packages;
}
