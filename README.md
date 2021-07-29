# 使用指南
```
# cd ~
# git clone https://github.com/ynglng/vim.git
# mv vim .vim
# cd .vim
# ./setup.sh
```
setup.sh 脚本会做如下事情：
* 通过 git clone 为 Vim 下载一系列插件
* 配置自动补全插件 YouCompleteMe，这期间会通过包管理器(yum,dnf,apt)下载该插件的依赖，并且通过 wget 下载所依赖的 clangd
所以在执行 setup.sh 之前，最好做好翻墙的准备，不然 setup.sh 会执行特别久，其中的 YouCompleteMe 和 Clangd 的下载最耗时。

setup.sh 脚本执行完之后，就可以开心地玩耍 Vim 啦！(￣▽￣)
