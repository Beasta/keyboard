-- Keybindings for launching apps in Hyper Mode
hyperModeAppMappings = {
  { 'a', 'iTunes' },                -- "A" for "Apple Music"
  { 'b', 'Google Chrome' },         -- "B" for "Browser"
  { 'c', 'Hackable Slack Client' }, -- "C for "Chat"
  { 'd', 'Remember The Milk' },     -- "D" for "Do!" ... or "Done!"
  { 'e', 'Atom Beta' },             -- "E" for "Editor"
  { 'f', 'Finder' },                -- "F" for "Finder"
  { 'g', 'Mailplane 3' },           -- "G" for "Gmail"
  { 't', 'iTerm' },                 -- "T" for "Terminal"
}

function wrapSelectedText(wrapCharacters)
  -- Preserve the current contents of the system clipboard
  local originalClipboardContents = hs.pasteboard.getContents()

  -- Copy the currently-selected text to the system clipboard
  keyUpDown('cmd', 'c')

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    local selectedText = hs.pasteboard.getContents()
    local wrappedText = wrapCharacters .. selectedText .. wrapCharacters
    hs.pasteboard.setContents(wrappedText)
    keyUpDown('cmd', 'v')

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      hs.pasteboard.setContents(originalClipboardContents)
    end)
  end)
end

function inlineLink()
  -- Fetch URL from the system clipboard
  -- local linkUrl = hs.pasteboard.getContents()

  -- Copy the currently-selected text to use as the link text
  -- keyUpDown('cmd', 'c')

  -- Allow some time for the command+c keystroke to fire asynchronously before
  -- we try to read from the clipboard
  hs.timer.doAfter(0.2, function()
    -- Construct the formatted output and paste it over top of the
    -- currently-selected text
    -- local linkText = hs.pasteboard.getContents()
    -- local markdown = '[' .. linkText .. '](' .. linkUrl .. ')'
    -- hs.pasteboard.setContents(markdown)
    -- keyUpDown('cmd', 'v')

    -- Allow some time for the command+v keystroke to fire asynchronously before
    -- we restore the original clipboard
    hs.timer.doAfter(0.2, function()
      -- hs.pasteboard.setContents(originalClipboardContents)
    end)
  end)
end

--------------------------------------------------------------------------------
-- Define Markdown Mode
--
-- Markdown Mode allows you to perform common Markdown-formatting tasks anywhere
-- that you're editing text. Use Control+m to turn on Markdown mode. Then, use
-- any shortcut below to perform a formatting action. For example, to wrap the
-- selected text in double asterisks, hit Control+m, and then b.
--
--   b => wrap the selected text in double asterisks ("b" for "bold")
--   i => wrap the selected text in single asterisks ("i" for "italic")
--   s => wrap the selected text in double tildes ("s" for "strikethrough")
--   l => convert the currently-selected text to an inline link, using a URL
--        from the clipboard ("l" for "link")
--------------------------------------------------------------------------------

windowChangerMode = hs.hotkey.modal.new({}, 'F19')

local message = require('status-message')
markdownMode.statusMessage = message.new('Window-Changer Mode (control-a)')
markdownMode.entered = function()
  markdownMode.statusMessage:show()
end
markdownMode.exited = function()
  markdownMode.statusMessage:hide()
end

-- Bind the given key to call the given function and exit Markdown mode
function markdownMode.bindWithAutomaticExit(mode, key, fn)
  mode:bind({}, key, function()
    mode:exit()
    fn()
  end)
end

markdownMode:bindWithAutomaticExit('b', function()
  wrapSelectedText('**')
end)

markdownMode:bindWithAutomaticExit('i', function()
  wrapSelectedText('*')
end)

markdownMode:bindWithAutomaticExit('s', function()
  wrapSelectedText('~~')
end)

markdownMode:bindWithAutomaticExit('l', function()
  inlineLink()
end)

-- Use Control+m to toggle Markdown Mode
hs.hotkey.bind({'ctrl'}, 'a', function()
  markdownMode:enter()
end)
markdownMode:bind({'ctrl'}, 'a', function()
  markdownMode:exit()
end)
