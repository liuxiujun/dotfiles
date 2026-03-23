require('autocmd')
require('options')
require('keymaps')
require('bootstrap')

-- 使用 io.write 直接写入 stderr（WezTerm 会捕获）
local function wezterm_set_user_var(name, value)
  local seq = string.format("\27]1337;SetUserVar=%s=%s\7", name, vim.base64.encode(value))
  io.stdout:write(seq)
  io.stdout:flush()
end

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
    callback = function()
        local mode = vim.fn.mode()
        print("Mode changed: " .. mode)
        local value = (mode == 'i' or mode == 'c') and 'insert' or 'normal'
        wezterm_set_user_var("IM_SWITCH", value)
    end,
})
