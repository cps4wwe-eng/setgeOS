# Compiladores y ensamblador
CC := x86_64-linux-gnu-gcc
LD := x86_64-linux-gnu-gcc
ASMC := nasm

# Flags de compilación y linkeo
CFLAGS := -O2 -g -Wall -Wextra -std=c11 -ffreestanding -m64 -march=x86-64 -mcmodel=kernel
LDFLAGS := -nostdlib -static -T linker.ld

# Carpetas
SRCDIR := src
OBJDIR := build/lib
BUILDDIR := build/bin
ISOBUILDDIR := build/iso_root
ISODIR := build/image

# Archivos fuente
CFILES := $(wildcard $(SRCDIR)/*.c)

# Archivos objeto (solo C)
OBJS := $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(CFILES))

KERNEL := kernel.elf
ISO := limine-cd.iso

# Regla principal
all: kernel buildimg

# Compilación de C
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

# Linkeo del kernel
kernel: $(OBJS)
	@mkdir -p $(BUILDDIR)
	$(LD) $(LDFLAGS) -o $(BUILDDIR)/$(KERNEL) $(OBJS)

# Construcción de la ISO con Limine
buildimg:
	@mkdir -p $(ISOBUILDDIR)
	@cp $(BUILDDIR)/$(KERNEL) $(ISOBUILDDIR)
	@cp limine.cfg $(ISOBUILDDIR)
	@cp limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin $(ISOBUILDDIR)
	@xorriso -as mkisofs -b limine-cd.bin \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		--efi-boot limine-cd-efi.bin \
		-efi-boot-part --efi-boot-image --protective-msdos-label \
		$(ISOBUILDDIR) -o $(ISODIR)/$(ISO)

# Limpieza
clean:
	@rm -rf $(OBJDIR)/*
	@rm -rf $(BUILDDIR)/*
	@rm -rf $(ISOBUILDDIR)/*
	@rm -rf $(ISODIR)/*

# Setup inicial
setup:
	@mkdir -p $(OBJDIR) $(BUILDDIR) $(ISOBUILDDIR) $(ISODIR)
	@git clone https://github.com/limine-bootloader/limine.git --branch v3.0-branch-binary --depth=1
	@cp limine/limine.sys limine/limine-cd.bin limine/limine-cd-efi.bin $(ISOBUILDDIR)

.PHONY: all kernel buildimg clean setup
