# Makefile

# Compiler and linker
ASM = nasm
LD = ld

# Directories
BUILD_DIR = build

# Source files
SRC_FILES = src/board.asm src/player.asm src/main.asm

# Object files
OBJ_FILES = $(SRC_FILES:%.asm=$(BUILD_DIR)/%.o)

# Output executable
OUTPUT = $(BUILD_DIR)/tic_tac_toe

# Assembly flags
ASM_FLAGS = -f elf32

# Linker flags
LD_FLAGS = -m elf_i386 -e _start

# Default target
all: $(OUTPUT)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Build object files
$(BUILD_DIR)/%.o: %.asm | $(BUILD_DIR)
	mkdir -p $(dir $@)
	$(ASM) $(ASM_FLAGS) -o $@ $<

# Link object files
$(OUTPUT): $(OBJ_FILES)
	$(LD) $(LD_FLAGS) -o $@ $(OBJ_FILES)

# Clean build directory
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean