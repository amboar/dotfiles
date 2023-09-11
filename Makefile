.PHONY: all
all:
	@echo Run \`make install\` to deploy dotfile symlinks

install: \
	${HOME}/.bashrc \
	${HOME}/.config/nvim/init.vim \
	${HOME}/.gitconfig \
	${HOME}/.inputrc \
	${HOME}/.tigrc \
	${HOME}/.tmux.conf \


${HOME}/.%: %
	[ -z "$(dir $@)" ] || mkdir -p "$(dir $@)"
	ln -s $(realpath $<) $@
