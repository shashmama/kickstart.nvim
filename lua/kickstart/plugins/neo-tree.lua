-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

require('neo-tree').setup {
  -- Sidebar down the left side of the screen.
  -- `width` is only used by the 'left'/'right' positions.
  window = {
    position = 'left',
    width = 80,
  },
  -- Show LSP error and warning counts beside each file, rolled up onto the
  -- parent folders too, so problems are visible without opening anything.
  enable_diagnostics = true,
  -- Only show these extra columns once the sidebar is wide enough for them,
  -- so a narrow sidebar stays readable instead of being crushed.
  default_component_configs = {
    file_size = { required_width = 64 },
    last_modified = { required_width = 88 },
    created = { required_width = 110 },
    type = { required_width = 122 },
  },
  filesystem = {
    -- Keep the tree in sync with whichever file you are editing, so you never
    -- have to hunt for your current file in the tree.
    follow_current_file = { enabled = true, leave_dirs_open = true },
    window = {
      mappings = {
        ['\\'] = 'close_window',
      },
    },
  },
}
