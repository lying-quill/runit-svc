PREFIX ?= /usr/local
SRC_DIR := ./package
FILES := $(shell find $(SRC_DIR) -type f)
INSTALL_PATHS := $(patsubst $(SRC_DIR)/%,$(PREFIX)/%,$(FILES))

NON_EXECUTABLE := conf down LICENSE

all:
	@echo "Run \"make install\" to copy the files to your desired PREFIX."

install: $(INSTALL_PATHS)
	@for f in $(INSTALL_PATHS); do \
		basename_f=$$(basename $$f); \
		if echo "$(NON_EXECUTABLE)" | grep -q "$$basename_f"; then \
			chmod 0644 $$f; \
			echo "  chmod 0644 $$f"; \
		else \
			chmod 0755 $$f; \
			echo "  chmod 0755 $$f"; \
		fi; \
	done

$(PREFIX)/%: $(SRC_DIR)/%
	mkdir -p $(@D)
	cp $< $@

uninstall:
	@for f in $(INSTALL_PATHS); do \
		if [ -f $$f ]; then \
			rm -f $$f && echo "  rm -f $$f"; \
		else \
			echo "  (skipped $$f - not found)"; \
		fi; \
		\
		if rmdir $$(dirname $$f) 2>/dev/null; then \
			echo "  rmdir $$(dirname $$f)"; \
		fi; \
	done

format:
	shfmt -l -w .

ci:
	shfmt -d .
	find $(SRC_DIR) -type f -exec sh -c 'head -n 1 "$$1" | \
		grep -qE "^#!/bin/(ba)?sh$$" && echo "$$1"' _ {} \; | xargs shellcheck

dev:
	shellcheck --version
	shfmt --version
	@for hook in git-hooks/*; do \
		chmod +x $$hook; \
		ln -sf ../../"$$hook" .git/hooks/; \
	done

.PHONY: all install uninstall format ci dev
