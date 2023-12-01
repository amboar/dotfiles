.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

.PHONY: install
install: install-dotfiles install-envrcs

.PHONY: install-dotfiles
install-dotfiles: \
	${HOME}/.bashrc \
	${HOME}/.config/helix/config.toml \
	${HOME}/.config/gdb/gdbinit \
	${HOME}/.gitconfig \
	${HOME}/.inputrc \
	${HOME}/.local/bin/clang-format-16 \
	${HOME}/.local/bin/clang-format-17 \
	${HOME}/.local/bin/clang-tidy-16 \
	${HOME}/.local/bin/clang-tidy-17 \
	${HOME}/.local/bin/marksman \
	${HOME}/.local/bin/openbmc-format \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/share/meson/cross/aarch64 \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.local/share/meson/cross/gcc-13-aarch64 \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \
	${HOME}/.vimrc \

${HOME}/.local/bin/marksman-linux-x64:
	wget --quiet --directory-prefix=$(dir $@) https://github.com/artempyanykh/marksman/releases/download/2023-11-29/marksman-linux-x64
	echo "279e8d0cb36ea2bf571231437277b13b88821fd7c7d2473b6c24f05630cc2c47bf1cba177e6446f9bb83b67fa19e0ac4a909fcce92fefdb57715cae7ee5910e1  $@" | sha512sum --check
	chmod +x $@

${HOME}/.local/bin/marksman: ${HOME}/.local/bin/marksman-linux-x64
	ln -s $< $@

${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

.PHONY: install-envrcs
install-envrcs: \
	${HOME}/src/kernel.org/linux/build.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/build.multi_v5/.envrc \


${HOME}/%/.envrc: %/envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
