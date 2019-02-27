#!/bin/bash

GITPATH=git@github.com:wcdawn/dotfiles.git
CONFIGPATH=$HOME/dotfiles/
CONFIGBACKUP=$HOME/dotfiles_backup/

git clone --bare $GITPATH $CONFIGPATH
function config {
   /usr/bin/git --git-dir=$CONFIGPATH --work-tree=$HOME $@
}
mkdir -p $CONFIGBACKUP
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $CONFIGBACKUP{}
fi;
config checkout
config config status.showUntrackedFiles no
