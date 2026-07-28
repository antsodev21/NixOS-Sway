#!/bin/bash
cat ascii_art.txt

#==COPIA-DE-DOTFILES==#
cp -r foot/ ~/.config
cp -r kanshi/ ~/.config
cp -r rofi/ ~/.config
cp -r sway/ ~/.config
cp -r waybar/ ~/.config

#==CAMBIO-DE-PERMISOS-DE-EJECUCION==#
sudo chmod +x ~/.config/rofi/script/power-profiles.sh

#==COPIA-DE-LA-CONFIGURACION-DE-NIX==#
sudo cp configuration.nix /etc/nixos/configuration.nix

#==APLICA-LA-CONFIGURACION==#
sudo nixos-rebuild switch
