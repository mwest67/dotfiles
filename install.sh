#!/bin/bash

script_home="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in zsh git vim curl python;
do
    which $i >/dev/null
    if [[ $? != 0 ]]; then
      echo "[!] $i not found please run installer script for platform"
      exit 1
    fi
done

touch ${HOME}/.custom_host_config

#Oh my zsh
if [[ ! -d ${HOME}/.oh-my-zsh ]]; then
  echo "[+] Installing oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo "[!] Oh My Zsh already appears to be installed"
fi

for i in .tmux.conf .vimrc .zshrc;
do
	ln -sf ${script_home}/$i ${HOME}/$i
	echo "[+] Symlinked $i to ${HOME}/$i"
done

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

vim -c "PackUpdate" README.md

if [[ ! -f ~/.vim/pack/minpac/start/YouCompleteMe/third_party/ycmd/ycm_core.so ]]; then
  echo "[+] Trying install YouCompleteMe..."
  cd ${HOME}/.vim/pack/minpac/start/YouCompleteMe
  git submodule update --init --recursive
  python install.py
  cd -
else
  echo "[+] YouCompleteMe already seems to be built"
fi

echo "[+] You need to go to ~/.vim/pack/minpac/start/YouCompleteMe and run the"
echo "[+] install.py script (needs cmake and build-essentials and python dev)"
echo "[+] if you want the omnicompletion in vim and the installer above failed"
