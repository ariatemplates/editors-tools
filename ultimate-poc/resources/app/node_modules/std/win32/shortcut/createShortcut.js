var WshShell = WScript.CreateObject("WScript.Shell");

strDesktop = WshShell.SpecialFolders("Desktop");

var oShellLink = WshShell.CreateShortcut(strDesktop + "\\Shortcut Script.lnk");
oShellLink.TargetPath = WScript.ScriptFullName;
oShellLink.WindowStyle = 1;
oShellLink.Hotkey = "CTRL+SHIFT+F";
oShellLink.IconLocation = "notepad.exe, 0";
oShellLink.Description = "Shortcut Script";
oShellLink.WorkingDirectory = strDesktop;
oShellLink.Save();

var oUrlLink = WshShell.CreateShortcut(strDesktop + "\\Microsoft Web Site.url");
oUrlLink.TargetPath = "http://www.microsoft.com";
oUrlLink.Save();
