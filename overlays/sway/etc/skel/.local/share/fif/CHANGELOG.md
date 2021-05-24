# Change log


## [v0.2]

### Breaking change

I've had to change how `grep`/`ag`/`rg` opts are handled due to bash not allowing for
array export. The new syntax is as follows:

```bash
# Single line
export FIF_RG_OPTS="--hidden --color always --colors=match:none --colors=path:fg:blue --colors=line:fg:yellow --follow"

# Multiline
export FIF_RG_OPTS="\
  --hidden \
  --color always \
  --colors=match:none \
  --colors=path:fg:blue \
  --colors=line:fg:yellow \
  --follow \
  "
```
Gotta be careful with the newline chars, it'll trip up `fif` if the backslash isn't included.


### Fixed

- Now highlights line when using pygmentize and cat for preview
- Fix issues when using custom editor script
- Follow symlinks by default
- Minor tweaks and readme updates
- Prevent exit when bat isn't present. Fall back to alternatives.

### Changed

- Change keybinding for toggling preview <kbd>Ctrl-p</kbd>
- Add customization option for editor.sh `$FIF_EDITOR_SCRIPT`

[v0.2]: https://github.com/roosta/fif/compare/v0.1...v0.2
