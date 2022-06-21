
mkdir -p $HOME/.termux
cat << EOF | tee $HOME/.termux/termux.properties
extra-keys = [[ \\
{key: ESC, popup: {macro: "ESC :q ENTER", display: "quit"}}, \\
{key: TAB, popup: {macro:"ESC :w ENTER", display:"save"}}, \\
{key: "~", popup: "="}, \\
{key: "/", popup: "BACKSLASH"}, \\
{key: ":", popup: ";"}, \\
{key: "!", popup: {macro: "ESC :!", display: "cmd"}}, \\
{key: "-", popup: "_"}, \\
{key: KEYBOARD, popup: {macro: "ESC SPACE F5", display: "run"}} \\
]]
EOF
termux-reload-settings
