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
		ln -s /usr/share/zoneinfo/$zone/$zoneTown /etc/localtime
		break
	done
	break
done

hwclock --systohc  --utc

echo "de_DE.utf8" >> /etc/locale.gen
locale-gen

echo "LANG=de_DE.utf8" > /etc/locale.conf

echo "kirito" >vim /etc/hostname

rm /etc/mkinitcpio.conf
cp mkinitcpio.conf /etc/
mkinitcpio -P

echo enter a root password
passwd

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=archGrub --recheck
rm /etc/default/grub
cp grub /etc/default/
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
cryptsetup close SYSTEM

reboot
