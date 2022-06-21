RunWait("cmd /c mkdir "& $userhome_value &"", @ScriptDir, @SW_HIDE)
Local $iPID = Run('cmd /c echo '& $userhome_value &'', '', @SW_HIDE, 2); $STDOUT_CHILD
If @error Or Not $iPID Then Exit
Local $sStdOut = ""

Do
  Sleep(10)
  $sStdOut &= StdoutRead($iPID)
Until @error

MsgBox(0, '', $sStdOut)