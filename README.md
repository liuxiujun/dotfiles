# vimfiles

## Vim (Windows)
``` powershell
# Powershell
cd $Env:USERPROFILE
git clone git@github.com:liuxiujun/vimfiles.git 
# Set $VIMRC user environment variable
[Environment]::SetEnvironmentVariable("VIMRC", $Env:USERPROFILE + "\vimfiles\vimrc", "User")
# Get Windows environment variables list
[Environment]::GetEnvironmentVariables()
```

## Vim (Linux)
``` bash
git clone git@github.com:liuxiujun/vimfiles.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc 
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
New-Item -ItemType SymbolicLink -Path "C:\Users\liuxi\.ideavimrc" -Target "C:\Users\liuxi\vimfiles\ideavimrc"
```
