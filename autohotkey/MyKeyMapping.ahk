; vscode,vim,idea 的Caps Lock key 映射成 Esc
If WinActive("Visual Studio Code") or WinActive("vim") or WinActive("IntelliJ IDEA Community Edition") {
    CapsLock::Esc
}