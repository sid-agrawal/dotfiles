Steps to do when setting up a new machine using `ansible`:

Install:
- openssh-server
- git
- ansible

Other steps:
- ssh-keygen
- git clone git@github.com:sid-agrawal/dotfiles.git

- run the ansible playbook

TODO:
- User name is harded codes to siagraw, need to use ansible vars to make that a parameter
- emacs is commented out
- git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install