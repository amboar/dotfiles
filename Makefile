.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

.PHONY: install
install: check-dependencies install-dotfiles install-envrcs

.PHONY: check-dependencies
check-dependencies:
	command -v ccache
	command -v clangd
	command -v direnv
	command -v docker
	command -v flatpak
	command -v wget

.PHONY: install-dotfiles
install-dotfiles: \
	${HOME}/.bashrc \
	${HOME}/.config/helix/config.toml \
	${HOME}/.config/gdb/gdbinit \
	${HOME}/.gitconfig \
	${HOME}/.inputrc \
	${HOME}/.local/bin/ccache/arm-linux-gnueabihf-gcc \
	${HOME}/.local/bin/ccache/arm-linux-gnueabihf-g++ \
	${HOME}/.local/bin/clang-format-16 \
	${HOME}/.local/bin/clang-format-17 \
	${HOME}/.local/bin/clang-tidy-16 \
	${HOME}/.local/bin/clang-tidy-17 \
	${HOME}/.local/bin/marksman \
	${HOME}/.local/bin/openbmc-format \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/bin/yaml-language-server \
	${HOME}/.local/bin/zola \
	${HOME}/.local/share/meson/cross/aarch64 \
	${HOME}/.local/share/meson/cross/arm \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.local/share/meson/cross/gcc-13-aarch64 \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \
	${HOME}/.vimrc \

CCACHE = $(shell command -v ccache)

${HOME}/.local/bin/ccache/%: $(CCACHE)
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	[ -z "$<" ] || ln -sf $< $@

${HOME}/.local/bin/marksman-linux-x64:
	wget --quiet --directory-prefix=$(dir $@) https://github.com/artempyanykh/marksman/releases/download/2023-11-29/marksman-linux-x64
	echo "279e8d0cb36ea2bf571231437277b13b88821fd7c7d2473b6c24f05630cc2c47bf1cba177e6446f9bb83b67fa19e0ac4a909fcce92fefdb57715cae7ee5910e1  $@" | sha512sum --check
	chmod +x $@

${HOME}/.local/bin/marksman: ${HOME}/.local/bin/marksman-linux-x64
	ln -s $< $@

${HOME}/.local/bin/yaml-language-server: local/bin/yaml-language-server
	docker pull quay.io/redhat-developer/yaml-language-server:1.14.0
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

${HOME}/.local/bin/zola: local/bin/zola
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub org.getzola.zola
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

.PHONY: install-envrcs
install-envrcs: \
	${HOME}/src/kernel.org/linux/openbmc/build.aspeed_g4/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.multi_v5/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.aspeed_g4/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.multi_v5/.envrc \
	${HOME}/src/u-boot.org/u-boot/u-boot/build.gxp/.envrc \


${HOME}/%/.envrc: %/envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
