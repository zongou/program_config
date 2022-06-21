mkdir -p $HOME/.termux
cat << EOF | tee $HOME/.termux/termux.properties
extra-keys = [[ \\
{macro: "~", popup: "="}, \\
{key: "/", popup: "BACKSLASH"}, \\
{key: ":", popup: ";"}, \\
{key: "!", popup:{macro:"ESC :!",display:"cmd"}}, \\
{key: "-", popup: "_"}, \\
{key: UP, popup: PGUP}, \\
{key: "KEYBOARD", popup: {macro: "ESC SPACE F5",display:"run"}} \\
],[ \\
{key: ESC, popup: {macro: "ESC :q ENTER",display: "quit"}}, \\
{key: TAB, popup: {macro: "ESC :w ENTER", display: "save"}}, \\
{key: CTRL, popup: {macro: "ESC :conf SPACE qa ENTER", display: "exit?"}}, \\
{key: ALT, popup: {macro: "CTRL k CTRL u BKSP", display: "clear"}}, \\
{key: LEFT, popup: HOME}, \\
{key: DOWN, popup: PGDN}, \\
{key: RIGHT, popup: END} \\
]]
EOF
termux-reload-settings
