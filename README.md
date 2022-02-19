# gnome-code.vim

This plugin generate simple c and h templates for new GObject class from
predefined templates.

Templates are files with `.gcode.tmpl` extension.

## Installation

### Vundle

```vim
Plugin 'yetist/gnome-code'
```

### vim-plug

```vim
Plug 'yetist/gnome-code'
```

## Usage

Run command `GnomeCode`:

	:GnomeCode

The command use the current file name for class name.

## Templates

The default templates for c and h file is `templates/c.gcode.tmpl` and
`templates/c.gcode.tmpl`.

### Creating your own templates

- Create a file `<c|h>.gcode.tmpl` inside a folder which is searched
  by the plugin( [see below](#search-paths)),
- Open the file and run `:GnomeCode` command, for example

h.gcode.tmpl

```cpp
#define {{CPKG}}_TYPE_{{COBJ}} ({{cpkg}}_{{cobj}}_get_type ())
#define {{CPKG}}_{{COBJ}}(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), {{CPKG}}_{{COBJ}}_TYPE, {{Cpkg}}{{Cobj}}))
#define {{CPKG}}_{{COBJ}}_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), {{CPKG}}_{{COBJ}}_TYPE, {{Cpkg}}{{Cobj}}Class))
#define IS_{{CPKG}}_{{COBJ}}(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), {{CPKG}}_{{COBJ}}_TYPE))
#define IS_{{CPKG}}_{{COBJ}}_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), {{CPKG}}_{{COBJ}}_TYPE))
#define {{CPKG}}_{{COBJ}}_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), {{CPKG}}_{{COBJ}}_TYPE, {{Cpkg}}{{Cobj}}Class))
```

Edit a file named **foo-bar.h**, after run `:GnomeCode` command:

```cpp
#define FOO_TYPE_BAR (foo_bar_get_type ())
#define FOO_BAR(obj) (G_TYPE_CHECK_INSTANCE_CAST ((obj), FOO_BAR_TYPE, FooBar))
#define FOO_BAR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST ((klass), FOO_BAR_TYPE, FooBarClass))
#define IS_FOO_BAR(obj) (G_TYPE_CHECK_INSTANCE_TYPE ((obj), FOO_BAR_TYPE))
#define IS_FOO_BAR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE ((klass), FOO_BAR_TYPE))
#define FOO_BAR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS ((obj), FOO_BAR_TYPE, FooBarClass))
```

- `{{cpkg}}`, `{{Cpkg}}`, `{{CPKG}}` and `{{cobj}}`, `{{Cobj}}`, `{{COBJ}}` are
parsed from the current file name.
- `{{ppkg}}`, `{{Ppkg}}`, `{{PPKG}}` and `{{pobj}}`, `{{Pobj}}`, `{{POBJ}}` are
parsed from your input when running the `:GnomeCode` command, they are using for
the parent object name.

### Search paths

The plugin searches for templates as follows

1. In folders named `templates` recursively up the directory tree,
   i.e. first in a directory `templates` under the current working
   directory, then in `../templates`, then '../../templates', ...
2. In search paths defined by `g:tmpl_search_paths` in your `.vimrc` file
3. The `templates` folder in this plugin's directory

If you want to add a custom directory to the search path,
e.g. if you placed them inside a ``templates`` directory under ``$HOME`` then
add the following line in your ``.vimrc`` file:

```vim
let g:tmpl_search_paths = ['~/templates']
```

Credits
=======

https://github.com/vim-scripts/gobgen

https://github.com/vim-scripts/vimplate
