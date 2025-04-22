# setting up things on an ubuntu machine

sudo apt update

# setup python
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.12-dev

# pipx
sudo apt install -y pipx
pipx ensurepath

sudo mkdir -p /etc/apt/keyrings
# install node js version 22 using apt
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# install several
sudo apt install -y cmake gettext ripgrep fd-find fzf npm unzip luarocks nodejs

mkdir $HOME/dev/
mkdir $HOME/downloads/

# install neovim
git clone https://github.com/neovim/neovim.git $HOME/dev
cd ~/dev/neovim
git checkout stable
## install under home not default
rm -r build/ # clear the CMake cache
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
export PATH="$HOME/neovim/bin:$PATH"

# allow JavaScript/TypeScript-based tools to interact with Neovim
sudo npm install -g neovim

## setup lazy vim
cd $HOME/downloads/
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
cd $HOME

# install ranger and tldr
pipx install ranger-fm tldr

# nerd fonts on WSL
# download a font on nerd fonts and right click and install "for all users"! (menu extended, i.e. old menue)
# check echo -e "\uF09B \uF120 \uE0B0"  first is github
#
# sunburn color on WSL
# `export COLORTERM=truecolor` in bashrc
#
# TODO
# - docker
#   - use docker
# - marp presentations
