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
Using the latest linux-next kernel, copy ./boot/dtb to /boot/dtb and edit your grub to add devicetree /boot/dtb
audio and sensor install scripts can be run after installation.
recursively copy the files in ./lib/ to /lib/

## Patches
All needed changes beside the dts file are in latest linux-next

## Updates (July 23)
All driver, pen, keyboard fixes are in linux 7.2-rc1, the dts itself is making its way through as well, and may make it to either 7.2 or 7.3
Cameras are not in yet, as it requires some patches that are still in progress.
You should be able to use this repository with linux 7.2

## Updates (June 5)
All driver, pen, keyboard fixes have made it into latest linux-next
If using that kernel, can just the included device tree above.

I have also added a script here called "installsensors.sh" that copies my current sensor setup, that turns on auto-rotate and auto-brightness.
This also enables compass, if anything actually uses it.

The installaudio.sh script will install the needed audio firmware for your device.

Note: if you have problems with audio, and `sudo dmesg` says bus clsh, open alsa-mixer and mute SpkrLeft CPS and SpkrRight CPS, then reboot.

The code for Cameras is working and scattered around, the patches needed are still in flux so once people stop arguing over email I will make sure that the dtb gets ubdated to support those.

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
