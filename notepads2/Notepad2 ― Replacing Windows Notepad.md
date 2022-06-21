_Note: This document explains the technical details how to replace Windows Notepad with Notepad2. As of Notepad2 version 4.2.25, the Notepad2 Setup Tool takes care of this task, and it's no longer necessary to manually perform the steps outlined below._

_Some usage notes to the setup tool can be found in the Notepad2 FAQ: [How to use the Notepad2 Setup Tool to install and update Notepad2?](https://www.flos-freeware.ch/doc/notepad2-FAQs.html#q51)_

> ![](https://www.flos-freeware.ch/doc/setup.png)

Kai Liu has introduced support for replacing Windows Notepad using a clean, unintrusive registry-based method with his [modified version of Notepad2](http://code.kliu.org/misc/notepad2/).

### Replacing Windows Notepad with Notepad2

Replacing Windows Notepad with Notepad2 can be a little tricky since notepad.exe is a protected system file, which makes a direct replacement a bit difficult (though not impossible).

There is an easier way to replace Windows Notepad by using the "Image File Execution Options" registry key to trick Windows into running notepad2.exe whenever notepad.exe is run. This same trick is used by the "Replace Task Manager" function in Microsoft's [Process Explorer](http://technet.microsoft.com/en-us/sysinternals/bb896653.aspx). The benefit to using this method to replace Notepad is that you will not run afoul of Windows File Protection (since you are not actually replacing the executable itself), and you can undo it at any time by simply deleting the registry key. The downside to this method is that it does not work properly with the official Notepad2 build; there are a few minor changes that need to be made to Notepad2 in order for this to work (see my img\_exec\_replace patch).

In order to use this method of Notepad replacement, you will need to follow these steps:

1.  Obtain a build of Notepad2 that supports this form of Notepad replacement.
2.  Create the following registry key: HKLM\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Image File Execution Options\\notepad.exe.
3.  Inside the key, create a new string (REG\_SZ) value, named "Debugger".
4.  Set the data of this new "Debugger" value to the full path to the Notepad2 executable, followed by the /z switch. For example, "C:\\Windows\\Notepad2.exe" /z

Simon Steele describes the [same procedure](http://untidy.net/blog/2009/11/03/replacing-notepad-with-pn-via-image-file-execution-options/) for his text editor [Programmer's Notepad](http://www.pnotepad.org/), and also explains which registry key to use on 64-bit Windows, in case you're using a 32-bit version of Notepad2 on 64-bit Windows.

HKLM\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows NT\\CurrentVersion\\Image File Execution Options

### Replacing Windows Notepad with Notepad2 4.1.24 (or newer)

As of version 4.1.24, the official release of Notepad2 supports this method for replacing Windows Notepad, so the steps outlined above will work fine. However, there's no support to perform the Notepad replacement automatically, as the official release of Notepad2 will not modify the system registry. For the same reason, there's no support for accessing recent files through the Windows 7 jump lists, by default (this requires registration of applications in the system registry, first).

Also be aware that automated Notepad replacement could have undesirable effects if Notepad2 was used as a Notepad replacement from a portable device, and the original state was not restored when disconnecting the device.

A batch script to run from the Notepad2 directory and replace Windows Notepad might look like this (requires elevated privileges):

```
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" /v "Debugger" /t REG_SZ /d "\"%~dp0Notepad2.exe\" /z" /f

```

The Windows Notepad can be restored with this command (requires elevated privileges):

```
reg delete "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" /f

```

### Enable Jump List Support

A few more tweaks are needed to enable recent file access through the jump lists introduced with Windows 7. First, register Notepad2 as an "Open with" handler using the following batch script (run from the Notepad2.exe directory with elevated privileges):

```
reg add "HKCR\*\OpenWithList\Notepad2.exe" /f
reg add "HKCR\Applications\Notepad2.exe" /v "AppUserModelID" /t REG_SZ /d "Notepad2" /f
reg add "HKCR\Applications\Notepad2.exe\shell\open\command" /ve /t REG_SZ /d "\"%~dp0Notepad2.exe\" %%1" /f

```

Next, apply the following changes to the Notepad2.ini file:

```
[Settings2]
...
ShellAppUserModelID=Notepad2
ShellUseSystemMRU=1

```

Recent files now appear in the jump lists. Notepad2 windows are now assigned to a custom AppUserModelID, that's why multiple icons may appear if Notepad2.exe is directly pinned to the taskbar. To fix this, open a Notepad2 window first, and then pin it to the taskbar from the Notepad2 taskbar button context menu.

Unregister the Notepad2 "Open with" handler with the following script (requires elevated privileges):

```
reg delete "HKCR\*\OpenWithList\Notepad2.exe" /f
reg delete "HKCR\Applications\Notepad2.exe" /f

```

___

© [Florian Balmer](http://www.flos-freeware.ch/) 1996-2014  
Page last modified: July 01, 2011