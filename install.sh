SCRIPT_PATH="$( cd "$( dirname "$0"  )" && pwd  )"
ln -f $SCRIPT_PATH/.bashrc $HOME/.bashrc
ln -f $SCRIPT_PATH/.bash-prompt.sh $HOME/.bash-prompt.sh
ln -f $SCRIPT_PATH/.gitconfig $HOME/.gitconfig
ln -f $SCRIPT_PATH/.git-prompt.sh $HOME/.git-prompt.sh
ln -f $SCRIPT_PATH/.git-completion.sh $HOME/.git-completion.sh
ln -f $SCRIPT_PATH/.profile $HOME/.profile
mv $HOME/.ssh $HOME/.ssh.bk
ln -f -s $SCRIPT_PATH/.ssh $HOME/.ssh
