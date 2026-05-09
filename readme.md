Surface Pro 12Inch Gen 1. Device tree development

Current status:

|**Hardware** |**SP12**|
|:---------------:|:----:|
|Keyboard |   ✓    |
|Touchpad | ✓    | 
|Lid     | ✓   |
|Touchscreen      | ✓   |
|Backlight      | ✓   |
|GPU      |  ✓ (mesa 25.3.0)  | 
|Pen              | ✓   |
|WiFi             | ✓ (run fixwifi.sh and reboot)   |
|Bluetooth        | ✓   | 
|Speakers         | ✓ | 
|Suspend          | ✓    |
|UFS hard drive   | ✓   |
|Hibernate        | ?   | 
|Battery Status   | ✓   | 
|Buttons          |  ✓    |
|Performance Modes| Normal, Power Saving   |
|ADSP(Audio Proc) | ✓  |
|CDSP(npu)        |  ✓  |
|Cameras          |  ✓   | 


## How to:
0) un-encrypt your disk by removing windows bitlocker
1) create a liveusb from the latest arm64 ubuntu version
2) copy the non el2 dtb from /boot/ into your new liveusb somewhere where grub can see it
3) when starting the installer, press E to edit the startup script
4) add `devicetree path/to/dtb` to the grub script
5) press control X to boot the liveusb
6) install ubuntu onto device
7) copy the files from this repository into the new partition, following the paths of the files
8) not sure from here, but fix grub config to point to the new kernels and devicetree

## Patches
The patches folder includes patches to apply on top of linux repo

## Updates (April 26)
Havent had any recent issues with charging, do turn on charging limit in bios anyway.

## Update (May 9th)
Fixed a bunch of stuff

Fixed:
1) Backlight randomly on or off when loading (DTS now includes vreg_edp_3p3: regulator-boot-on)
2) Speaker damage due to lack of power limiting ([This Patch](https://lore.kernel.org/all/177686906300.36226.17703920373519139645.b4-ty@b4/)(Included in /patches))
3) UFS randomly failing to attach during boot (make sure your tree includes [These Patches](https://lore.kernel.org/all/20260103-ufs_symbol_clk-v2-0-51828cc76236@oss.qualcomm.com/))
4) front and back cameras are working
5) cdsp(npu) is working
6) touchscreen lag and dropped events fixed

Current issues:
1) needs to be upstreamed
2) create iso
