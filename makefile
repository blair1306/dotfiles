all: tmux zsh emacs

tmux:
	git clone -C ~ https://github.com/gpakosz/.tmux.git
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf

zsh: zshrc
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	ln -sf $(CURDIR)/zshrc ~/.zshrc

emacs: init.el
	mkdir ~/.emacs.d
	ln -sf $(CURDIR)/init.el ~/.emacs.d/init.el

