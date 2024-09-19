# Windows
``` powershell
# clone dotfiles repo
cd $HOME
git clone git@github.com:liuxiujun/dotfiles.git 
```

## Vim 
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

## Intellij IDEA .ideavimrc
IDEA Plugins:
`IdeaVim`, `AceJump`, `IdeaVim-EasyMotion`, `Which-Key`

IDEA Keymaps: 
> `Up`      :   Ctrl+k  
> `Down`    :   Ctrl+j  
> `Left`    :   Ctrl+h  
> `Right`   :   Ctrl+l  

``` powershell
# Run as Administrator
New-Item -ItemType SymbolicLink -Path $Env:IDEAVIMRC -Target $HOME\dotfiles\.ideavimrc"
```

## WSL2
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.wslconfig" -Target $Env:USERPROFILE"\dotfiles\.wslconfig"
```

## Git
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.gitconfig" -Target $Env:USERPROFILE"\dotfiles\.gitconfig"
```

## NPM
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.npmrc" -Target $Env:USERPROFILE"\dotfiles\.npmrc"
```

# Linux
``` bash
cd $HOME
git clone git@github.com:liuxiujun/dotfiles.git
```
## Vim
``` bash
ln -s ~/dotfiles/vim ~/.vim 

echo 'export VIMRC=$HOME/.vim/vimrc' >> ~/.zshrc

echo $VIMRC

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

