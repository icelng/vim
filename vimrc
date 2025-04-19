" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif



" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
        if has("syntax")
            syntax on
        endif
        set backspace=2                " 设置退格键可用
        set mouse-=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set vb t_vb=
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse-=a                    " 在任何模式下启用鼠标
        set vb t_vb=
        if exists('+termguicolors')     " 真彩
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
        else
            set t_Co=256                   " 256色
        endif
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif

" 不同模式该表光标样式
let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" 更新时间
set updatetime=100

" leader 重映射
let mapleader = ","

" 栈方式跳转
set jumpoptions+=stack

" -----------------------------------------------------------------------------
"  < tmux 配置>
" -----------------------------------------------------------------------------


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vundle 插件管理工具配置 >
" -----------------------------------------------------------------------------
" 用于更方便的管理vim插件，具体用法参考 :h vundle 帮助
" Vundle工具安装方法为在终端输入如下命令
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
" 如果想在 windows 安装就必需先安装 "git for window"，可查阅网上资料

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    set rtp+=~/.vim/vundle.git/
    call vundle#rc()
else
    set rtp+=~/.vim/vundle.git/
    call vundle#rc('$VIM/vimfiles/bundle/')
endif


" 以下为要安装或更新的插件（具体书写规范请参考帮助）
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'airblade/vim-gitgutter'
Bundle 'rhysd/git-messenger.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'vim-airline/vim-airline'
Bundle 'majutsushi/tagbar'
Bundle 'taglist.vim'
Bundle 'ycm-core/YouCompleteMe'
" Bundle 'octol/vim-cpp-enhanced-highlight'
Bundle 'voldikss/vim-translator'
Bundle 'easymotion/vim-easymotion'
Bundle 'editorconfig/editorconfig-vim'


" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
"set foldenable                                        "启用折叠
"set foldmethod=indent                                 "indent 折叠方式
" set foldmethod=marker                                "marker 折叠方式

" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 当文件在外部被修改，自动更新该文件
set autoread

" 常规模式下输入 cS 清除行尾空格
nmap cS :%s/\s\+$//g<CR>:noh<CR>

" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

" Ctrl + v 粘贴
"jnmap <c-v> "+gp

" Ctrl + c 复制
"nmap <c-c> "+y

" Ctrl + K 插入模式下光标向上移动
imap <c-k> <Up>

" Ctrl + J 插入模式下光标向下移动
imap <c-j> <Down>

" Ctrl + H 插入模式下光标向左移动
imap <c-h> <Left>

" Ctrl + L 插入模式下光标向右移动
imap <c-l> <Right>

" 启用每行超过80列的字符提示
set colorcolumn=120

"let g:loaded_matchparen=1
"hi MatchParen ctermbg=Yellow guibg=lightblue

"调整窗口大小
nmap <Leader><Up> :res +5<CR>
nmap <Leader><Down> :res -5<CR>
nmap <Leader><Left> :vertical resize -5<CR>
nmap <Leader><Right> :vertical resize +5<CR>

" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=1                                       "设置命令行的高度为2，默认为1
set cursorline                                        "突出显示当前行
" set guifont=YaHei_Consolas_Hybrid:h10                 "设置字体:字号（字体名称空格用下划线代替）
set guifont=Monospace\ 12

set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面

" 设置 gVim 窗口初始位置及大小
if g:isGUI
     "au GUIEnter * simalt ~x                           "窗口启动时自动最大化
    winpos 80 50                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=53 columns=182                          "指定窗口大小，lines为高度，columns为宽度
endif

" 设置代码配色方案
if g:isGUI
    "syntax enable
    "colorscheme solarized
    "set background=dark
    "colorscheme Molokai
    colorscheme Tomorrow-Night-Eighties               "Gvim配色方案
else
    syntax on
    "set background=dark
    "colorscheme solarized
    "colorscheme Molokai
    colorscheme Tomorrow-Night-Eighties               "终端配色方案
    "colorscheme dracula
endif

hi Normal guibg=NONE ctermbg=NONE    "  背景与终端一致
"let g:rehash256=1
"let g:molokai_original=1



" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
" set noswapfile                              "设置无临时文件
" set vb t_vb=                                "关闭提示音
noremap <c-k> <c-w>k
noremap <c-j> <c-w>j
noremap <c-h> <c-w>h
noremap <c-l> <c-w>l
noremap <c-u> <c-r>

" 高亮尾行
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/

" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================


" -----------------------------------------------------------------------------
"  < c++-enhanced-highlight 插件配置 >
" -----------------------------------------------------------------------------
" c++ 语法高亮
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_concepts_highlight = 1
autocmd! FileType c,cpp,java,php call CSyntaxAfter()


"" -----------------------------------------------------------------------------
"  < gitgutter 插件配置 >
" -----------------------------------------------------------------------------

if !empty(glob("~/.vim/bundle/vim-gitgutter"))
    let g:gitgutter_async = 1
    autocmd BufWritePost * GitGutter
    function! GitStatus()
        let [a,m,r] = GitGutterGetHunkSummary()
            return printf('+%d ~%d -%d', a, m, r)
    endfunction
    set statusline+=%{GitStatus()}
    let g:gitgutter_preview_win_floating = 1
    highlight! link SignColumn LineNr

    function! GetCommitLog(idx)
        let shell_cmd = "git log --oneline |awk '{ if(NR==".a:idx.") print $0 }'"
        let commit_log = trim(system(l:shell_cmd))
        return l:commit_log
    endfunction

    function! GetCommitId(idx)
        let shell_cmd = "git log --oneline |awk '{ if(NR==".a:idx.") print $1 }'"
        let commit_id = trim(system(l:shell_cmd))
        return l:commit_id
    endfunction

    function! DiffBaseByIdx(idx)
        let commit_id = GetCommitId(a:idx + 1)
        let g:gitgutter_diff_base = l:commit_id
        let commit_log = GetCommitLog(a:idx + 1)
        echo "git diff ".l:commit_log
        GitGutter
    endfunction

    command! -nargs=1 GitDiffPre :call DiffBaseByIdx(<args>)
    nmap <Leader>hj :GitGutterNextHunk<CR>
    nmap <Leader>hk :GitGutterPrevHunk<CR>
    nmap <Leader>gd :GitDiffPre
endif

"" -----------------------------------------------------------------------------
"  < git-messenger 插件配置 >
" -----------------------------------------------------------------------------

nmap <Leader>gm :GitMessenger<CR>
let g:git_messenger_close_on_cursor_moved = 0


" -----------------------------------------------------------------------------
"  < ctrlp.vim 插件配置 >
" -----------------------------------------------------------------------------
" 一个全路径模糊文件，缓冲区，最近最多使用，... 检索插件；详细帮助见 :h ctrlp
" 常规模式下输入：Ctrl + p 调用插件
let g:ctrlp_working_path_mode = 'ra'

" -----------------------------------------------------------------------------
"  < emmet-vim（前身为Zen coding） 插件配置 >
" -----------------------------------------------------------------------------
" HTML/CSS代码快速编写神器，详细帮助见 :h emmet.txt

" -----------------------------------------------------------------------------
"  < indentLine 插件配置 >
" -----------------------------------------------------------------------------
" 用于显示对齐线，与 indent_guides 在显示方式上不同，根据自己喜好选择了
" 在终端上会有屏幕刷新的问题，这个问题能解决有更好了
" 开启/关闭对齐线
nmap <leader>il :IndentLinesToggle<CR>

" 设置Gvim的对齐线样式
if g:isGUI
    let g:indentLine_char = "┊"
    let g:indentLine_first_char = "┊"
endif

" 设置终端对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
let g:indentLine_color_term = 239

" 设置 GUI 对齐线颜色，如果不喜欢可以将其注释掉采用默认颜色
" let g:indentLine_color_gui = '#A4E57E'


" -----------------------------------------------------------------------------
"  < easymotion 插件配置 >
" -----------------------------------------------------------------------------
map <Leader> <Plug>(easymotion-prefix)


" -----------------------------------------------------------------------------
"  < nerdcommenter 插件配置 >
" -----------------------------------------------------------------------------
" 我主要用于C/C++代码注释(其它的也行)
" 以下为插件默认快捷键，其中的说明是以C/C++为例的，其它语言类似
" <Leader>ci 以每行一个 /* */ 注释选中行(选中区域所在行)，再输入则取消注释
" <Leader>cm 以一个 /* */ 注释选中行(选中区域所在行)，再输入则称重复注释
" <Leader>cc 以每行一个 /* */ 注释选中行或区域，再输入则称重复注释
" <Leader>cu 取消选中区域(行)的注释，选中区域(行)内至少有一个 /* */
" <Leader>ca 在/*...*/与//这两种注释方式中切换（其它语言可能不一样了）
" <Leader>cA 行尾注释
let NERDSpaceDelims = 1                     "在左注释符之后，右注释符之前留有空格
vmap <c-/> <leader>cc

" -----------------------------------------------------------------------------
"  < nerdtree 插件配置 >
" -----------------------------------------------------------------------------
" 有目录村结构的文件浏览插件

nmap <leader>nt :NERDTreeToggle<CR>

" -----------------------------------------------------------------------------
"  < powerline 插件配置 >
" -----------------------------------------------------------------------------
" 状态栏插件，更好的状态栏效果


" -----------------------------------------------------------------------------
"  < std_c 插件配置 >
" -----------------------------------------------------------------------------
" 用于增强C语法高亮

" 启用 // 注视风格
let c_cpp_comments = 0


" -----------------------------------------------------------------------------
"  < Tagbar 插件配置 >
" -----------------------------------------------------------------------------
" 相对 TagList 能更好的支持面向对象

" 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
nmap tb :TlistClose<CR>:TagbarToggle<CR>

let g:tagbar_width=30                       "设置窗口宽度
" let g:tagbar_left=1                         "在左侧窗口中显示

" -----------------------------------------------------------------------------
"  < TagList 插件配置 >
" -----------------------------------------------------------------------------
" 高效地浏览源码, 其功能就像vc中的workpace
" 那里面列出了当前文件中的所有宏,全局变量, 函数名等

" 常规模式下输入 tl 调用插件，如果有打开 Tagbar 窗口则先将其关闭
nmap tl :TagbarClose<CR>:Tlist<CR>

let Tlist_Show_One_File=1                   "只显示当前文件的tags
" let Tlist_Enable_Fold_Column=0              "使taglist插件不显示左边的折叠行
let Tlist_Exit_OnlyWindow=1                 "如果Taglist窗口是最后一个窗口则退出Vim
"let Tlist_File_Fold_Auto_Close=1            "自动折叠
let Tlist_WinWidth=30                       "设置窗口宽度
let Tlist_Use_Right_Window=1                "在右侧窗口中显示

" -----------------------------------------------------------------------------
"  < vim-translator 插件配置 >
" -----------------------------------------------------------------------------
nmap <Leader>tl :TranslateW<CR>
vmap <Leader>tl <plug>TranslateWV
let g:translator_default_engines=['bing', 'youdao']

" =============================================================================
"                          << 以下为常用自动命令配置 >>
" =============================================================================

" 自动切换目录为当前编辑文件所在目录
au BufRead,BufNewFile,BufEnter * cd %:p:h

" =============================================================================
"                          << 以下为YouCompleteMe配置 >>
" =============================================================================
let g:ycm_confirm_extra_conf = 0      "每次打开vim的时候不询问加载配置文件
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_seed_identifiers_with_syntax = 1  " identifiers取自syntax
let g:ycm_collect_identifiers_from_tags_files = 1 " identifiers取自tags
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_auto_hover=''
let g:ycm_enable_semantic_highlighting=1
let g:ycm_clangd_args = ['--background-index', '-pretty', '-j=16', '--malloc-trim', '--pch-storage=memory' ]
let g:ycm_enable_inlay_hints = 1
"let g:ycm_echo_current_diagnostic = 'virtual-text'
"let g:ycm_clear_inlay_hints_in_insert_mode = 1
highlight YcmErrorSection guibg=#8f0000   guifg=#ffffff
highlight YcmWarningSection guibg=#008f00  guifg=#ffffff
nmap <c-]> :YcmCompleter GoTo<CR>
nmap <c-r> :YcmCompleter GoToReferences<CR>
nmap <leader>df :YcmCompleter GoToDefinition<CR>
nmap <leader>rr :YcmCompleter RefactorRename
vmap <leader>fm :YcmCompleter Format<CR>
nmap <leader>ss <Plug>(YCMFindSymbolInWorkspace)
nmap <leader>ih <Plug>(YCMToggleInlayHints)
nmap <leader>ht <Plug>(YCMTypeHierarchy)
nmap <leader>hc <Plug>(YCMCallHierarchy)
nmap <leader>rs :YcmRestartServer<CR>
nmap <leader>ld :YcmDiags<CR>
nmap <leader>fi :YcmCompleter FixIt<CR>

" =============================================================================
"                          << 以下为UltiSnips配置 >>
" =============================================================================
" let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsEditSplit="vertical"

" quickfix 垂直打开窗口快捷键
autocmd! FileType qf nnoremap <buffer> <c-v> <C-w><Enter><C-w>L
