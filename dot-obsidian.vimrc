nmap j gj
nmap k gk

imap kj <Esc>l

nmap <ESC> :nohl<CR>
set clipboard=unnamed

exmap ftop obcommand editor:focus-top
nmap <C-k> :ftop<CR>
exmap fbottom obcommand editor:focus-bottom
nmap <C-j> :fbottom<CR>
exmap fleft obcommand editor:focus-left
nmap <C-h> :fleft<CR>
exmap fright obcommand editor:focus-right
nmap <C-l> :fright<CR>

exmap back obcommand app:go-back
nmap <C-i> :back<CR>

exmap forward obcommand app:go-forward
nmap <C-o> :forward<CR>

unmap <Space>

exmap rename obcommand workspace:edit-file-title
nmap <Space>rn :rename

exmap save obcommand editor:save-file
nmap <Space>w :save<CR>

exmap follow obcommand editor:follow-link
nmap gf :follow<CR>

exmap tleftbar obcommand app:toggle-left-sidebar
nmap <Space>e :tleftbar<CR>

exmap ins_temp obcommand templater-obsidian:insert-templater
nmap <Space>tt :ins_temp<CR>

exmap daily obcommand daily-notes
nmap <Space>dn :daily<CR>

exmap vsplit obcommand workspace:split-vertical
nmap <Space>! :vsplit<CR>

exmap hsplit obcommand workspace:split-horizontal
nmap <Space>" :hsplit<CR>

exmap explorer obcommand switcher:open
nmap <Space>ff :explorer<CR>

exmap q obcommand workspace:close

exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround single_quotes surround ' '
exmap surround_backticks surround ` `

map [[ :surround_wiki
nunmap s
vunmap s
map s" :surround_double_quotes
map s' :surround_single_quotes
map s` :surround_backticks
