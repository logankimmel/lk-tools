#!/bin/bash
IP=$1
scp tmux_rpms.zip root@$IP:

ssh root@$IP <<ENDSSH
unzip tmux_rpms.zip
mv tmux_rpms/tmux-1.8.tar.gz /root/tmux-1.8.tar.gz
mv tmux_rpms/libevent-2.0.21-stable.tar.gz /root/libevent-2.0.21-stable.tar.gz
tar zxvf tmux-1.8.tar.gz
tar zxvf libevent-2.0.21-stable.tar.gz
echo "----------------------------------INSTALLING MANUAL RPMS\n-----------------------------------"
pushd /root/tmux_rpms/
rpm -iv --replacefiles ncurses-base-5.7-4.20090207.el6.x86_64.rpm
rpm -iv --replacefiles ncurses-libs-5.7-4.20090207.el6.x86_64.rpm
rpm -iv --replacefiles ncurses-devel-5.7-4.20090207.el6.x86_64.rpm
rpm -iv --replacefiles cpp-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles libgcc-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles libgomp-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles gcc-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles libgfortran-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles gcc-gfortran-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles kernel-devel-2.6.32-573.3.1.el6.x86_64.rpm
rpm -iv --replacefiles libstdc++-4.4.7-16.el6.x86_64.rpm
rpm -iv --replacefiles libstdc++-devel-4.4.7-16.el6.x86_64.rpm

popd

# cd to libevent2 src
cd libevent-2.0.21-stable
./configure --prefix=/usr/local
make && make install

# cd to tmux src
cd ../tmux-1.8
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make && make install

cd ~/
export PATH=$PATH:/usr/local/bin

rm -rf tmux-1.8 libevent-2.0.21-stable tmux-1.8.tar.gz libevent-2.0.21-stable.tar.gz
echo "set-option -g status-utf8 on
set-option -g status-justify right
set-option -g status-bg black # colour213 # pink
set-option -g status-fg cyan
set-option -g status-interval 5
set-option -g status-left-length 30
set-option -g status-left '#[fg=magenta]» #[fg=cyan,bold]#T#[default]'
set-option -g status-right '#[fg=red,bold][[ #(git branch) branch ]] #[fg=cyan]»» #[fg=blue,bold]###S #[fg=magenta]%R %m-%d#(acpi | cut -d ',' -f 2)#[default]'
set-option -g visual-activity on

# Titles (window number, program name, active (or not)
set-option -g set-titles on
set-option -g set-titles-string '#H:#S.#I.#P #W #T'" > ~/.tmux.conf

#History in tmux
echo "export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r\n" >> /root/.bashrc

ENDSSH
echo ""
echo "------------------"
echo "Installed tmux 1.8"
echo "------------------"
echo ""
