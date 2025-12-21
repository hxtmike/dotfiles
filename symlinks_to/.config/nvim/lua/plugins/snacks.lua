return {
  "folke/snacks.nvim",
  opts = {
    -- Explorer 也是基于 picker，所以这里的全局设置会影响它
    picker = {
      hidden = true,   -- 显示以 . 开头的文件
      ignored = true,  -- 也显示被 .gitignore 忽略的文件（可按需改为 false）
      sources = {
        -- 对 files 这个 picker 需要显式覆盖，因其默认 hidden=false
        files = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
