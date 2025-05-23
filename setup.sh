# setting up things on an ubuntu machine

echo "apt update"
sudo apt update

echo "setup python using pyen + adding to bash + restarting shell"
curl -fsSL https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
echo "install python build dependencies"
exec "$SHELL"
sudo apt update; sudo apt install -y build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo "setup homebrew, e.g. to install language server"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> /home/phil/.bashrc
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/phil/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "install pipx"
sudo apt install -y pipx
pipx ensurepath

sudo mkdir -p /etc/apt/keyrings

# install node js version 22 using apt
#curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
#echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
#

echo "install node js"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
source $HOME/.bashrc
nvm install node

echo "install other tools"
sudo apt install -y cmake gettext ripgrep fd-find fzf unzip luarocks 

mkdir $HOME/dev/
mkdir $HOME/downloads/

echo "install neovim"
# git clone https://github.com/neovim/neovim.git $HOME/dev/neovim
cd $HOME/dev/neovim
git checkout stable
## install under home not default
rm -r build/ # clear the CMake cache
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
make install
export PATH="$HOME/neovim/bin:$PATH"

echo "allow JavaScript/TypeScript-based tools to interact with Neovim"
sudo npm install -g neovim

echo "setup lazy vim"
cd $HOME/downloads/
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
cd $HOME

echo "install ranger and tldr"
pipx install ranger-fm tldr

# nerd fonts on WSL
# download a font on nerd fonts and right click and install "for all users"! (menu extended, i.e. old menue)
echo "Check for nerd fonts, first should be github"
echo -e "\uF09B \uF120 \uE0B0"


echo "allow using sunburn color on WSL"
export COLORTERM=truecolor` in bashrc
#
# TODO
# - docker
#   - use docker
# - marp presentations
