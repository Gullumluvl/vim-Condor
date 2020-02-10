# Syntax highlighting for HTCondor control files

[HTCondor](https://github.com/htcondor/htcondor) is a computing cluster scheduler.

See `man condor_submit` for the syntax of submission files.

Recognizes (non exhaustive list):

- All commands listed in the manpage,
- Queue commands,
- argument quoting,
- macros,
- comments.

# Autodetection

The autodetection of the filetype works for all files with `.condor.txt` or `.condor`
extension. If needed, modify accordingly the `ftdetect/Condor.vim` commands.

# Installing

I personally use [Tim Pope's Pathogen](https://github.com/tpope/vim-pathogen)
as my plugin manager (and recommend it).

With Pathogen, simply clone this repository inside `~/.vim/bundle/`.

# Disclaimer

Likely buggy, but it fits my needs so far.

