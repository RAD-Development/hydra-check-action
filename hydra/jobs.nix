{ inputs, outputs }:
let
  inherit (inputs.nixpkgs.lib) mapAttrs;

  getCfg = _: cfg: cfg.config.system.build.toplevel;
in
{
  packages = mapAttrs getCfg outputs.packages;
}
