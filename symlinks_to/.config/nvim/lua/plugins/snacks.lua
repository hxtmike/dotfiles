-- 只让「是否被 .gitignore 忽略」成为区别对待的分界线：
--   * 未被忽略的（普通文件、. 开头的隐藏文件、文件夹）-> 正常亮度
--   * 被 .gitignore 忽略的                            -> 变暗
--
-- monokai-pro 默认把 Directory 设成 dimmed3（文件夹很暗），又把 NonText
-- 清空（导致 snacks 用来画 ignored 的颜色继承 Normal，反而最亮），
-- 所以这里把这两者对调回来。
local function set_picker_hl()
  -- 隐藏文件跟普通文件同色
  vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { link = "SnacksPickerFile" })
  -- 文件夹恢复正常亮度（不给 fg 就继承 Normal），加粗以便和文件区分
  vim.api.nvim_set_hl(0, "SnacksPickerDirectory", { bold = true })
  -- 被 gitignore 的变暗（SnacksPickerDimmed -> Conceal，monokai-pro 下是 #6e7066）
  vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { link = "SnacksPickerDimmed" })
end

return {
  "folke/snacks.nvim",
  init = function()
    -- 换 colorscheme 会清掉所有高亮组，所以每次换主题后重设一遍
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("snacks_picker_hl", { clear = true }),
      callback = set_picker_hl,
    })
    set_picker_hl()
  end,
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
