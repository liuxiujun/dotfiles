# Windows
``` powershell
# clone dotfiles repo
cd $HOME
git clone git@github.com:liuxiujun/dotfiles.git 
```

### PowerShell
``` powershell
# (Run as Administrator) 
# vim $profile
sudo New-Item -ItemType SymbolicLink -Path $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 -Target $HOME\dotfiles\powershell\Microsoft.PowerShell_profile.ps1
```

### Vim 
``` powershell
# (Run as Administrator) Create a link of vim config to home
sudo New-Item -ItemType SymbolicLink -Path $HOME\vimfiles -Target $HOME\dotfiles\vim

# Set VIMRC user environment variables
[Environment]::SetEnvironmentVariable("VIMRC", $HOME + "\vimfiles\vimrc", "User")

# Get Windows environment variables list
[Environment]::GetEnvironmentVariables()

# Install plug.vim
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni $HOME/vimfiles/autoload/plug.vim -Force
```

### NeoVim
``` powershell
# (Run as Administrator) 
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim -Target $HOME\dotfiles\nvim
```

### Intellij IDEA .ideavimrc
IDEA Plugins:
`IdeaVim`, `AceJump`, `IdeaVim-EasyMotion`, `Which-Key`

IDEA Keymaps: 
> `Up`      :   Ctrl+k  
> `Down`    :   Ctrl+j  
> `Left`    :   Ctrl+h  
> `Right`   :   Ctrl+l  

``` powershell
# Run as Administrator
New-Item -ItemType SymbolicLink -Path $HOME\.ideavimrc -Target $HOME\dotfiles\.ideavimrc
```
### eclipse vrapper plugin
``` powershell
# Run as Administrator
New-Item -ItemType SymbolicLink -Path $HOME\.vrapperrc -Target $HOME\dotfiles\.vrapperrc
```

### WSL2
``` powershell
# Run as Administrator
New-Item -ItemType SymbolicLink -Path $HOME\.wslconfig -Target $HOME\dotfiles\.wslconfig
```

### Git
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $HOME\.gitconfig -Target $HOME\dotfiles\.gitconfig
```

### Win-vind
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $HOME\.win-vind\.vindrc -Target $HOME\dotfiles\.vindrc
```

### mpv
``` powershell
# https://mpv.io/manual/stable/#files-on-windows
# ~/.config/mpv/input.conf consists of a list of key bindings
sudo New-Item -ItemType SymbolicLink -Path $HOME\.config\mpv\input.conf -Target $HOME\dotfiles\input.conf
```

### NPM
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $HOME\.npmrc -Target $HOME\dotfiles\.npmrc
```

# Linux
``` bash
cd $HOME
git clone git@github.com:liuxiujun/dotfiles.git
```
### Vim
``` bash
ln -s ~/dotfiles/vim ~/.vim 

echo 'export VIMRC=$HOME/.vim/vimrc' >> ~/.zshrc

echo $VIMRC

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### NeoVim
``` bash
ln -s ~/dotfiles/nvim ~/.config/nvim
```

### Terminal Proxy
``` bash
sudo tee -a ~/.profile << EOF
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
EOF
```

### IdeaVim
IDEA Plugins:
`IdeaVim`, `AceJump`, `IdeaVim-EasyMotion`, `Which-Key`

IDEA Keymaps: 
> `Up`      :   Ctrl+k  
> `Down`    :   Ctrl+j  
> `Left`    :   Ctrl+h  
> `Right`   :   Ctrl+l  
``` bash
ln -s ~/dotfiles/.ideavimrc ~/.ideavimrc
```

### Git
``` bash
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
```

### NPM
``` bash
ln -s ~/dotfiles/.npmrc ~/.npmrc
```

### IBUS
``` bash
# 中文输入法
sudo apt install ibus-pinyin ibus-libpinyin
# 한국어 input method
sudo apt install ibus-hangul
```

### Vim clipboard
``` bash
sudo apt install vim-gtk3

# sudo update-alternatives --install /usr/bin/vim vim /usr/bin/vim/gtk3 100

# choose gtk3
sudo update-alternatives --config vim
```

### wps输入中文
``` bash
sudo tee -a /usr/bin/wps /usr/bin/et << EOF
export XMODIFIERS="@im=ibus"
export QT_IM_MODULE="ibus"
EOF
```
