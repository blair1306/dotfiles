all: tmux zsh emacs

tmux:
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf

zsh: zshrc
	ln -sf $(CURDIR)/zshrc ~/.zshrc

emacs: init.el
	mkdir ~/.emacs.d
	ln -sf $(CURDIR)/init.el ~/.emacs.d/init.el

