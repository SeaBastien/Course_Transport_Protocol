# =============================
# Compiler and flags
# =============================
CXX       := g++
CXXFLAGS  := -Wall -Wextra -std=c++17
LDFLAGS   := -lz

# =============================
# Directories
# =============================
INCLUDE_DIR := include
SRC_DIR   := src
BUILD_DIR := build
BIN_DIR   := bin

# =============================
# Targets and source discovery
# Add targets once you start building the project
# =============================
TARGETS   :=

# =============================
# Sender application
# =============================
SRC_FILES := $(wildcard $(SRC_DIR)/*.cc)
OBJ_FILES := $(patsubst $(SRC_DIR)/%.cc,$(BUILD_DIR)/%.o,$(SRC_FILES))
SENDER_BIN := $(BIN_DIR)/sender
SENDER_OBJ := $(OBJ_FILES)
TARGETS    += $(SENDER_BIN)
CXX_INC   := -I$(INCLUDE_DIR)


# =============================
# Default rule
# =============================
all: $(TARGETS)

$(TARGETS):
	$(CXX) $^ -o $@ $(LDFLAGS)

# =============================
# Create bin directory
# =============================
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# =============================
# Compile rules
# =============================
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cc | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(CXX_INC) -c $< -o $@

$(BUILD_DIR)/test_%.o: $(TEST_DIR)/%.cc | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(CXX_INC) -c $< -o $@


# =============================
# Build directories
# =============================
$(SENDER_BIN): $(SENDER_OBJ) $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -I$(INCLUDE_DIR) $(SENDER_OBJ) -o $@ $(LDFLAGS)

# =============================
# Create build directories
# =============================
%.o: %.cc
	$(CXX) $(CXXFLAGS) -I$(INCLUDE_DIR) -c $< -o $@

-include $(wildcard $(BUILD_DIR)/*.d)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# =============================
# Cleaning
# =============================
clean:
	rm -rf $(SENDER_OBJ) $(SENDER_BIN)

.PHONY: all clean test