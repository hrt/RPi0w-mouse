#!/bin/bash
# Snippet from https://github.com/girst/hardpass-sendHID/blob/master/README.md . In which, the following notice was left:

# this is a stripped down version of https://github.com/ckuethe/usbarmory/wiki/USB-Gadgets - I don't claim any rights

modprobe libcomposite
cd /sys/kernel/config/usb_gadget/
mkdir -p g1
cd g1
echo 0xc1ce > idVendor
echo 0xbaa3 > idProduct
echo 0x0100 > bcdDevice
echo 0x0200 > bcdUSB

# composite class / subclass / proto (needs single configuration)
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol

mkdir -p strings/0x409
echo "deadbeef01234567890" > strings/0x409/serialnumber
echo "example.com" > strings/0x409/manufacturer
echo "Generic USB Mouse" > strings/0x409/product
N="usb0"
mkdir -p functions/hid.$N
echo 2 > functions/hid.$N/protocol
echo 1 > functions/hid.$N/subclass
echo 6 > functions/hid.$N/report_length
echo -ne \\x05\\x01\\x09\\x02\\xa1\\x01\\x09\\x01\\xa1\\x00\\x05\\x09\\x19\\x01\\x29\\x03\\x15\\x00\\x25\\x01\\x95\\x03\\x75\\x01\\x81\\x02\\x95\\x01\\x75\\x05\\x81\\x03\\x05\\x01\\x09\\x30\\x09\\x31\\x15\\x81\\x25\\x7f\\x75\\x08\\x95\\x02\\x81\\x06\\xc0\\xc0 > functions/hid.$N/report_desc
C=1
mkdir -p configs/c.$C/strings/0x409
echo "Config $C: ECM network" > configs/c.$C/strings/0x409/configuration 
echo 250 > configs/c.$C/MaxPower 
ln -s functions/hid.$N configs/c.$C/
ls /sys/class/udc > UDC
