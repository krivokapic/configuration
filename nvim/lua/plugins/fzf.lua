return {
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = {},
    config = function()
      require("fzf-lua").setup({
        actions = {
	  files = {
	   ["enter"] = FzfLua.actions.file_tabedit
	  }
        }
      })
    end,
  }
}
