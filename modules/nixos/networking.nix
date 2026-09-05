{ config, lib, pkgs, ... }:

{
  networking = {
    hostName = "opalnix";
    networkmanager.enable = true;

    firewall = {
      enable = true;
      # Allow WoL Magic Packets (UDP port 9 / 7)
      allowedUDPPorts = [ 7 9 ];

      # Core homelab ports
      allowedTCPPorts = [ 80 443 ];
    };
  };

  # Enable WoL in the alx kernel module (MSI H97 Gaming 3 Atheros Killer E2200)
  # Equivalent to alx-wol-dkms on Arch Linux
  boot.extraModprobeConfig = ''
    options alx enable_wol=1
  '';

  # Systemd service to ensure ethtool sets WoL mode 'g' on all ethernet interfaces
  systemd.services.enable-wol = {
    description = "Enable Wake-on-LAN for Atheros alx NIC";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "enable-wol.sh" ''
        for iface in $(${pkgs.iproute2}/bin/ip -o link | ${pkgs.gawk}/bin/awk -F': ' '{print $2}' | ${pkgs.gnugrep}/bin/grep -E '^(en|eth)'); do
          echo "Enabling Wake-On-LAN for $iface"
          ${pkgs.ethtool}/bin/ethtool -s "$iface" wol g || true
        done
      '';
    };
  };

  # Network utilities
  environment.systemPackages = with pkgs; [
    ethtool
    wol
    tcpdump
    inetutils
  ];
}
