{ lib }:
rec {
  mkApp =
    { category, categoryCfg, guiCfg }:
    { description, needsGui ? false }:
    lib.mkOption {
      type = lib.types.bool;
      default = categoryCfg.enable && (!needsGui || guiCfg.enable);
      defaultText = lib.literalExpression (
        "config.ryeConfig.${category}.enable"
        + lib.optionalString needsGui " && config.ryeConfig.gui.enable"
      );
      example = false;
      inherit description;
    };

  # Declares `<app>.enable` + `<app>.package` for every entry in `apps`.
  mkSimpleOptions =
    { category, categoryCfg, guiCfg, pkgs, apps }:
    lib.mapAttrs
      (name: spec: {
        enable = mkApp { inherit category categoryCfg guiCfg; } {
          inherit (spec) description;
          needsGui = spec.gui or false;
        };
        package = lib.mkPackageOption pkgs (spec.pkg or name) { };
      })
      apps;

  # The HM half: one `home.packages` entry per enabled app.
  mkSimplePackages =
    { categoryCfg, apps }:
    lib.concatMap
      (name: lib.optional categoryCfg.${name}.enable categoryCfg.${name}.package)
      (lib.attrNames apps);
}
