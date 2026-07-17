-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "아래로 스크롤 하면서 커서 중앙에 위치" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "위로 스크롤 하면서 커서 중앙에 위치" })

-- 코드 주석 처리
vim.keymap.set('n', '<D-/>', 'gcc', { remap = true, silent = true, desc = "현재 라인을 주석 처리/해제" })
vim.keymap.set('v', '<D-/>', 'gc', { remap = true, silent = true, desc = "선택한 모든 라인을 주석 처리/해제" })

-- Shift + 방향키 눌러서 비주얼 모드 진입
vim.keymap.set('n', '<S-Left>', 'v<Left>', { desc = 'Visual mode + move left' })
vim.keymap.set('n', '<S-Right>', 'v<Right>', { desc = 'Visual mode + move right' })
vim.keymap.set('n', '<S-Up>', 'v<Up>', { desc = 'Visual mode + move up' })
vim.keymap.set('n', '<S-Down>', 'v<Down>', { desc = 'Visual mode + move down' })

-- Insert 에서 Shift + 방향키로 비주얼 모드 되도록
vim.keymap.set('i', '<S-Left>', '<Esc>v<Left>', { desc = 'Exit insert, visual left' })
vim.keymap.set('i', '<S-Right>', '<Esc>v<Right>', { desc = 'Exit insert, visual right' })
vim.keymap.set('i', '<S-Up>', '<Esc>v<Up>', { desc = 'Exit insert, visual up' })
vim.keymap.set('i', '<S-Down>', '<Esc>v<Down>', { desc = 'Exit insert, visual down' })

-- Insert mode: Shift + Tab으로 들여쓰기 줄이기
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Outdent in Insert Mode" })

-- Visual mode: Shift + Tab으로 선택 영역 들여쓰기 줄이기
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Outdent in Visual Mode" })

-- Normal mode: Shift + Tab으로 현재 줄 들여쓰기 줄이기
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "Outdent in Normal Mode" })

-- 기본 삭제 명령어를 모두 순수 삭제(블랙홀 레지스터)로 변경
vim.keymap.set({'n', 'v'}, 'd', '"_d', { noremap = true })
vim.keymap.set('n', 'dd', '"_dd', { noremap = true })
vim.keymap.set('n', 'D', '"_D', { noremap = true })

-- 한 글자 삭제(x)와 단어 변경(c)도 순수 삭제로 변경
vim.keymap.set({'n', 'v'}, 'x', '"_x', { noremap = true })
vim.keymap.set({'n', 'v'}, 'c', '"_c', { noremap = true })

-- 잘라내기(Cut) 전용 키를 대문자 X로 지정 (Visual 모드에서 선택 후 X 누르면 잘라내기)
vim.keymap.set('v', 'X', 'd', { noremap = true })