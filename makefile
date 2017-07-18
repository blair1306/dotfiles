all: tmux zsh emacs cgdb vim

tmux:
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf
	tmux source ~/.tmux.conf

zsh: zshrc
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	ln -sf $(CURDIR)/zshrc ~/.zshrc

emacs: init.el
	mkdir ~/.emacs.d
	ln -sf $(CURDIR)/init.el ~/.emacs.d/init.el

cgdb: cgdbrc
	mkdir ~/.cgdb
	ln -sf $(CURDIR)/cgdbrc ~/.cgdb/cgdbrc

vim: vimrc
	#mkdir -p ~/.vim/autoload ~/.vim/bundle && \
		curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	ln  -sf $(CURDIR)/vimrc ~/.vimrc
	BUNDLE_DIR := ~/.vim/bundle
	git clone https://github.com/tpope/vim-fugitive $(BUNDLE_DIR)/vim-fugitive
	git clone https://github.com/scrooloose/nerdtree $(BUNDLE_DIR)/nerdtree
	git clone https://github.com/tpope/vim-surround $(BUNDLE_DIR)/vim-surround
	git clone https://github.com/kien/ctrlp.vim $(BUNDLE_DIR)/ctrlp.vim
	git clone https://github.com/altercation/vim-colors-solarized $(BUNDLE_DIR)/vim-colors-solarized
	git clone https://github.com/majutsushi/tagbar $(BUNDLE_DIR)/tagbar
	git clone https://github.com/ervandew/supertab $(BUNDLE_DIR)/supertab
	git clone https://github.com/rking/ag.vim $(BUNDLE_DIR)/ag.vim
	git clone https://github.com/valloric/youcompleteme $(BUNDLE_DIR)/YouCompleteMe
	git clone https://github.com/bling/vim-airline $(BUNDLE_DIR)/vim-airline
	git clone https://github.com/scrooloose/syntastic $(BUNDLE_DIR)/syntastic
	git clone https://github.com/scrooloose/nerdcommenter.git $(BUNDLE_DIR)/nerdcommenter
