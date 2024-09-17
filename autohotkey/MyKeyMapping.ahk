; Mapping Caps Lock key to <Esc> in vscode,vim,idea 
If WinActive("Visual Studio Code") or WinActive("vim") or WinActive("IntelliJ IDEA Community Edition") {
    CapsLock::Esc
}
