.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

install: install-nvim-packer \
	${HOME}/.bashrc \
	${HOME}/.config/nvim/init.vim \
	${HOME}/.config/nvim/lua/plugins.lua \
	${HOME}/.config/nvim/lua/lsp.lua \
	${HOME}/.gitconfig \
	${HOME}/.inputrc \
	${HOME}/.local/bin/trixie-meson-exe-wrapper \
	${HOME}/.local/share/meson/cross/gcc-13 \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \


${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@

install-nvim-packer: ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
	@[ -d $< ] || \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim ${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim
