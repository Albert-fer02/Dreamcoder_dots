.PHONY: install test stow clean verify help

MODULES := shell kitty ghostty nvim tmux gitconfig fastfetch zellij fish nushell claude opencode

help:
	@echo "Dreamcoder Dotfiles - Makefile"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  install    Install packages and deploy configs"
	@echo "  stow       Deploy configs via GNU Stow"
	@echo "  unstow     Remove symlinks"
	@echo "  test       Run validation tests"
	@echo "  verify     Verify installation"
	@echo "  clean      Remove backups and logs"

install:
	./scripts/install.sh

stow:
	@for m in $(MODULES); do \
		echo "Stowing $$m..."; \
		stow -R -t $$HOME $$m 2>/dev/null || echo "Skip $$m"; \
	done

unstow:
	@for m in $(MODULES); do \
		echo "Unstowing $$m..."; \
		stow -D -t $$HOME $$m 2>/dev/null || true; \
	done

test:
	@./tests/run_all.sh

verify:
	@./scripts/verify.sh

clean:
	rm -rf install.log verify.log
	rm -rf $$HOME/.config/dreamcoder-backup-*
