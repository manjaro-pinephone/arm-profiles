# ranger-fzf-marks

[![License: MIT][license icon]][license]

A [ranger][ranger] plugin ported from [urbainvaes/fzf-marks][urbainvaes-fzf-marks].
It depends on command-line fuzzy finder [junegunn/fzf][junegunn-fzf].

## Installation

Git clone the plugin into ranger's plugin folder. (`ranger >= 1.9.3`)

```bash
git clone https://github.com/laggardkernel/ranger-fzf-marks.git ~/.config/ranger/plugins/fzf-marks
```

Then add key binding for bookmark jump in `rc.conf`.

```bash
map <C-g> fzm
```

## Usage

Commands:

- `:fmark <markname>`, add a current dir as bookmark
- `:fzm [<optional-query-keyword>]`, jump to a bookmark
- `:dmark [<optional-query-keyword>]`, delete a bookmark

Bookmark jumping could be also be triggered with key binding like `<C-g>`.

Other features like output colorization, custom fzf command are not implemented.
This plugin only ensure basic usage of bookmark with fzf support.

## Settings

Customization is supported by environment variables.

`FZF_MARKS_FILE`, same variable used in
[urbainvaes/fzf-marks][urbainvaes-fzf-marks], defaults to `${HOME}/.fzf-marks`.

`FZF_MARKS_CMD`, path to the `fzf` executable binary. You don't need this
unless your `fzf` is not added in the `PATH`.

`FZF_FZM_OPTS`, controls how command `fzm` (from this plugin) behave, defaults to
`--cycle +m --ansi --bind=ctrl-o:accept,ctrl-t:toggle --select-1`.

`FZF_DMARK_OPTS`, controls how command `dmark` (from this plugin) behave,
defaults to `--cycle -m --ansi --bind=ctrl-o:accept,ctrl-t:toggle`.
(`dmark` only supports delete one mark at each time for now, that's why I use `-m`)

Besides above `FZF_*` related settings, fzf's behavior is also controlled by
`FZF_DEFAULT_OPTS`, which is an env from `fzf` itself. Read `man fzf` for
detail.

## Layout

The default `fzf` layout `--layout=default` **display from the bottom of the screen**.
For anyone who like it to be display from the top to the bottom,
try `--reverse` and `--height`, `--min-height` to get what you want. e.g.

```bash
export FZF_FZM_OPTS="--reverse --height 75% --min-height 30 --cycle +m --ansi --bind=ctrl-o:accept,ctrl-t:toggle --select-1"
export FZF_DMARK_OPTS="--reverse --height 75% --min-height 30 --cycle -m --ansi --bind=ctrl-o:accept,ctrl-t:toggle"
```

## TODO

- [x] Custom storage support with `FZF_MARKS_FILE`
- [ ] Delete action support in `:fzm`
- [ ] Batch deletion support in `:dmark`
- [x] Make `fmark`, `dmark` style customizable

## License

The MIT License (MIT)

Copyright (c) 2021 laggardkernel

[license icon]: https://img.shields.io/badge/License-MIT-blue.svg
[license]: https://opensource.org/licenses/MIT
[ranger]: https://github.com/ranger/ranger
[urbainvaes-fzf-marks]: https://github.com/urbainvaes/fzf-marks
[junegunn-fzf]: https://github.com/junegunn/fzf
