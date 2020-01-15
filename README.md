# XMM7360 modem to USB

Note: This is a fork of https://github.com/juhovh/xmm7360_usb which adds an easier DKMS-based installation
routine for `make`.

This is basically a kernel module version of the python script `xmm2usb` found
in [James Wah's repository](https://github.com/abrasive/xmm7360). Please be
aware that this is a hacky approach that results the device to be reported by
lcpci -v as:

```
02:00.0 Wireless controller [0d40]: Intel Corporation XMM7360 LTE Advanced Modem (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: xmm7360_usb
```
or
```
02:00.0 Wireless controller [0d40]: Intel Corporation Device 7360 (rev ff) (prog-if ff)
	!!! Unknown header type 7f
	Kernel driver in use: xmm7360_usb
	Kernel modules: xmm7360_usb
```
This is because the module disables the PCIe root port link, breaking all
communication to the device, but the entry stays there because it has a driver
in use. It should be pretty harmless though, and can be fixed by simply
unloading the module with `rmmod` (which will also revert all changes though).

I have tested this to work with my Lenovo X1 Carbon (7th Gen) and do not
guarantee it to work on any other laptop. Improvements are welcome though.

## Installation

**WARNING: There is a risk of bricking your laptop so you better know what you
are doing from here onwards, remember you were warned.**

Simply run the following:

```
sudo make dkms_install
sudo modprobe xmm7360_usb
```

Then after the modem boots in USB mode follow the instructions in the [original
repository](https://github.com/abrasive/xmm7360) to unlock the modem and set it
to MBIM mode. Just to document it here as well, what worked for me was
connecting to the serial using `screen /dev/ttyACM0` and executing the following commands. Keep in mind that you don't see
what you copy&paste or write into the connected screen, but you get a response when pressing enter.
Run those commands below, line by line and note the output values of the commands with an `?` at the end, so you
can reverse those commands later if needed, to restore your modem.
After the last command is executed, the screen terminates itself and the modem reboots and is then useable after some seconds in
the ModemManager.

```
at@nvm:fix_cat_fcclock.fcclock_mode?
at@nvm:fix_cat_fcclock.fcclock_mode=0
at@store_nvm(fix_cat_fcclock)
AT+GTUSBMODE?
AT+GTUSBMODE=7
AT+CFUN?
AT+CFUN=15
```

Everything simply worked on my machine from that onwards, and the automatically
loaded module makes sure that the modem stays in USB mode even through reboots.
