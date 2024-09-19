# Windows
``` powershell
# clone dotfiles repo
cd $Env:USERPROFILE
git clone git@github.com:liuxiujun/dotfiles.git 
```

## Vim 
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\vimfiles" -Target $Env:USERPROFILE"\dotfiles\vim"

# Set VIMRC user environment variables
[Environment]::SetEnvironmentVariable("VIMRC", $Env:USERPROFILE + "\vimfiles\vimrc", "User")
# Get Windows environment variables list
[Environment]::GetEnvironmentVariables()
```

## Intellij IDEA
IDEA Plugins:
`IdeaVim`, `AceJump`, `IdeaVim-EasyMotion`, `Which-Key`

IDEA Keymaps: 
> `Up`      :   Ctrl+k  
> `Down`    :   Ctrl+j  
> `Left`    :   Ctrl+h  
> `Right`   :   Ctrl+l  

``` powershell
# Run as Administrator
New-Item -ItemType SymbolicLink -Path $Env:IDEAVIMRC -Target $Env:USERPROFILE"\dotfiles\.ideavimrc"

# Set IDEAVIMRC environment variable
[Environment]::SetEnvironmentVariable("IDEAVIMRC", $Env:USERPROFILE + "\.ideavimrc", "User")
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
## Vim
``` bash
git clone git@github.com:liuxiujun/dotfiles.git
ln -s ~/dotfiles/vim ~/.vim 

echo 'export VIMRC=$HOME/.vim/vimrc' >> ~/.profile
```

