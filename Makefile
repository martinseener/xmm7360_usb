obj-m := xmm7360_usb.o

MODVER := 0.1
KVERSION := $(shell uname -r)
KDIR := /lib/modules/$(KVERSION)/build
PWD := $(shell pwd)

default:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

install:
	$(MAKE) -C $(KDIR) M=$(PWD) modules_install

load:
	-/sbin/rmmod xmm7360
	/sbin/insmod xmm7360.ko

dkms_install:
	ln -s $(PWD) /usr/src/xmm7360_usb-$(MODVER)
	cd /var/lib/dkms
	dkms add xmm7360_usb/$(MODVER)
	dkms build xmm7360_usb/$(MODVER)
	dkms install xmm7360_usb/$(MODVER)
	modprobe xmm7360_usb

dkms_remove:
	rmmod xmm7360_usb
	cd /var/lib/dkms
	dkms uninstall xmm7360_usb/$(MODVER)
	dkms remove xmm7360_usb/$(MODVER) --all
	rm /usr/src/xmm7360_usb-$(MODVER)

