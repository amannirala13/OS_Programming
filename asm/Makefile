SOURCE = bootloader.asm
OUTPUT = boot.bin

ASM = nasm
QEMU = qemu-system-x86_64

ASM_FLAGS = -f bin

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	$(ASM) $(ASM_FLAGS) $< -o $@

run: $(OUTPUT)
	$(QEMU) -hda $(OUTPUT)

clean:
	rm -f $(OUTPUT)
