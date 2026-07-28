#!/bin/bash
cat .ascii_art.txt

#==COPIA-DE-DOTFILES==#
cp -r config/foot/ ~/.config
cp -r config/kanshi/ ~/.config
cp -r config/rofi/ ~/.config
cp -r config/sway/ ~/.config
cp -r config/waybar/ ~/.config

#==CAMBIO-DE-PERMISOS-DE-EJECUCION==#
sudo chmod +x ~/.config/rofi/script/power-profiles.sh

#==COPIA-DE-LA-CONFIGURACION-DE-NIX==#
sudo cp configuration.nix /etc/nixos/configuration.nix

#==APLICA-LA-CONFIGURACION==#
sudo nixos-rebuild switch
