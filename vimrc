"设置编码"
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

colorscheme onedark
syntax enable

"显示相对行号"
set rnu
set number

"括号匹配"
set showmatch

set cul

"设置tab长度"
set tabstop=2
"自动缩进长度"
set shiftwidth=2
"继承前一行的缩进"
set autoindent

set paste

"显示tab和空格"
set listchars=tab:>-,trail:-

"设置搜索结果高亮"
set hlsearch

"总是显示状态栏"
set laststatus=2
"显示光标当前位置"
set ruler
 
"启用鼠标，新手模式"
set mouse=a
set selection=exclusive
set selectmode=mouse,key

"让vimrc配置变更立即生效"
autocmd BufWritePost $MYVIMRC source $MYVIMRC
