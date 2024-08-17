SOURCE = ctof.asm
OUTPUT = boot.bin

LOG_MONITOR = -monitor stdio
SERIAL = -serial file:serial_log

ASM = nasm
QEMU = qemu-system-i386

OPTIONS = $(LOG_MONITOR)

ASM_FLAGS = -f bin

all: $(OUTPUT)

$(OUTPUT): $(SOURCE)
	$(ASM) $(ASM_FLAGS) $< -o $@

run: $(OUTPUT)
	$(QEMU) $(SERIAL) -hda $(OUTPUT)

clean:
	rm -f $(OUTPUT)
