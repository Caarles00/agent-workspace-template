---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <file-or-pattern>
---

# Web Interface Guidelines

Review files for compliance with Vercel's Web Interface Guidelines.

## How It Works

1. Read the rules in `references/guidelines.md`, next to this file
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the guidelines
4. Output findings in the terse `file:line` format the guidelines specify

## Guidelines Source

The rules are vendored verbatim from
`https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md` (MIT, see
`references/LICENSE`), so the review works offline, on any harness, and against text that has been read
here. The file's own `$ARGUMENTS` placeholder means the files you were given. To pick up upstream
changes, re-download it as the comment at its top describes.

Most rules are plain HTML, CSS and accessibility and apply to any frontend; a few assume React or Next.js
(`onKeyDown`, `<Link>`, hydration). Skip those where the stack makes them meaningless, and say so.

## Usage

When a user provides a file or pattern argument:
1. Read `references/guidelines.md`
2. Read the specified files
3. Apply all rules from the guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
