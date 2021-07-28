vim -c 'BundleInstall' -c 'qa'
if [ -n "`uname -a |grep fedora`" ]; then
    sudo dnf install cmake gcc-c++ make python3-devel -y
elif [ -n "`uname -a|grep ubuntu`" ]; then
    sudo apt install build-essential cmake python3-dev -y
fi
cd bundle/YouCompleteMe
python3 install.py --clangd-completer
