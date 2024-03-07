nasm -f bin ./bootloader.asm -o ./boot.bin
qemu-system-x86_64 -hda ./boot.bin