# Automatic Hover Functionality Documentation

## Overview
This document describes the automatic hover-on-cursor-hold functionality implemented in the Neovim configuration. The system displays LSP hover information automatically when the cursor remains stationary over a symbol for 250ms.

## Key Features

### 🎯 Core Functionality
- **Automatic trigger**: Hover appears after 250ms cursor hold (`CursorHold` event)
- **Non-intrusive**: Cursor stays in editor, never jumps into hover window
- **Top-right positioning**: Hover window appears in screen's top-right corner to avoid blocking code
- **Smart cleanup**: Automatically closes on cursor movement, insert mode, or buffer changes

### 🎨 Visual Enhancements
- **Custom styling**: Dark background (`#1a1b26`) with blue borders (`#7aa2f7`)
- **Rounded borders**: Clean, modern appearance
- **Syntax highlighting**: Intelligent language detection and proper highlighting
- **Code block cleaning**: Removes markdown ````` markers while preserving syntax highlighting

### 🚀 Performance & Reliability
- **Global window management**: Prevents multiple hover windows from stacking
- **Stale hover prevention**: Validates cursor position before displaying
- **Proper resource cleanup**: Comprehensive cleanup on LSP detach and buffer changes
- **Buffer isolation**: Each buffer manages hover independently

## Implementation Details

### File Location
All hover functionality is implemented in `/Users/tantanok/.config/nvim/init.lua`

### Key Components

#### 1. Global State Management
```lua
-- Global variables for window tracking
_G.current_hover_window = nil

-- Universal cleanup function
_G.close_all_hover_windows = function()
  -- Implementation handles both tracked and orphaned hover windows
end
```

#### 2. LSP Integration (Lines ~640-780)
- Integrated into the existing `LspAttach` autocmd
- Only activates for clients supporting `textDocument/hover`
- Uses `vim.lsp.buf_request` for direct LSP communication
- Includes proper `client.offset_encoding` parameter

#### 3. Window Positioning
```lua
-- Top-right corner positioning
local row = 0  -- Top of screen
local col = screen_width - width  -- Right edge aligned
```

#### 4. Content Processing
- **Language detection**: Supports TypeScript, JavaScript, Lua, JSON
- **Markdown cleaning**: Removes code block markers (`````typescript`, etc.)
- **Filetype setting**: Sets appropriate syntax highlighting
- **Context inference**: Falls back to current buffer's filetype

#### 5. Event Handling
```lua
-- Trigger events
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  -- Hover display logic
})

-- Cleanup events  
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'InsertEnter', 'BufLeave' }, {
  callback = _G.close_all_hover_windows,
})
```

## Configuration Settings

### Timing
- **Hover delay**: 250ms (controlled by `vim.o.updatetime = 250`)
- **Focus delay**: 50ms delay for potential focus functionality (currently unused)

### Window Constraints
- **Max width**: 80 characters
- **Max height**: 20 lines
- **Min width**: Calculated from content
- **Position**: Always top-right corner

### Supported Languages
- TypeScript (`typescript`, `typescriptreact`)
- JavaScript (`javascript`, `javascriptreact`) 
- Lua (`lua`)
- JSON (`json`)
- Markdown (fallback)

## Troubleshooting Guide

### Common Issues

1. **Hover not appearing**
   - Check if LSP is attached: `:LspInfo`
   - Verify `updatetime` setting: `:set updatetime?`
   - Test manual hover: Press `K`

2. **LSP warnings about position_encoding**
   - Fixed in current implementation with `client.offset_encoding`
   - If warnings persist, check LSP client configuration

3. **Multiple hover windows stacking**
   - Global cleanup function should prevent this
   - If occurring, restart Neovim to reset global state

4. **Hover not closing on cursor movement**
   - Check if cleanup autocmds are properly set
   - Verify `_G.close_all_hover_windows` function exists

### Debugging Commands
```lua
-- Check global state
:lua print(vim.inspect(_G.current_hover_window))

-- Test cleanup function
:lua _G.close_all_hover_windows()

-- Check LSP clients
:LspInfo

-- Check autocmds
:autocmd kickstart-lsp-hover
```

## Extension Points

### Adding New Languages
1. Add pattern to `lang_patterns` table:
```lua
{ pattern = '```newlang\n(.-)```', lang = 'newlang' }
```

2. Add context detection:
```lua
elseif current_buf_ft == 'newlang' then
  filetype = 'newlang'
```

### Modifying Position
Change the positioning logic in the window creation section:
```lua
-- Current: top-right
local row = 0
local col = screen_width - width

-- Example: bottom-right
local row = screen_height - height - 1
local col = screen_width - width
```

### Adding Focus Functionality
The infrastructure exists but was removed. To re-enable:
1. Restore global focus functions
2. Add keymap (recommend `<leader>vh`)
3. Add buffer-local navigation keymaps
4. Handle focusable window state transitions

### Custom Styling
Modify highlight groups in `setup_hover_highlights()`:
```lua
vim.api.nvim_set_hl(0, 'HoverNormal', {
  bg = '#your_color',
  fg = '#your_color',
})
```

## Dependencies

### Required Plugins
- `nvim-lspconfig`: LSP client configuration
- Language servers (e.g., `vtsls` for TypeScript)
- `lazy.nvim`: Plugin manager (affects reload behavior)

### Neovim Version
- Requires Neovim 0.10+ for proper LSP API support
- `client.offset_encoding` requires recent LSP implementation

## Performance Considerations

### Memory Usage
- Global window tracking uses minimal memory
- Hover buffers are temporary and auto-cleaned
- No persistent content caching

### CPU Impact
- Minimal: Only active during `CursorHold` events
- LSP requests are asynchronous and non-blocking
- Content processing is lightweight (regex-based)

### Network Impact
- Uses existing LSP connection
- No additional network requests
- Respects LSP client rate limiting

## Development History

### Initial Implementation (Commit: eeefbb3)
- Basic automatic hover functionality
- Cursor position preservation
- Global window management
- Smart syntax highlighting

### Refinements (Commit: 3bea98b)  
- Fixed LSP position_encoding warning
- Moved to top-right positioning
- Removed focus functionality
- Simplified codebase

### Known Limitations
1. **Single window only**: Only one hover window at a time
2. **No scrolling**: Large content is truncated
3. **Fixed position**: Always top-right corner
4. **No user configuration**: Settings are hardcoded

## Future Enhancement Ideas

### User Experience
- [ ] Configurable positioning (top-left, bottom-right, etc.)
- [ ] Scrollable hover windows for large content
- [ ] Fade-in/fade-out animations
- [ ] Multiple hover windows for different content types

### Functionality
- [ ] Hover window focus and navigation (`<leader>vh` keymap)
- [ ] Links within hover content (go to definition, references)
- [ ] Hover history navigation
- [ ] Pin hover windows to keep them open

### Configuration
- [ ] User-configurable delay timing
- [ ] Custom styling options
- [ ] Language-specific behavior
- [ ] Enable/disable per buffer type

### Integration
- [ ] Integration with existing documentation plugins
- [ ] Export hover content to quickfix or location list
- [ ] Save frequently accessed hover content
- [ ] Integration with note-taking plugins

## Testing Checklist

When modifying this functionality, test:

- [ ] Hover appears on function symbols after 250ms
- [ ] Hover disappears on cursor movement
- [ ] No multiple hover windows stack
- [ ] TypeScript/JavaScript syntax highlighting works
- [ ] Lua syntax highlighting works
- [ ] No LSP warnings in `:messages`
- [ ] Hover positioning doesn't block code
- [ ] Manual `K` hover still works
- [ ] LSP functionality unaffected (go to definition, etc.)
- [ ] No performance degradation during normal editing

## Contact & Maintenance

This functionality was implemented collaboratively between the user and Claude Code. For future modifications:

1. Reference this document for understanding current implementation
2. Test thoroughly with the provided checklist
3. Update this documentation when making changes
4. Consider backward compatibility with existing LSP setup

---

*Documentation created: 2025-06-30*  
*Last updated: 2025-06-30*  
*Version: 1.0*