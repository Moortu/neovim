-- ================================================================================================
-- TITLE : nvim-dap-ui
-- ABOUT : A UI for nvim-dap which provides a good out of the box configuration
-- LINKS :
--   > github             : https://github.com/rcarriga/nvim-dap-ui
--   > nvim-dap (dep)     : https://github.com/mfussenegger/nvim-dap
--   > nvim-nio (dep)     : https://github.com/nvim-neotest/nvim-nio
-- ================================================================================================

return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
    },
    event = "VeryLazy",
    config = function()
        vim.api.nvim_create_augroup("DapGroup", { clear = true })

        local function navigate(args)
            local buffer = args.buf
            local wid = nil
            
            for _, win_id in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win_id) == buffer then
                    wid = win_id
                    break
                end
            end

            if wid then
                vim.schedule(function()
                    if vim.api.nvim_win_is_valid(wid) then
                        vim.api.nvim_set_current_win(wid)
                    end
                end)
            end
        end

        local function create_nav_options(name)
            return {
                group = "DapGroup",
                pattern = string.format("*%s*", name),
                callback = navigate,
            }
        end

        local dap = require("dap")
        local dapui = require("dapui")

        -- Create single-element layouts
        local function layout(name)
            return {
                elements = { { id = name } },
                enter = true,
                size = 40,
                position = "right",
            }
        end

        local name_to_layout = {
            repl = { layout = layout("repl"), index = 0 },
            stacks = { layout = layout("stacks"), index = 0 },
            scopes = { layout = layout("scopes"), index = 0 },
            console = { layout = layout("console"), index = 0 },
            watches = { layout = layout("watches"), index = 0 },
            breakpoints = { layout = layout("breakpoints"), index = 0 },
        }

        local layouts = {}
        for name, config in pairs(name_to_layout) do
            table.insert(layouts, config.layout)
            name_to_layout[name].index = #layouts
        end

        local function toggle_debug_ui(name)
            dapui.close()
            local layout_config = name_to_layout[name]
            if not layout_config then
                error(string.format("Invalid layout name: %s", name))
            end

            local uis = vim.api.nvim_list_uis()[1]
            if uis then
                layout_config.size = uis.width
            end

            pcall(dapui.toggle, layout_config.index)
        end

        -- UI toggle keymaps (using <leader>u prefix to avoid conflict with LSP diagnostics)
        vim.keymap.set("n", "<leader>ur", function() dapui.toggle() end, { desc = "Debug UI: Toggle" })
        vim.keymap.set("n", "<leader>us", function() toggle_debug_ui("stacks") end, { desc = "Debug UI: Stacks" })
        vim.keymap.set("n", "<leader>uw", function() toggle_debug_ui("watches") end, { desc = "Debug UI: Watches" })
        vim.keymap.set("n", "<leader>ub", function() toggle_debug_ui("breakpoints") end, { desc = "Debug UI: Breakpoints" })
        vim.keymap.set("n", "<leader>uS", function() toggle_debug_ui("scopes") end, { desc = "Debug UI: Scopes" })
        vim.keymap.set("n", "<leader>uc", function() toggle_debug_ui("console") end, { desc = "Debug UI: Console" })

        -- Auto-wrap in REPL buffer
        vim.api.nvim_create_autocmd("BufEnter", {
            group = "DapGroup",
            pattern = "*dap-repl*",
            callback = function()
                vim.wo.wrap = true
            end,
        })

        -- Auto-navigate to DAP windows
        vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
        vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

        -- Setup dapui
        dapui.setup({
            layouts = layouts,
            enter = true,
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                pause = '⏸',
                play = '▶',
                step_into = '⏎',
                step_over = '⏭',
                step_out = '⏮',
                step_back = 'b',
                run_last = '▶▶',
                terminate = '⏹',
                disconnect = '⏏',
                },
            },
        })

        -- Auto-close UI when debugging ends
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- Send console output to Console window
        dap.listeners.after.event_output.dapui_config = function(_, body)
            if body.category == "console" then
                dapui.eval(body.output)
            end
        end
    end,
}
