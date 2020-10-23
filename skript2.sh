#!/bin/bash


echo "KEYMAP=de" > /etc/vconsole.conf
echo "FONT=" >> /etc/vconsole.conf
echo "FONT_MAP" >> /etc/vconsole.conf


PS3="Choose a timezone: "
select zone in $(ls /usr/share/zoneinfo/ | more)
do
	PS3="Choose a town: "
	select zoneTown in $(ls /usr/share/zoneinfo/$zone | more)
	do
		ln -sf /usr/share/zoneinfo/$zone/$zoneTown /etc/localtime
		break
	done
	break
done

hwclock --systohc  --utc
systemctl enable systemd-timesyncd

echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=de_DE.utf8" > /etc/locale.conf

echo "majaro" > /etc/hostname

mkinitcpio -P linux56
rm /etc/mkinitcpio.conf
cp /opt/manjaroInstallationscript/mkinitcpio.conf /etc/
mkinitcpio -P

echo enter a root password
passwd

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=majaroGrub --recheck
rm /etc/default/grub
cp /opt/manjaroInstallationscript/grub /etc/default/
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
cryptsetup close SYSTEM

reboot
