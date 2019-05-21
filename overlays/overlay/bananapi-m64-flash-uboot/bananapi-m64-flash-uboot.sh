#!/bin/sh -e

PATH=@path@

echo "Press U-Boot key Banana Pi M64:"
echo "https://bananapi.gitbooks.io/bpi-m64/en/bpi-m64hardwareinterface.html"
echo
echo "Connect this computer with Banana Pi M64 via micro USB cable."
read -p "When done, press Enter. "

sudo sunxi-fel -p spiflash-write 0 @uboot@ 
