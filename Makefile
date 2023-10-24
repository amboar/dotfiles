.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

.PHONY: install
install: install-dotfiles install-envrcs

.PHONY: install-dotfiles
install-dotfiles: \
	${HOME}/.bashrc \
	${HOME}/.config/helix/config.toml \
	${HOME}/.gitconfig \
	${HOME}/.inputrc \
	${HOME}/.local/bin/clang-format-16 \
	${HOME}/.local/bin/clang-format-17 \
	${HOME}/.local/bin/clang-tidy-16 \
	${HOME}/.local/bin/clang-tidy-17 \
	${HOME}/.local/bin/openbmc-format \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/share/meson/cross/aarch64 \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.local/share/meson/cross/gcc-13-aarch64 \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \


${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

.PHONY: install-envrcs
install-envrcs: \
	${HOME}/src/kernel.org/linux/build.aspeed_g5/.envrc \


${HOME}/%/.envrc: %/envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
