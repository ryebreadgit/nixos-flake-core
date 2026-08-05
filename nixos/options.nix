{ lib, ... }:
{
  options.ryeConfig = {
    gui.enable = lib.mkEnableOption "graphical applications" // { default = true; };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "rye" ];
      description = ''
        Accounts that category modules grant supplementary groups and
        privileged access to (wireshark, pcap, polkit owners, and so on).
      '';
    };
  };
}
