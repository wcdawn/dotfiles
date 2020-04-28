# Arch Install

I, William C. Dawn, originally prepared this document for configuring my Lenovo ThinkPad x220 experiment(s).
Information is also provided relating to "`dawnsvr`" which was some sort of old HP monstrosity.
I've again updated this document when building my new computer from scratch.

## Hardware on New Build
- AMD Ryzen 3900x
- Noctua DH-15 CPU cooler
- 2x16 GB DDR4-3000 Corsair Vengance RAM
- Asus TUF Gaming x570-Plus (WiFi) Motherboard
- Western Digital SN750 (Black) NVME M.2-2280 SSD
- Gigabyte GeForce RTX 2070 Super 8GB Windforce OC 3X Video Card
- Fractal Design Meshify C
- EVGA SuperNOVA G3 650W 80+ Gold Certified Fully Modular Power Supply

## 1. Make Arch Bootable USB
- Download latest Arch linux iso from <https://www.archlinux.org/download>.

- Do *NOT* mount the drive.

- Note: the CASL drives seem to suck for this purpose.
Use literally any other USB stick.

- Use `dd` ("Data Dump" or "Disk Destroyer") to make the arch live USB.
If `/dev/sdb` is the USB drive:
```bash
$ sudo dd if=/path/to/archlinux.iso of=/dev/sdb status="progress"
```

## 2. Boot from Live USB
- Before booting to the live USB, you need to know what sort of boot manager you want to use.
If you want to boot from the Linux EFI stub (you do, it's lightweight and requires no extra software), you need to boot in EFI mode.
To boot in EFI mode, you need to set the option in BIOS before booting.
Enable EFI boot and make sure it is the default.
If you fail at this now, you will not know until the end and it will suck.

- Ethernet will need to be connected at boot.

- Go ahead and boot from the Live USB.
Use F12 on the Lenovo ThinkPad x220.
The "delete" key seems to be used on modern computers.

- When you're dropped into the live session, you'll have an option.
Obviously, you want to select "Arch Linux archiso x86_64 UEFI CD."
If you are using NVIDIA graphics (especially, newer NVIDIA graphics like on my custom build), you'll need to modify the kernel parameters to support the graphics drivers.

- To modify kernel parameters, place the cursor over "Arch Linux archiso x86_64 UEFI CD" and press the `<e>` key.
Then, scroll to the end of the list.
For NVIDIA compatibility, after a space add the parameter `nomodeset`.
You will have to do this every time you reboot from the live USB.

- It's a good idea to check ping to make sure you have internet access because you'll need it.

- Hook up an ethernet cable.
```bash
# ping archlinux.org
```

- If the ping fails, run `dhcpd` to get an IP address.

## 3. UEFI/BIOS Notes
- Much of the same applies for a BIOS-only system (like the old HP desktop machine I use called `dawnsvr`).

- The differences are best summarized on the Arch Linux wiki:
> A BIOS boot partition is only required when using GRUB for BIOS booting from a GPT disk.
> The partition has nothing to do with `/boot` and it must not be formatted with a filesystem or mounted.

- If you intend to use a BIOS (non-UEFI) installation, the following steps apply:

    - Do *NOT* format `/dev/sda1`. The BIOS partition must contain no filesystem.

    - Do *NOT* mount `/dev/sda1`.

    - When it comes to install a bootloader:
    ```bash
    # grub-install /dev/sda
    # grub-mkconfig -o /boot/grub/grub.cfg
    ```

    - And that should do it...

## 4. Make Drive Partitions

- We will assume three partitions.
This is minimally, "boot & root."

    1. `/boot` (boot for efi or other boot configuration files).
    2. `SWAP` to allow for system suspend.
        - `SWAP` partitoin must be 1.5x RAM (e.g. if RAM=8GB, SWAP=12GB).
        - This is necessary to allow all RAM to write to disk for suspend.
    3. `/` (root).

- For using BIOS, you'll want a Master Boot Record (MBR).
For using UEFI, you'll want a GUID Partition Table (GPT).
This will be set within `fdisk` (see next step).
If converting from BIOS to UEFI, you will need to format and start the table/record from scratch.
This will be done using `fdisk` in the next step.

- Use `fdisk` to accomplish this. If `/dev/sda` is the main hard drive disk, run:
```bash
# fdisk /dev/sda
```

- If the drive has partitions on it, it is first necessary to delete existing partitions.
This can be done within `fdisk`.

- When you run `fdisk`, you will be led through a series of prompts.
These are some recommended partition sizes and drive types for a UEFI boot.
    1. `/boot`, 1GB, EFI System.
    2. `SWAP`, 12GB, Linux Swap.
    3. `/`, remainder, Linux System.

## 5. Format the Partitions

- Drives are formatted to the default Linux filesystem, `ext4`.
Except for the UEFI `/boot` partition which will be formatted in `FAT`.

- Don't sweat filesystems too much.
It's a waste of time.

- If you do want to waste time, some people seem to like `btrfs`.
It is certainly newer, but it is also less stable.
It does not do journaling so it decreases write-to-disk operaitons.

- `SWAP partiaion will be established specially.

- Format each of the partitions as follows:
    1. `/boot`
    ```bash
    # mkfs.fat -F32 /dev/sda1
    ```
    2. `SWAP`
    ```bash
    # mkswap /dev/sda2
    # swapon /dev/sda2
    ```
    3. `/`
    ```bash
    mkfs.ext4 /dev/sda3
    ```

## 6. Mount the Partitions

- Now we have made and formatted the partitions.
We're going to mount them at `/mnt` because that's what people do.

1. `/`
```bash
# mount /dev/sda3 /mnt
```

2. `/boot`
```bash
# mkdir /mnt/boot
```

## 7. Install Arch Linux

- This is done using the `pacstrap` command.

- Install `base`, `base-devel`, `linux`, `linux-firmware`, and `vim` packages because we'll probably need them all anyways.

- We also need the microcode updates specific to our processor.
Install either `amd-ucode` or `intel-ucode` as applicable. `networkmanager` will be used for internet stuffs.
```bash
# pacstrap /mnt base base-devel vim <PROC>-ucode linux linux-firmware git networkmanager.
```

## 8. Make `fstab` (File System TABle)

- `genfstab` will do most of the work for us.
We want the `-U` options to use UUIDs.
```bash
# genfstab -U /mnt > /mnt/etc/fstab
```

- You need to check after the command runs to make sure it did what you thought it was going to do.
``` bash
# vim /mnt/etc/fstab
```

- Use `noatime` for root (`/`). 
`noatime` decreases the number of times data is written to a disk and the SSD can benefit.
It prevents the last time a file was opened from being recorded.
An example from the arch wiki is provided.
```bash
# <device> <dir> <type> <optoins> <dump> <fsck>
/dev/sda1  /boot vfat   defaults  0      1
/2ev/sda2  none  swap   defaults  0      0
/dev/sda3  /     ext4   noatime   0      1
```

## 9. Change Root

- This is where we (mostl) have an operating system.
```bash
# arch-chroot /mnt
```
- Now everything is on the main computer/hard drive

## 10. Configure Network Manager

- The package `networkmanager` was included in the `pacstrap` command so it is on the system.
Now, we need to start it.
```bash
# systemctl enable NetworkManager
```

## 11. Set Trim Settings for SSD

- For an SSD, trim support can significanly improve timing by keeping the disk in a state that is always ready to be written.

- This is done periodically, once per week, (*not* continuously) by a `systemd` task.

- Simply execute this to kick the whole thing off:
```bash
# systemctl enable fstrim.timer
```

## 12. Install a Boot Loader/Manager

- Traditionally a bootloader would be used to start the OS.
Now a days, OSes can typically start themselves and just need to be told to do so via a boot manaer.

- `systemd-boot` is the most lightweight bootmanager on the market it seems.

- Alternately, this is where GRUB would be configured for a BIOS install with the two commands listed at the beginning of the document.

- Setup `systemd-boot`:
```bash
# bootctl --path=/boot install
```

- It seems like you need to generate your own config files at `/boot/loader/loader.conf` and `/boot/loader/entries/arch.conf`.

- The loader config at `/boot/loader/loader.conf` should contain
```
default arch
timeout 0
editor 0
```

- The default profile at `/boot/loader/entries/arch.conf` (filename corresponding to default name) should contain
```
title Arch Linux
linux /vmlinuz-linuz
initrd /<PROC>-ucode.img # either intel-ucode.img or amd-ucode.img
initrd /initramfs-linux.img
options root=PARTUUID=#### rw
```

- Generate the PARTUUID with the command
```bash
# blkid -s PARTUUID -o value /dev/sda3
```
To dump this straight into vim, use `:read !<shell>`.

- A hook must be placed to allow pacman to automatically update `systemd-boot`.
Othewise a special command is required (and I'd forget).
A file at `/etc/pacman.d/hooks/100-systemd-boot.hook` should contain
```
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Updating systemd-boot
When = PostTransaction
Exec = /usr/bin/bootctl update
```

## 13. Set Root Password

- Use the `passwd` command.
```bash
# passwd
```

## 14. Set Locale Information

- Set information necessary for timezone, language, and character sets.

- Set the time zone.
Use tab complete to make a symlink.

```bash
# ln -sf /usr/share/zoneinfo/America/<CITY> /etc/localtime
# hwclock --systohc
```

- Editing the file `/etc/locale.gen`. Uncomment `en_US.UTF-8 UTF-8` and `en_US ISO-8859-1`.

- Run the command to generate the locale file.
```bash
# locale-gen
```

- Set the `LANG` variable in `/etc/locale.conf`.
```bash
LANG=en_US.UTF-8
```

## 15. Set Hostname

- Edit the value of the file in `/etc/hostname`.

- I typically use `arch` as a prefix for something.
Like `archpad`, `archwork`, or `archbuild`.

## 16. Unmount and Reboot

- Everything (should be) (is maybe) done.

- Exit the chroot back onto the live USB.
```bash
# exit
```

- Unmount all of the drives.
```bash
# swapoff /dev/sda2
# umount -R /mnt
```

- Reboot
```bash
# reboot
```

- You should be dropped back into the tty.
You may have to do something about `nomodeset` again...

## 16. Post-Install Configuration

### Make a User

- You'll want a user that's not root.
That's just a good idea.

- Think of the `wheel` group as the administrator group.
```bash
# useradd -m -g wheel wcdawn
# passwd wcdawn
```

- Edit the sudoers file.
Users of the `wheel` group should be allowed to run any command without a password.
Uncomment the following line.
```
%wheel ALL=(ALL) NOPASSWD: ALL
```

### Connect to WiFi.

- Connect via `networkmanager` using `nmcli`
```bash
# nmcli device wifi connect <SSID> password <PASSWORD>
```

### Hibernate/Suspend

- It looks like `systemd` should do this automatically.

- If it doesn't, look into the config file `/etc/systemd/logind.conf` and find the line `HandleLidSwitch`.

- You'll probably need to uncomment the lines relating to `HandleLidSwitch`.

### NVIDIA Drivers

- If you're using a real graphics card, you're using NVIDIA.
NVIDIA and Linux don't get along.
So, here's how to configure NVIDIA drivers.
Most of this comes from the [Arch wiki](https://wiki.archlinux.org/index.php/NVIDIA).

- For GeForce 630 and newer (everything since 2010), install the `nvidia` package with `pacman`.
Do not use the drivers from NVIDIA's website as they will not automatically update. 
If `nvidia` doesn't work, try `nvidi-beta` from the AUR.

- A reboot *is necessary*.

### Setup Graphical Environment

- Start by downloading my dotfiles from `https://github.com/wcdawn/dotfiles`.

- Add the machine's public key to my GitHub account.

- Use the `~/scripts/config_setup.sh` script to automatically clone and setup the repo.

- In the future, the package list should be automated.
But for now, this is a list of packages that we'll probably need.

Package               | Usage
--------------------- | --------
`xf86-video-intel`    | Intel integrated graphics
`xf86-input-libinput` | Touchpad and other input drivers
`xorg-server`         | X.org server
`xorg-init`           | X.org initializer scripts
`xorg-xsetroot`       | X.org `xsetroot` command for customizing X behavior.
`firefox`             | Web browser
`gcc-fortran`         | GNU Fortran compiler
`lapack`              | Linear Algebra Package (LAPACK)
`hdf5`                | HDF5 file interfaces
`valgrind`            | Valgrind memory tester
`marked`              | Lightweight markdown processor
`texlive-most`        | LaTeX package
`zathrua`             | Lightweight PDF viewer with Vim keybindings
`zathura-pdf-poppler` | PDF rendering engine for Zathura
`biber`               | LaTeX bibliography manager
`python`              | Python3 package
`python-scipy`        | Python `scipy` package
`python-numpy`        | Python `numpy` package
`python-matplotlib`   | Python `matplotlib` package
`python-sympy`        | Python `sympy` package
`alsa-utils`          | OLD audio configuration tools
`pulseaudio`          | NEW audio configuration tools
`ncpamixer (AUR)`     | Audio control for pulseaudio.
`lm_sensors`          | Detect temperature sensors. Use `sensors-detect` command.
`openssh`             | Secure SHell (SSH).
`openconnect`         | NCSU VPN.
`rxvt-unicode`        | URxvt terminal emulator
`bspwm`               | BSPWM tiling window manger
`sxhkd`               | Simple X HotKey Daemon for use in conjunction with BSPWM
`picom`               | Compositor to handle transparency (formerly Compton)
`feh`                 | Image viewer for setting backgrounds
`dmenu`               | Menu for launching programs
`ttf-ibm-plex`        | Preferred font
`polybar-git (AUR)`   | Bar for top of screen
`unclutter`           | Hide mouse when not in use
`htop`                | Resources utilization visualizer using ncurses.
`arandr`              | Utility for managing multiple monitors

### Install `yay` for Arch User Repository

- Begin by making a directory for downloading the package.
```bash
$ mkdir ~/aur
$ cd ~/aur
```

- Download the repository.
```bash
$ git clone https://aur.archlinux.org/yay.git
$ cd ./yay
```

- Build the package.
This uses the `PKGBUILD` file which is (semi) readable.
```bash
$ makepkg -si
```

- `yay` is now installed.
The syntax for `yay` is the same as the syntax for `pacman`.

- You want to enable parallel compilation.
Especially on a 12 core CPU.
Edit `/etc/makepkg.conf` and edit `MAKEFLAGS="-j6"`.

- While you're at it, `yay -S ttf-ms-fonts` for Times New Roman.

### Configure Audio

- To manage audio levels, the command is `alsamixer`.

- Type `M` to unmute the master channel and then use arrow keys to set the volume.
Type `Esc` to exit.

- To perform a two channel audio test, `speaker-test -c2`.

- Alsa does not seem go well for audio over DisplayPort or HDMI.
Therefore, we use pulseaudio.
This is controled using basic `ncpamixer` and which is navigated using basic Vim controls.

### Configure a Printer

- Printers are managed by CUPS.
Package `cups-pdf` allows for print to PDF.

- The Epson WF-3520 printer driver is in the package `epson-inkjet-printer-escpr`.

- HP printers seem to be addressed by `hplip`.
```bash
# pacman -S cups cups-pdf epson-inkjet-printer-escpr hplip
```

- Use `systemd` to enable and start CUPS.
```bash
# systemctl enable org.cups.cupsd.service
# systemctl start org.cups.cupsd.service
```

- Use the CUPS web interface to install the physical and cups-pdf printers.
Point a web browser to <http://localhost:631>.

- When installing the cups-pdf printer, select "Generic" when prompted to select a make/brand.

- For cups-pdf, by default pdf files are saved to `/var/spool/cups-pdf/wcdawn`. You can change this by editing `/etc/cups/cups-pdf.conf` and I set it to dump in my home directory.
I can rename and move from there.

- To set a default printer, use the `<NAME>` in the CUPS list.
```bash
$ lpoptions -d <NAME>
```

### Install a Scanner

- Use the `sane` package
SANE stands for Scanner Access Now Easy.

- Some of the scripts that I have written for scanner interface require the `ghostscript` package.

```bash
# pacman -S sane ghostscript
```

- Now, `scanimage -L` will list all available scanners.
This seems to work automatically.

- Use `scanimage --help --device="<NAME>"` to list all of the options for the scanner.

- I have written a scanner script to scan to pdf in `~/srcipts/scan_pdf.sh`.


### Configure Pacman

- Configuration file located at `/etc/pacman.conf`.

- Set the mirror list with higher priority mirrors closer to the top.
This can have a huge impact on download speeds.
The mirror list is located in `/etc/pacman.d/mirrorlist`.
The MIT servers seem good and responsive.

- In `/etc/pacman.conf` uncomment the `Color` line for pretty text formatting.

- Optionally, add a line with `ILoveCandy` to turn the loading bar into a pacman eating dots.

#### Useful Pacman commands.

- `pacman -S <NAME>` to install a package named `<NAME>`.

- `pacman -Ss <NAME>` to search the remote repositories for a package named `<NAME>`.
The argument also accepts regular expressions.

- `pacman -Qn` to list packages installed from main repos.
`pacman -Qm` to list packages installed from the AUR.
For a cleaner list, `pacman -Qqen` and `pacman -Qqem` respectively.
The `q` option (quiet) does not output version numbers.
The `e` option (explicit) only lists packages explicitly installed, not those installed as dependencies.

- `pacman -Qdt` lists truly orphaned packages.
To automatically remove orphaned packages, use the following command.
```bash
# pacman -Rns $( pacman -Qqdt )
```

- `pacman -Rns <NAME>` to remove a package named `<NAME>` and all of its dependencies and system config files.

#### Maintaining a Packages List

- This would be something that's good to add to a repository.

- Note that you'll want to use `yay` because the list will include packages from both the main repos and the AUR.
Alternatively, use the `n` and `m` to list repo and AUR packages separately.

- To list installed packages `yay -Qqe > pkglist.txt`.

- To install packages from a list `yay -S --needed - < pkglist.txt`.

- To automate the maintenance of a package list setup a hook.
Store this at `/etc/pacman.d/hooks/100-pkglist.hook`.
The `pkglist.txt` could then be added to a `git` repo.
```
[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
When = PostTransaction
Exec = /bin/sh -c '/usr/bin/pacman -Qqe > /etc/pkglist.txt'
```
