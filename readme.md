Surface Pro 12Inch Gen 1. Device tree development

Current status:

### Warning: may have issues with charging. During the development of this I bricked 2 laptops. For now I am charging purely with a phone charger and mostly charging when machine is off due to caution. May be resolved already.

To protect your battery, going into bios->boot->enable battery limit, will limit charging to 50% of max.

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
|Buttons          | ❌ (power button only)    |
|Performance Modes| Normal, Power Saving   |
|ADSP(Audio Proc) | ✓  |
|CDSP(npu)        | ❌ |
|Cameras          | ❌   | 


## How to:
The included files are useful, put them where they are needed

## Patches
The patches folder includes patches to apply on top of linux repo

## Updates (April 26)
Havent had any recent issues with charging, do turn on charging limit in bios anyway.

Fixed:
1) Backlight randomly on or off when loading (DTS now includes vreg_edp_3p3: regulator-boot-on)
2) Speaker damage due to lack of power limiting ([This Patch](https://lore.kernel.org/all/177686906300.36226.17703920373519139645.b4-ty@b4/)(Included in /patches))
3) UFS randomly failing to attach during boot (make sure your tree includes [These Patches](https://lore.kernel.org/all/20260103-ufs_symbol_clk-v2-0-51828cc76236@oss.qualcomm.com/))

Current issues:
1) no camera support yet
2) cdsp (npu) doesnt respond to fastrpc requests