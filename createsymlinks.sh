#!/bin/bash

mv -f ~/.bashrc ~/.bashrc_backup 
mv -f ~/.config/bspwm ~/.config/bspwm_backup
mv -f ~/.config/sxhkd ~/.config/sxhkd_backup
mv -f ~/.xinitrc ~/.xinitrc_backup
mv -f ~/.config/alacritty ~/.config/alacritty_backup
mv -f ~/.config/polybar ~/.config/polybar_backup
mv -f ~/.config/mc ~/.config/mc_backup

ln -s ~/archdotfiles/dotstuff/.bashrc ~/.bashrc 
ln -s ~/archdotfiles/dotstuff/bspwm/ ~/.config/bspwm
ln -s ~/archdotfiles/dotstuff/sxhkd/ ~/.config/sxhkd
ln -s ~/archdotfiles/dotstuff/.xinitrc ~/.xinitrc 
ln -s ~/archdotfiles/dotstuff/alacritty/ ~/.config/alacritty
ln -s ~/archdotfiles/dotstuff/polybar/ ~/.config/polybar
ln -s ~/archdotfiles/dotstuff/mc ~/.config/mc