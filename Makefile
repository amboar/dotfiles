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
	${HOME}/.local/bin/openbmc-format \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \
	${HOME}/.var/app/com.helix_editor.Helix/config/helix/languages.toml \


${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

.PHONY: install-nvim-packer
install-nvim-packer: ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
	@[ -d $< ] || \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim

.PHONY: install-helix-vim
install-helix-vim: ${HOME}/.var/app/com.helix_editor.Helix/config/helix
	@[ -f $< ] || \
		wget --directory-prefix=$< https://raw.githubusercontent.com/LGUG2Z/helix-vim/75b99c3086cb6943fb4074042881378bbf31898a/config.toml

.PHONY: install-envrcs
install-envrcs: \
	${HOME}/src/kernel.org/linux/build.aspeed_g5/.envrc \


${HOME}/%/.envrc: %/envrc
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
