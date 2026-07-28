{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

#==CONFIGURACION-DE-GRUB-Y-SYSTEMD==#
  # Instala Grub
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev"; 
      efiSupport = true;
    };
    efi.canTouchEfiVariables = true;
  };

  # Hace que SystemD Ignore el Boton de Apagado
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # Crea un servicio de usuario en SystemD para lanzar el agente gráfico de MATE
  systemd.user.services.mate-polkit-authentication-agent = {
    description = "MATE Polkit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

  serviceConfig = {
    Type = "simple";
    ExecStart = "${pkgs.mate-polkit}/libexec/polkit-mate-authentication-agent-1";
    Restart = "on-failure";
    RestartSec = 1;
    TimeoutStopSec = 10;
    };
  };

#==RED-E-INTERNET==#
  # Establece el Nombre del Host
  networking.hostName = "NixOS-Latitude-7280";

  # Habilita la Red
  networking.networkmanager.enable = true;

  # Habilita el Servicio de Tailscale VPN
  services.tailscale.enable = true;

  # Abre los Puertos del Cortafuegos
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Desabilita el Cortafuegos
  # networking.firewall.enable = false;


#==SONIDO==#
  # Habilita y configura PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

#==BLUETOOTH==#
  # Habilita el Servicio Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

#==DATOS-GENERALES==#
  # Establece la Zona Horaria
  time.timeZone = "Europe/Madrid";

  # Selecciona las Propiedades Internacionales
  i18n.defaultLocale = "es_ES.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configura los Esquemas de Teclado en X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configura los Esquemas de Teclado en Consola
  console.keyMap = "es";

#==CONFIGURACION-DEL-ENTORNO==#
  # Instala el Display Manager
  services.displayManager.ly = {
    enable = true;
  };

  # Instala Sway WM
  programs.sway = { 
    enable = true;
    package = pkgs.swayfx;
  };

  # Instala el Portal wlr
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };


#==CONFIGURACION-DEL-USUARIO
  # Define el Usuario
  users.users."antsoftware21" = {
    isNormalUser = true;
    description = "Antsoftware21";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "podman" "adbusers" ];

  # Rangos de subUID y subGID para contenedores rootless
  subUidRanges = [ { count = 65536; startUid = 100000; } ];
  subGidRanges = [ { count = 65536; startGid = 100000; } ];
  };

#==SERVICIOS==#
  # Habilita el Servicio de Impresion
  services.printing.enable = true;

  # Habilita el Servicio de SSH
  services.openssh.enable = true;

  # Habilita el Servicio Flatpak.
  services.flatpak.enable = true;

  # Habilita el Servicio de los Perfiles de Potencia
  services.power-profiles-daemon.enable = true;

  # Habilita el Servicio de Montaje de Discos
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Habilita el servicio Polkit                  
  security.polkit.enable = true;

#==VIRTUALIZACION==#
  # Habilita la Virtualizacion de LibVirt
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  # Habilita la Virtualizacion de Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

#==PAQUETES==#
  # Permite los Paquetes No-Libres
  nixpkgs.config.allowUnfree = true;

  # Lista de Paquetes
  environment.systemPackages = with pkgs; [
    # Entorno :
    rofi rofi-power-menu waybar swayidle swaylock-effects kanshi
    nwg-look pulsemixer bluetuith nemo engrampa zip unzip eom

    # Temas :  
    papirus-icon-theme graphite-cursors tokyonight-gtk-theme

    # Miscelaneos :
    ximimoments.katifetch git curl wget htop btop cava nyancat
    android-tools nicotine-plus podman distrobox virt-manager
    pciutils

    # Mis Programas :
    ungoogled-chromium foot discord telegram-desktop obs-studio nocturne
    filezilla vlc kdePackages.kdenlive vscodium obsidian libresprite  
    retroarch 
  ];

  # Aqui van las Fuentes Tipograficas
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    ];

  # Habilita Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true; 
  };

#==NIX-USER-REPOSITORY==#
  # Agrego el Repo de Katifetch
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    ximimoments = import (builtins.fetchTarball "https://github.com/ximimoments/nur-packages/archive/main.tar.gz") {
      inherit pkgs;
    };
  };


#==VERSION-DEL-ARCHIVO==#
  # Simplemente no toques esto a no ser que quieras Actualizar el Sistema
  system.stateVersion = "26.05";
}
