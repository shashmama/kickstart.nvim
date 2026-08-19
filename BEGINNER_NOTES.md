# Beginner Neovim Notes

## Opening a project

Open Neovim from the project root so file search, grep, LSP, and other project tools work relative to that project.

Example:

```bash
cd ~/Documents/Projects/hello-world
nvim .
```

Open a specific file directly:

```bash
nvim app.py
```

Or from inside Neovim:

```vim
:e app.py
```

## Basic survival keys

```text
i        enter insert mode
Esc      leave insert mode
:w       save
:q       quit
:wq      save and quit
:q!      quit without saving
```

## Leader key

In this config, the leader key is `Space`.

Useful project search shortcuts:

```text
Space s f      find/open files
Space s g      search text across the project
Space Space    switch between open buffers/files
```

## File sidebar with Lexplore

Kickstart does not include an IntelliJ-style sidebar by default, but Neovim has a built-in file explorer called `netrw`.

Open/toggle a left sidebar:

```vim
:Lexplore
```

Useful keys inside Lexplore:

```text
Enter   open file/folder
-       go up a folder
%       create file
d       create directory
D       delete
R       rename
```

## Switching panes/windows

In Neovim, panes are called windows.

`C-w` means `Ctrl-w`; it is Vim's built-in window command prefix.

Conceptually:

```text
Space = custom leader prefix
C-w   = built-in window/pane command prefix
:     = command-line / Ex command mode
```

Useful window commands:

```text
C-w h   move to left window
C-w l   move to right window
C-w j   move to window below
C-w k   move to window above
C-w w   cycle through windows
C-w q   close current window
C-w =   equalize window sizes
C-w s   horizontal split
C-w v   vertical split
```

With `:Lexplore`:

```text
C-w h   move from file to sidebar
C-w l   move from sidebar to file
```

Some window commands also have command-line equivalents. For example:

```text
C-w h
```

is like:

```vim
:wincmd h
```
