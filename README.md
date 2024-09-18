## Vim (Windows)
``` powershell
# Set VIMRC user environment variables
[Environment]::SetEnvironmentVariable("VIMRC", $Env:USERPROFILE + "\vimfiles\vimrc", "User")
[Environment]::SetEnvironmentVariable("IDEAVIMRC", $Env:USERPROFILE + "\.ideavimrc", "User")
# Get Windows environment variables list
[Environment]::GetEnvironmentVariables()

cd $Env:USERPROFILE
git clone git@github.com:liuxiujun/vimfiles.git 
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
New-Item -ItemType SymbolicLink -Path $Env:IDEAVIMRC -Target $Env:USERPROFILE"\vimfiles\ideavimrc"
```

## Vim (Linux)
``` bash
git clone git@github.com:liuxiujun/vimfiles.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc 

echo 'export VIMRC=$HOME/.vimrc' >> ~/.profile
```
