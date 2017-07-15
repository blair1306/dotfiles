all: tmux zsh emacs cgdb

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

