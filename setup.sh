# setting up things on an ubuntu machine

sudo apt update

# setup python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.12-dev

# pipx
sudo apt install pipx -y
pipx ensurepath

# install cmake and gettext
sudo apt install cmake gettext ripgrep fd-find fzf npm unzip -y

mkdir dev/
# install neovim
git clone git@github.com:neovim/neovim.git ~/dev
cd ~/dev/neovim
git checkout stable

# install under home not default
rm -r build/ # clear the CMake cache
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
export PATH="$HOME/neovim/bin:$PATH"

## setup lazy vim
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/

# install ranger and tldr
pipx install ranger-fm tldr
