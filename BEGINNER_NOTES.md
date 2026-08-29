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

## Reading key notation

Neovim docs and config files write key names inside angle brackets, so that
multi-character names are unambiguous. You write these in config; you press the
actual key.

```text
<CR>       the Enter/Return key ("carriage return")
<Esc>      Escape
<Tab>      Tab
<BS>       Backspace
<Space>    the spacebar
<C-n>      Ctrl and n pressed together
<S-Tab>    Shift and Tab pressed together
<leader>   the leader key, which is Space in this config
```

So `<leader>sf` means: press Space, then s, then f. See `:help key-notation`
for the full list.

## Editing comfort keys

A few of Vim's defaults have rough edges. These are smoothed over in `init.lua`.

Scrolling and searching now keep the cursor in the middle of the screen:

```text
C-d / C-u   scroll half a screen down / up, recentred
n / N       next / previous search result, recentred
```

By default the cursor can land on the very first or last visible line after a
jump, leaving you to reorient. Recentring keeps the surrounding code in view.

In visual mode:

```text
< / >   indent the selection and keep it selected
p       paste over the selection without losing what you copied
```

Vim normally drops out of visual mode after a single indent, so indenting three
levels means reselecting twice. Now you can just press `>` again.

The `p` change fixes a common surprise. Normally, pasting over selected text
replaces your clipboard with the text that was overwritten, so pasting the same
thing a second time gives you the wrong content. Now the overwritten text is
discarded and your copy survives.

Two other defaults changed:

```text
long lines no longer wrap, they run off the right edge instead
pressing Enter inside a comment no longer starts another comment line
```

## Leader key

In this config, the leader key is `Space`.

Useful project search shortcuts:

```text
Space s f      find/open files
Space s g      search text across the project
Space Space    switch between open buffers/files
```

## Searching with Telescope

Telescope is a fuzzy finder. It opens a floating prompt, you type, and it narrows
a list of results as you go. Press `Enter` to open the highlighted one.

Most of these start with `Space s`, for "search":

```text
Space s f      files by name
Space s g      text across the whole project (grep)
Space s w      the word currently under the cursor
Space s d      LSP errors and warnings
Space s h      Neovim help pages
Space s k      every keybinding in this config
Space s c      commands
Space s n      files in this Neovim config
Space s r      reopen the last search with the query intact
Space s .      recently opened files
Space s s      every Telescope picker available
```

Two that do not follow the `s` pattern:

```text
Space Space    switch between open buffers
Space /        fuzzy search inside the current file
```

When you forget a keybinding, `Space s k` searches all of them. To see what else
Telescope can do, `Space s s` lists every picker.

### Keys inside a search prompt

```text
C-n / C-p   next / previous result
Enter       open
C-v         open in a vertical split
C-x         open in a horizontal split
C-t         open in a new tab
C-u / C-d   scroll the preview pane
Tab         mark several results at once
C-q         send all results to the quickfix list
C-/         show all available keys
C-c         close
```

### Narrowing a search

The prompt understands a few operators:

```text
'exact      match literally, no fuzzy matching
^src        must start with
.java$      must end with
!test       exclude matches
foo | bar   match either
```

For example, in `Space s g`, typing `CbxFactory !test` finds `CbxFactory`
everywhere except test files.

### Reading the results list

Results show the filename first and the folder it lives in second. Without that,
every file in a project starts with the same long path and the part you actually
care about is pushed off the right edge of the window.

`Space s f` includes hidden dotfiles, but skips folders that only hold generated
output:

```text
.git/   .gradle/   build/   node_modules/   .venv/
```

Files in those folders can still be opened directly by path with `:e` if you
ever need one.

### Switching buffers

`Space Space` opens the buffer list. It starts in normal mode, so you can move
with `j` and `k` immediately without typing anything, and the buffer you used
most recently sits at the top.

```text
Enter   switch to that buffer
d       close that buffer
```

Closing buffers from this list is easier than remembering `:bdelete`.

### Git pickers

These search git rather than the filesystem, so they all need the current
directory to be inside a git repository.

```text
Space g f   files tracked by git, so generated files never appear
Space g s   files with uncommitted changes, with a diff preview
Space g c   commit history, with the diff of each commit
Space g C   commit history for the current file only
Space g b   branches, with Enter to check one out
```

Note the capital in `Space g C`. Lowercase `c` is every commit in the repository,
uppercase `C` is only the commits that touched the file you have open.

`Space g C` is the one worth remembering. It answers "how did this file end up
like this" without wading through unrelated history.

## Code intelligence with LSP

LSP stands for Language Server Protocol. A "language server" is a separate
background program that actually parses your code and understands its structure:
where something is defined, everywhere it is used, what type it is. Neovim on its
own only sees text, so the language server is what makes features like go-to-
definition and rename possible.

This matters for searching, because grep only matches text. `Space s g` finds the
letters you typed. The keys below ask the language server a structural question
instead, which is more accurate.

```text
grd   go to where this is defined
grr   list every reference to it
gri   go to its implementation
grt   go to its type definition
gO    outline of the symbols in this file
gW    search symbols across the whole project
grn   rename it everywhere
gra   code action (offer available fixes)
C-t   jump back to where you came from
```

`g` is Vim's "goto" prefix, which is why most of these start with it.

These only work in files that have a language server running. Servers are
installed with Mason:

```vim
:Mason
```

Run `:checkhealth vim.lsp` to see which servers are active for the current file.
If nothing happens when you press `grd`, it usually means no server is installed
for that language yet.

### Navigating errors and warnings

Problems reported by a language server are called diagnostics. The term covers
errors, warnings, hints, and information, not just errors.

Most of these keys are Neovim built-ins rather than part of this config:

```text
]d      next diagnostic in this file
[d      previous diagnostic
]D      last diagnostic in the file
[D      first diagnostic
C-w d   show the full message for the diagnostic under the cursor
```

This config opens the message automatically when you jump, so `]d` both moves
the cursor and shows the text. `C-w d` is for when you moved the cursor yourself.

To see them as a list instead:

```text
Space q     diagnf  cstics for the current file, in the location list
Space s d   diagnostics across the whole project, via Telescope
```

Once a list is open you can walk it without leaving your file:

```text
]l / [l     next / previous location list entry
]q / [q     next / previous quickfix entry
```

In `Space s d`, pressing `C-q` sends every result to the quickfix list, which is
useful for working through a lot of problems in a row.

Note that `]d` jumps to the next diagnostic of any severity, not only errors. A
schema warning in a JSON file counts as one, so `]d` is not the same thing as
"next error".

Messages appear at the end of the affected line. There is a commented
alternative in `init.lua` that renders them on their own line underneath
instead, which reads better for long messages.

## File sidebar with Neo-tree

This config uses Neo-tree as its file sidebar, opened as a panel down the left
side of the screen.

Open and close it with the backslash key:

```text
\       open the sidebar and highlight the current file
\       press again inside the sidebar to close it
```

Useful keys inside the sidebar:

```text
?           show every available key (start here)
Enter       open file / expand folder
s           open in a vertical split
S           open in a horizontal split
t           open in a new tab
P           preview a file without leaving the sidebar
a           add a file; end the name with / to make a folder instead
r           rename
d           delete
c / m       copy / move
y x p       yank, cut, paste
H           show/hide dotfiles
/           filter the tree
Backspace   collapse folder / go up
z           collapse everything
q           close
```

Neo-tree has three views, cycled with `<` and `>`, or opened directly:

```vim
:Neotree filesystem
:Neotree buffers
:Neotree git_status
```

`filesystem` is the file tree and the default, `buffers` shows only your open
files, and `git_status` shows files changed in git.

### The git view

`git_status` lists only files with uncommitted changes, nested under just enough
folders to locate them. If the repository is clean, or the folder is not a git
repository at all, the view is empty apart from its header. That is expected
rather than a failure, and is the usual reason this view looks like it does
nothing.

From this view you can also run git commands against the file under the cursor:

```text
ga    stage this file
gu    unstage this file
gt    toggle staged / unstaged
A     stage everything
gc    commit
gp    push
gg    commit and push
gU    undo the last commit
gr    revert this file, discarding your changes
```

Take care with `gr`. It throws away uncommitted work with no undo, and it sits
right next to `ga`. `gg` pushes immediately rather than only committing.

Each view has its own keys, so `?` shows a different list depending on which
view is currently open.

### Diagnostics and following the current file

Files with LSP errors or warnings are marked in the sidebar, and the counts roll
up onto their parent folders. That means you can tell something is broken
somewhere inside a folder without expanding it first.

The tree also follows whichever file you are editing. Switch files and the tree
expands and highlights the new one, so your position in the project stays
visible without pressing `\` again.

The extra columns on the right, such as file size and last modified, only appear
once the sidebar is wide enough to fit them. On a narrow sidebar they are hidden
rather than squashed into the filenames.

Neovim's built-in explorer, `netrw`, is still available if you prefer it:

```vim
:Lexplore
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

With the Neo-tree sidebar on the left:

```text
C-w h   move left from the file to the sidebar
C-w l   move right from the sidebar to the file
```

Some window commands also have command-line equivalents. For example:

```text
C-w h
```

is like:

```vim
:wincmd h
```

There are also shorter versions of the four movement commands:

```text
C-h   same as C-w h
C-j   same as C-w j
C-k   same as C-w k
C-l   same as C-w l
```

One caveat when running inside tmux: `~/.tmux.conf` claims `C-k` without passing
it through, so tmux consumes that key and Neovim never receives it. Use `C-w k`
to move up instead. The other three work either way.

## Markdown files

Markdown files are rendered as you edit them. Headings are styled, bullets get
proper markers, code blocks are shaded, and tables are drawn with lines, rather
than showing raw `#` and backtick characters.

Only the display changes. The file on disk still contains ordinary markdown
text, so nothing about the file itself is different.

Rendering also switches off for whichever line the cursor is on, so you can
always see and edit the real characters underneath.

This applies to any `.md` file, including this one.

## Avro and JSON files

Neovim does not recognize Avro file extensions on its own, so this config
registers them. See the `vim.filetype.add` call at the end of the options
section in `init.lua`.

```text
.avsc   Avro schema     treated as JSON
.avpr   Avro protocol   treated as JSON
.avdl   Avro IDL        its own filetype, avro-idl
```

`.avsc` and `.avpr` are ordinary JSON documents, so they get the JSON treesitter
parser and everything that comes with it: highlighting, folding, and indent.

`.avdl` is a different language, closer to Java in shape. It is highlighted by
`syntax/avro-idl.vim`, which is Apache Avro's own Vim syntax file, copied into
this config from the Avro project:

```text
https://github.com/apache/avro/blob/main/share/editors/avro-idl.vim
```

Two things to expect in `.avdl` files:

- There is no treesitter parser for Avro IDL, so highlighting uses Vim's older
  regex-based syntax engine. Treesitter-only features like structural folding
  and text objects are not available there.
- That syntax file was last updated in 2010, so newer IDL syntax may not be
  highlighted. Unrecognized words simply appear unstyled; nothing breaks.

To check what Neovim thinks the current file is:

```vim
:set filetype?
```

Schema files are currently highlighted but not checked for correctness.
Installing a JSON language server would add live validation of `.avsc` files
against the published Avro schema definition, so mistakes get flagged as you
type rather than at build time.
