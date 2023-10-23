.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

.PHONY: install
install: install-dotfiles install-envrcs

.PHONY: install-dotfiles
install-dotfiles: install-nvim-packer install-helix-vim \
	${HOME}/.bashrc \
	${HOME}/.config/nvim/init.vim \
	${HOME}/.config/nvim/lua/plugins.lua \
	${HOME}/.config/nvim/lua/lsp.lua \
	${HOME}/.config/nvim/pack/tpope/start/sleuth/doc/sleuth.txt \
	${HOME}/.config/nvim/pack/tpope/start/sleuth/plugin/sleuth.vim \
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

.PHONY: install-nvim-packer
install-nvim-packer: ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
	@[ -d $< ] || \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim

.PHONY: install-helix-vim
install-helix-vim: ${HOME}/.config/helix
	@[ -f $</config.toml ] || \
		wget --directory-prefix=$< https://raw.githubusercontent.com/LGUG2Z/helix-vim/75b99c3086cb6943fb4074042881378bbf31898a/config.toml
	@/usr/bin/sed -Ei 's/^C-o/# \0/' $</config.toml
	@/usr/bin/sed -Ei 's/^C-r/# \0/' $</config.toml
	@/usr/bin/echo -ne '\n' >> $</config.toml
	@/usr/bin/echo '[editor]' >> $</config.toml
	@/usr/bin/echo 'line-number = "relative"' >> $</config.toml

.PHONY: install-envrcs
install-envrcs: \
	${HOME}/src/kernel.org/linux/build.aspeed_g5/.envrc \


${HOME}/%/.envrc: %/envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
