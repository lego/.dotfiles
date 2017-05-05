#!/bin/bash
FILES=`ls -a | tail -n +3`
cd ..
for f in $FILES
do
  if [ $f = 'symlink.sh' ] || [ $f = '.git' ] || [ $f = '.gitignore' ] || [ $f = 'README.md' ]; then
    continue
  fi
  if [ -d $f ]; then
    echo -n "Symlinking $f/ - "
    if [ -e ./$f ]; then
         if [ -h $f ]; then
           echo "already linked"
         else
           echo "exists (could not link)"
         fi
    else
      if ln -s .dotfiles/$f/ ./$f/ 2> /dev/null; then
        echo success
      fi
    fi
  else
    echo -n "Symlinking $f - "
    if [ -e $f ]; then
      if [ -h $f ]; then
        echo "already linked"
      else
        echo "exists (could not link)"
      fi
    else
      if ln -s .dotfiles/$f $f 2> /dev/null; then
        echo success
      fi
    fi
  fi
done
