#!/bin/bash

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Setup directories
mkdir -p ~/.tmux/plugins

# Clone tmux plugin manager
echo "[+] Setting up tmux...."
if [[ ! -d ${HOME}/.tmux/plugins/tpm ]]; then
	git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
else
	echo "[+] TPM already cloned"
fi
echo "[+} Start new tmux session and run prefix + I"

echo "[+] Setting up vim"
if [[ ! -d ${HOME}/.vim/pack/minpac ]]; then
	git clone https://github.com/k-takata/minpac.git ${HOME}/.vim/pack/minpac/opt/minpac
else
	echo "[+] Minpac already cloned..."
fi

for i in .tmux.conf .vimrc;
do
	ln -sf ${script_home}/$i ${HOME}/$i
	echo "[+] Symlinked $i to ${HOME}/$i"
done

vim -c "PackUpdate" README.md
echo "[+] Trying install YouCompleteMe..."
cd ${HOME}/.vim/pack/minpac/start/YouCompleteMe
git submodule update --init --recursive
python install.py
cd -

echo "[+] You need to go to ~/.vim/pack/minpac/start/YouCompleteMe and run the"
echo "[+] install.py script (needs cmake and build-essentials and python dev)"
echo "[+] if you want the omnicompletion in vim and the installer above failed"
