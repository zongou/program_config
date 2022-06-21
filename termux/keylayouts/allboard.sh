mkdir -p $HOME/.termux
cat << EOF | tee $HOME/.termux/termux.properties
extra-keys = [[ \\
{key: "CTRL",display: "CTR", popup: "="}, \\
{key: TAB, popup: "BACKSLASH"}, \\
{key: ":", popup: ";"}, \\
{key: "!", popup:{macro:"ESC :!",display:"cmd"}}, \\
{key: "-", popup: "_"}, \\
{key: UP, popup: PGUP}, \\
{key: "LEFT", popup: PGUP}, \\
{key: "UP", popup: PGUP}, \\
{key: "DOWN", popup: PGUP}, \\
{key: "RIGHT", popup: PGUP}, \\
{key: "BKSP", popup: ""} \\
],[ \\
{key: "~", popup: "Q"}, \\
{key: "1", popup: "Q"}, \\
{key: "2", popup: "W"}, \\
{key: "3", popup: "E"}, \\
{key: "4", popup: "Q"}, \\
{key: "5", popup: "T"}, \\
{key: "6", popup: "Y"}, \\
{key: "7", popup: "U"}, \\
{key: "8", popup: "I"}, \\
{key: "9", popup: "O"}, \\
{key: "0", popup: "P"} \\
],[ \\
{key: "q", popup: "Q"}, \\
{key: "w", popup: "W"}, \\
{key: "e", popup: "E"}, \\
{key: "r", popup: "Q"}, \\
{key: "t", popup: "T"}, \\
{key: "y", popup: "Y"}, \\
{key: "u", popup: "U"}, \\
{key: "i", popup: "I"}, \\
{key: "o", popup: "O"}, \\
{key: "p", popup: "P"}, \\
{key: "BACKSLASH", popup: END} \\
],[ \\
{key: " ", popup: "Q"}, \\
{key: "a", popup: "Q"}, \\
{key: "s", popup: "W"}, \\
{key: "d", popup: "E"}, \\
{key: "f", popup: "Q"}, \\
{key: "g", popup: "T"}, \\
{key: "h", popup: "Y"}, \\
{key: "j", popup: "U"}, \\
{key: "k", popup: "I"}, \\
{key: "l", popup: "L"}, \\
{key: "ENTER", popup: "O"} \\
],[ \\
{key: "ESC", popup: "Q"}, \\
{key: " ", popup: "Q"}, \\
{key: "z", popup: "Q"}, \\
{key: "x", popup: "W"}, \\
{key: "c", popup: "E"}, \\
{key: "v", popup: "Q"}, \\
{key: "b", popup: "T"}, \\
{key: "n", popup: "Y"}, \\
{key: "m", popup: "U"}, \\
{key: " ", popup: "U"}, \\
{key: "KEYBOARD", popup: {macro: "ESC SPACE F5",display:"run"}} \\
]]
EOF
termux-reload-settings
