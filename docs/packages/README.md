# Workspace Packages

← [Back to CLAUDE.md](../../CLAUDE.md)

## Overview

Flabr uses a monorepo structure with workspace packages in `packages/` directory.

## Packages

### quick_shortcuts

Wrapper for `quick_actions` library providing home screen shortcuts functionality.

**Used by:** `ShortcutsManager` in `lib/core/component/shortcuts/`

**Details:** See package README at `packages/quick_shortcuts/README.md`

### ya_summary

YandexGPT API integration for generating AI-powered article summaries.

**Used by:** `SummaryAuthCubit` and summary features

**Details:** See package README at `packages/ya_summary/README.md`

### flutter_highlight

Custom syntax highlighting for code blocks in articles.

**Used by:** Article rendering widgets

**Details:** See package README at `packages/flutter_highlight/README.md`

## Development

### Working with Packages

See [Development Commands](../development/commands.md) for more details.

---

← [Back to CLAUDE.md](../../CLAUDE.md)
