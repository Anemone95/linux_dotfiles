SCRIPT_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
ln -f -s $SCRIPT_PATH/.bashrc $HOME/.bashrc
ln -f -s $SCRIPT_PATH/.bash-prompt.sh $HOME/.bash-prompt.sh
ln -f -s $SCRIPT_PATH/.gitconfig $HOME/.gitconfig
ln -f -s $SCRIPT_PATH/.git-prompt.sh $HOME/.git-prompt.sh
ln -f -s $SCRIPT_PATH/.git-completion.sh $HOME/.git-completion.sh
ln -f -s $SCRIPT_PATH/.profile $HOME/.profile
ln -f -s $SCRIPT_PATH/.netrc $HOME/.netrc
cp $SCRIPT_PATH/.bashrc.local $HOME/.bashrc.local
mkdir -p $HOME/.local/bin
if [ -e $HOME/.ssh ];then
    echo "Backup ~/.ssh to ~/.ssh.bk"
    mv $HOME/.ssh $HOME/.ssh.bk
fi
ln -s -f $SCRIPT_PATH/ssh ~/.ssh
chmod 600 ~/.ssh/*
