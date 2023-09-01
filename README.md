# on Arch-iso:

## Keyboardlayout

    loadkeys de-latin1

## Wlan

    iwctl
    device list
    station wlan0 scan
    station wlan0 get-networks
    station wlan0 connect SSID
        -> password
    station wlan0 show
    exit

## Time & Date

    timedatectl set-ntp true
    timedatectl set-timezone Europe/Berlin
    date

## Disk and Partitions

    fdisk -l
    cfdisk /dev/sda
        -> gpt
    New -> 4G -> Type: Linux swap
        (/dev/sda1)
    New -> 1G -> Type: EFI System
        (/dev/sda2)
    New -> Rest -> Type: Linux filesystem
        (/dev/sda3)
    Write -> yes -> Quit
    lsblk
    fdisk -l


    mkfs.ext4 /dev/sda3
    mkfs.fat -F32 /dev/sda2
    mkswap /dev/sda1

## Mount Partitions

    mount /dev/sda3 /mnt
    mkdir /mnt/efi
    mount /dev/sda2 /mnt/efi
    swapon /dev/sda1

## Install Arch

    pacstrap -i /mnt base base-devel linux linux-firmware nano git
        -> 1 (mkinitcpio)
    genfstab -U /mnt >> /mnt/etc/fstab

## Configure Arch using chroot

    arch-chroot /mnt
    ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    hwclock --systohc
    locale-gen
    echo "LANG=de_DE.UTF-8" >> /etc/locale.conf
    echo "KEYMAP=de-latin1" > /etc/vconsole.conf
    echo "athinkpad" >> /etc/hostname
    nano /etc/hosts
->
    
    # Static table lookup for hostnames.
    # See hosts(5) for details.
    127.0.0.1       localhost
    ::1             localhost
    127.0.0.1       athinkpad.localdomain athinkpad
CTRL+X -> Y -> Enter

    pacman -S networkmanager
    systemctl enable NetworkManager
    
    passwd
        -> root
`(change/remove after you added user!!!)`

    pacman -S grub efibootmgr
    lsblk
    grub-install --target=x86_64-efi --bootloader=GRUB --efi-directory=/efi --removable
    grub-mkconfig -o /boot/grub/grub.cfg
    exit
    umount -R /mnt
    reboot

wait for iso shutdown to complete, then: Remove USB

Select Arch in Bootmenu

# Boot Arch and login in tty1
    
    user: root
    password: root

## connect to wifi via NetworkManager

#### CLI method: password will be visible in history
    
    nmcli device wifi list
    nmcli devici wifi connect SSID password PASSWORD
#### TUI method: password won't be visible
    
    nmtui
    -> activate wifi
    -> connect to wifi
    -> quit

## add user (in this case username is user)

    useradd -m -g users -G wheel -s /bin/bash user
    passwd user
        -> your password
    pacman -S sudo
    EDITOR=nano visudo
        -> uncomment %wheel ALL=(ALL) ALL
    
    su user
    sudo pacman -S neofetch

if it worked, you're done, lock root account from login via

    sudo passwd -l root
(you can still sudo su root from your user account)

## Add Windows to Grub
    sudo fdisk -l
        -> Search for EFI System partition of Windows
    sudo mkdir /mnt/windowsefi
    sudo mount /dev/nvme0n1p2 /mnt/windowsefi
    sudo pacman -S os-prober
    sudo os-prober
        -> should say stf about Windows Boot Manager
    sudo nano /etc/default/grub
        -> Ctrl + W (search)-> Prober
        -> GRUB_DISABLE_OS_PROBER=false
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    reboot
        -> try booting to windows

## DONE

    sudo pacman -S neofetch htop less
    neofetch

# Desktop Environment 

## BSPWM

    setxkbmap de in bashrc
    xrandr -s 1920x1080

Install Driver

    sudo pacman -S xf86-video-intel
    sudo pacman -S xf86-video-amdgpu
    sudo pacman -S nvidia nvidia-utils nvidia-settings

Window manager stuff    
    
    sudo pacman -S xorg xorg-xinit bspwm sxhkd dmenu nitrogen picom alacritty firefox arandr
    mkdir ~/.config/bspwm
    mkdir ~/.config/sxhkd
    cp /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
    cp /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
    nano ~/.config/sxhkd/sxhkdrc
        -> change `urxvt` under terminal to `alacritty`
    cp /etc/X11/xinit/xinitrc ~/.xinitrc
    nano ~/.xinitrc

-> delete everything and add

    setxkbmap de &
    picom -f &
    exec bspwm
save and exit, check:

    startx
    Super+Enter
    Super+W
    Super+Spacebar -> arandr -> Select monitor, select resolution, save as ~/.screenlayout/monitors.sh
    chmod +x ~/.screenlayout/monitors.sh
    nano .xinitrc
-> add `` before `picom` and definitely before `exec bspwm`
    
    ~/.screenlayout/monitors.sh
    nitrogen --restore &
    xsetroot -cursor_name left_ptr

done

    startx
    firefox #get wallpaper via browser
    Super+Spacebar -> nitrogen -> preferences -> Add -> Downloads Folder -> Select -> Ok -> Select Wallpaper -> Zoomed Fill -> Apply

    Super+Enter 
    mkdir -p ~/.config/alacritty
    nano ~/.config/alacritty/alacritty.yml
-> add:

    # Basic configuration
    window:
    dimensions:
        columns: 80
        lines: 24
    padding:
        x: 2
        y: 2
    opacity: 0.5

    font:
    normal:
        family: monospace
        style: Bold
    size: 10.0

    colors:
    primary:
        background: 'rgba(0, 0, 0, 0.5)'
        foreground: 'rgba(255, 255, 255, 1.0)'
-> reload terminal

For keybindings make familiar with 

    nano .config/sxhkd/sxhkdrc
    
To resize and move windows, add these lines to

    nano .config/bspwm/bspwmrc
add ->

    # move/resize windows
    bspc config pointer_modifier     mod1
    bspc config pointer_action1      move
    bspc config pointer_action2      resize_side
    bspc config pointer_action3      resize_corner

| Keybind              | Description   |
|----------------------|---------------|
| Super + S            | Floating      |
| Alt + Left Mouse     | Move Window   |
| Alt + Right Mouse    | Resize Window |
| Super + T            | Tiled         |
| Super + Shift + T    | Pseudo-tiled  |
| Super + F            | Fullscreen    |


## 2nd monitor

    xrandr
-> output name of 2nd monitor (e.g. HDMI-1-1)

    nano .config/bspwm/bspwmrc
change 
    
    bspc monitor -d 1 2 3 4 5 6 7 8 9 10
to
    
    bspc monitor -d 1 2 3 4 5
    bspc monitor HDMI-1-1 -d 6 7 8 9 10

## Polybar

    sudo pacman -S polybar
    mkdir ~/.config/polybar
    cp /usr/share/doc/polybar/examples/config.ini ~/.config/polybar/
    nano ~/.config/polybar/config.ini
    nano ~/.xinitrc
    -> before picom: `polybar &`

## Audio and Brightness Keys

    sudo pacman -S pulseaudio pulseaudio-alsa alsa-utils
    sudo pacman -S xorg-xbacklight
    sudo pacman -S playerctl
    sudo pacman -S brightnessctl
    sudo pacman -S pavucontrol
    sudo pacman -S xfce4-power-manager
    sudo pacman -S acpi
    sudo pacman -S acpid
    sudo systemctl enable acpid
    sudo systemctl start acpid
    sudo nano /etc/acpi/handler.sh

## Official Visual Studio Code (Copilot)

download from https://code.visualstudio.com/# the .tar.gz file

    tar -xzf ~/Downloads/code-stable-x64-1691619534.tar.gz
    sudo mv VSCode-linux-x64/ /usr/local/
    sudo ln -s /usr/local/VSCode-linux-x64/code /usr/local/bin/code
-> restart terminal