.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

.PHONY: install
install: check-dependencies install-dotfiles install-envrcs install-kconfigs install-python

.PHONY: check-dependencies
check-dependencies:
	command -v ccache
	command -v clangd
	command -v direnv
	command -v docker
	command -v flatpak
	command -v python3
	command -v wget

.PHONY: install-dotfiles
install-dotfiles: \
	${HOME}/.bashrc \
	${HOME}/.config/b4/templates/bmc-tree-am.template \
	${HOME}/.config/ccache/ccache.conf \
	${HOME}/.config/evolution/accels \
	${HOME}/.config/fish/config.fish \
	${HOME}/.config/halloy/config.toml \
	${HOME}/.config/halloy/themes/Gruvbox.toml \
	${HOME}/.config/helix/config.toml \
	${HOME}/.config/helix/languages.toml \
	${HOME}/.config/gdb/gdbinit \
	${HOME}/.config/git/config \
	${HOME}/.config/tig/config \
	${HOME}/.config/tmux/tmux.conf \
	${HOME}/.gnupg/gpg.conf \
	${HOME}/.gnupg/gpg-agent.conf \
	${HOME}/.gnupg/sshcontrol \
	${HOME}/.inputrc \
	${HOME}/.local/bin/ccache/arm-linux-gnueabihf-gcc \
	${HOME}/.local/bin/ccache/arm-linux-gnueabihf-g++ \
	${HOME}/.local/bin/ccache/aarch64-linux-gnueabihf-gcc \
	${HOME}/.local/bin/ccache/aarch64-linux-gnueabihf-g++ \
	${HOME}/.local/bin/ccache/clang \
	${HOME}/.local/bin/ccache/clang++ \
	${HOME}/.local/bin/ci \
	${HOME}/.local/bin/clang-format-16 \
	${HOME}/.local/bin/clang-format-17 \
	${HOME}/.local/bin/clang-tidy-16 \
	${HOME}/.local/bin/clang-tidy-17 \
	${HOME}/.local/bin/heihei \
	${HOME}/.local/bin/marksman \
	${HOME}/.local/bin/openbmc-format \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/bin/yaml-language-server \
	${HOME}/.local/bin/zola \
	${HOME}/.local/share/fish/functions/fish_prompt.fish \
	${HOME}/.local/share/meson/cross/aarch64 \
	${HOME}/.local/share/meson/cross/arm \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.local/share/meson/cross/gcc-13-aarch64 \
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

${HOME}/.config/evolution/accels: config/evolution/accels
	cp $< $@

${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

LINUX_ARM_GCC_ENVRCS = \
	${HOME}/src/kernel.org/linux/mctp/build.arm.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.aspeed_g4/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.multi_v5/.envrc \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.multi_v7/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.arm.aspeed_g4/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.arm.aspeed_g5/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.arm.multi_v5/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.arm.multi_v7/.envrc

LINUX_ARM64_GCC_ENVRCS = \
	${HOME}/src/kernel.org/linux/openbmc/build.arm64.default/.envrc \
	${HOME}/src/kernel.org/linux/origin/build.arm64.default/.envrc

UBOOT_ARM_ENVRCS = \
	${HOME}/src/u-boot.org/u-boot/u-boot/build.gxp/.envrc \
	
.PHONY: install-envrcs
install-envrcs: $(LINUX_ARM_GCC_ENVRCS) $(LINUX_ARM64_GCC_ENVRCS) $(UBOOT_ARM_ENVRCS)


$(LINUX_ARM_GCC_ENVRCS): src/kernel.org/linux/arm-gcc-envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

$(LINUX_ARM64_GCC_ENVRCS): src/kernel.org/linux/arm64-gcc-envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

$(UBOOT_ARM_ENVRCS): src/u-boot.org/u-boot/arm-envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

LINUX_CONFIGS = \
	${HOME}/src/kernel.org/linux/mctp/build.arm.aspeed_g5/.config \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.aspeed_g4/.config \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.aspeed_g5/.config \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.multi_v5/.config \
	${HOME}/src/kernel.org/linux/openbmc/build.arm.multi_v7/.config \
	${HOME}/src/kernel.org/linux/openbmc/build.arm64.default/.config \
	${HOME}/src/kernel.org/linux/origin/build.arm.aspeed_g4/.config \
	${HOME}/src/kernel.org/linux/origin/build.arm.aspeed_g5/.config \
	${HOME}/src/kernel.org/linux/origin/build.arm.multi_v5/.config \
	${HOME}/src/kernel.org/linux/origin/build.arm.multi_v7/.config \
	${HOME}/src/kernel.org/linux/origin/build.arm64.default/.config \

.PHONY: install-kconfigs
install-kconfigs: $(LINUX_CONFIGS)

$(LINUX_CONFIGS): ${HOME}/%/.config: %/config
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	cp $< $@

.PHONY: install-python
install-python: ${HOME}/.local/bin/python

${HOME}/.local/bin/python: $(shell command -v python3)
	ln -s $< $@
