

all: tmux zsh emacs cgdb vim gdb fish

tmux:
	git clone https://github.com/gpakosz/.tmux.git ~/.tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf
	tmux source ~/.tmux.conf

emacs: init.el
	mkdir ~/.emacs.d
	ln -sf $(CURDIR)/init.el ~/.emacs.d/init.el

cgdb: cgdbrc
	mkdir ~/.cgdb
	ln -sf $(CURDIR)/cgdbrc ~/.cgdb/cgdbrc

vim: vimrc
	mkdir -p ~/.vim/autoload ~/.vim/bundle && \
		curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
	ln  -sf $(CURDIR)/vimrc ~/.vimrc
	git clone https://github.com/tpope/vim-fugitive ~/.vim/bundle/vim-fugitive
	git clone https://github.com/scrooloose/nerdtree ~/.vim/bundle/nerdtree
	git clone https://github.com/tpope/vim-surround ~/.vim/bundle/vim-surround
	git clone https://github.com/kien/ctrlp.vim ~/.vim/bundle/ctrlp.vim
	git clone https://github.com/altercation/vim-colors-solarized ~/.vim/bundle/vim-colors-solarized
	git clone https://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar
	git clone https://github.com/ervandew/supertab ~/.vim/bundle/supertab
	git clone https://github.com/rking/ag.vim ~/.vim/bundle/ag.vim
	git clone https://github.com/valloric/youcompleteme ~/.vim/bundle/YouCompleteMe
	git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline
	git clone https://github.com/scrooloose/syntastic ~/.vim/bundle/syntastic
	git clone https://github.com/scrooloose/nerdcommenter.git ~/.vim/bundle/nerdcommenter

gdb: gdbinit
	ln -sf $(CURDIR)/gdbinit ~/.gdbinit

fish:
	#sudo apt-get install fish
	#git clone https://github.com/oh-my-fish/oh-my-fish ~/workspace/opensource/oh-my-fish
	#~/workspace/opensource/oh-my-fish/bin/install --offline

	omf install bang-bang
	omf install cmorrel
	omf install fish_logo
	OMF_CONFIG := ~/.config/omf/
	ln -sf $(CURDIR)/init.fish $OMF_CONFIG/init.fish
	ln -sf $(CURDIR)/before.init.fish $OMF_CONFIG/before.init.fish
