vim.pack.add {
  "https://github.com/uhs-robert/sshfs.nvim",
}

require("sshfs").setup {
  host_paths = {
    -- Optionally define default mount paths for specific hosts
    -- These are shown in addition to global_paths
    -- Single path (string):
    -- ["my-server"] = "/var/www/html"
    --
    -- Multiple paths (array):
    -- ["dev-server"] = { "/var/www", "~/projects", "/opt/app" }
    ['10.97.32.101'] = '~/hari',
    ['10.97.32.122'] = '~/hari',
    ['10.97.32.105'] = '~/hari',
  },
  hooks = {
    on_exit = {
      auto_unmount = false, -- auto-disconnect all mounts on :q or exit
    },
  },
}
