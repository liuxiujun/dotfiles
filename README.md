## Vim (Windows)
``` powershell
# clone dotfiles repo
cd $Env:USERPROFILE
git clone git@github.com:liuxiujun/dotfiles.git 

# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\vimfiles" -Target $Env:USERPROFILE"\dotfiles\vim"

# Set VIMRC user environment variables
[Environment]::SetEnvironmentVariable("VIMRC", $Env:USERPROFILE + "\vimfiles\vimrc", "User")
[Environment]::SetEnvironmentVariable("IDEAVIMRC", $Env:USERPROFILE + "\.ideavimrc", "User")
# Get Windows environment variables list
[Environment]::GetEnvironmentVariables()
```

## Intellij IDEA (Windows)
IDEA Plugins:
`IdeaVim`, `AceJump`, `IdeaVim-EasyMotion`, `Which-Key`

IDEA Keymaps: 
> `Up`      :   Ctrl+k  
> `Down`    :   Ctrl+j  
> `Left`    :   Ctrl+h  
> `Right`   :   Ctrl+l  

``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:IDEAVIMRC -Target $Env:USERPROFILE"\dotfiles\.ideavimrc"
```

## Vim (Linux)
``` bash
git clone git@github.com:liuxiujun/dotfiles.git
ln -s ~/dotfiles/vim ~/.vim 

echo 'export VIMRC=$HOME/.vim/vimrc' >> ~/.profile
```

## WSL2 (Windows)
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.wslconfig" -Target $Env:USERPROFILE"\dotfiles\.wslconfig"
```

## Git (Windows)
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.gitconfig" -Target $Env:USERPROFILE"\dotfiles\.gitconfig"
```

## NPM
``` powershell
# Run as Administrator
sudo New-Item -ItemType SymbolicLink -Path $Env:USERPROFILE"\.npmrc" -Target $Env:USERPROFILE"\dotfiles\.npmrc"
```
