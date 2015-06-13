" File: gnome-code.vim
" Summary: This file is a vim plugin to autogen gobject code.
" Author: yetist <yetist@gmail.com>
" URL: http://gsnippet.googlecode.com/svn/trunk/vim-plugins/gnome-code.vim
" License: 
" 
" This program is free software; you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation; either version 2 of the License, or
" (at your option) any later version.
" 
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
" 
" You should have received a copy of the GNU General Public License
" along with this program; if not, write to the Free Software
" Foundation, Inc., 59 Temple Place, Suite 330,
" Boston, MA 02111-1307, USA.
" Version: 2007-09-12 00:59:45
" Usage: do :GnomeCode(args), args is the parent gobject.
"

command! -nargs=1 GnomeCode exec('py gnomecode(<f-args>)')

python <<EOF
# -*- coding: utf-8 -*-
import vim, os
CODE={}
CODE[".h"] = """
#define CPKG_TYPE_COBJ              (cpkg_cobj_get_type ())
#define CPKG_COBJ(obj)              (G_TYPE_CHECK_INSTANCE_CAST ((obj), CPKG_TYPE_COBJ, CpkgCobj))
#define CPKG_COBJ_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), CPKG_TYPE_COBJ, CpkgCobjClass))
#define CPKG_IS_COBJ(obj)           (G_TYPE_CHECK_INSTANCE_TYPE ((obj), CPKG_TYPE_COBJ))
#define CPKG_IS_COBJ_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), CPKG_TYPE_COBJ))
#define CPKG_COBJ_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), CPKG_TYPE_COBJ, CpkgCobjClass))

typedef struct _CpkgCobj             CpkgCobj;
typedef struct _CpkgCobjClass        CpkgCobjClass;

struct _CpkgCobj
{
  PpkgPobj      pobj;
};

struct _CpkgCobjClass
{
  PpkgPobjClass     parent_class;
};

GType      cpkg_cobj_get_type           (void) G_GNUC_CONST;
CpkgCobj*     cpkg_cobj_new                (void);
"""

CODE[".c"] = """
enum {
    LAST_SIGNAL
};

enum {
    PROP_0,
};

#define CPKG_COBJ_GET_PRIVATE(obj)  (G_TYPE_INSTANCE_GET_PRIVATE((obj), CPKG_TYPE_COBJ, CpkgCobjPrivate))

typedef struct _CpkgCobjPrivate        CpkgCobjPrivate;

struct _CpkgCobjPrivate
{
};

static void cpkg_cobj_set_property  (GObject          *object,
                                         guint             prop_id,
                                         const GValue     *value,
                                         GParamSpec       *pspec);
static void cpkg_cobj_get_property  (GObject          *object,
                                         guint             prop_id,
                                         GValue           *value,
                                         GParamSpec       *pspec);

G_DEFINE_TYPE (CpkgCobj, cpkg_cobj, PPKG_TYPE_POBJ);

static void
cpkg_cobj_class_init (CpkgCobjClass *class)
{
    GObjectClass *gobject_class = G_OBJECT_CLASS (class);
    GtkWidgetClass *widget_class = GTK_WIDGET_CLASS (class);

    gobject_class->set_property = cpkg_cobj_set_property;
    gobject_class->get_property = cpkg_cobj_get_property;

    g_type_class_add_private (class, sizeof (CpkgCobjPrivate));
}

static void
cpkg_cobj_init (CpkgCobj *cobj)
{
    CpkgCobjPrivate *priv;

    priv = CPKG_COBJ_GET_PRIVATE (cobj);

}

CpkgCobj*
cpkg_cobj_new (void)
{
    return g_object_new (CPKG_TYPE_COBJ, NULL);
}

static void
cpkg_cobj_set_property (GObject      *object,
                            guint         prop_id,
                            const GValue *value,
                            GParamSpec   *pspec)
{
    CpkgCobj *cobj;

    cobj = CPKG_COBJ (object);

    switch (prop_id)
    {

        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
            break;
    }
}

static void
cpkg_cobj_get_property (GObject      *object,
                            guint         prop_id,
                            GValue       *value,
                            GParamSpec   *pspec)
{
    CpkgCobj *cobj;

    cobj = CPKG_COBJ (object);

    switch (prop_id)
    {

        default:
            G_OBJECT_WARN_INVALID_PROPERTY_ID (object, prop_id, pspec);
            break;
    }
}
"""

def gnomecode(parent):
    global CODE
    info={}
    info["filename"] = vim.eval("expand(\"%:t\")")
    (info["basename"], info["extname"]) = os.path.splitext(info["filename"])

    info["cpkg"] = info["basename"].split("-")[0].lower()
    info["Cpkg"] = info["cpkg"][0].upper() + info["cpkg"][1:]
    info["CPKG"] = info["cpkg"].upper()

    info["cobj"] = "_".join(info["basename"].split("-")[1:]).lower()
    info["Cobj"] = "".join([i[0].upper()+i[1:].lower() for i in info["basename"].split("-")[1:]])
    info["COBJ"] = info["cobj"].upper()

    info["ppkg"] = parent.split("-")[0].lower()
    info["Ppkg"] = info["ppkg"][0].upper() + info["ppkg"][1:]
    info["PPKG"] = info["ppkg"].upper()

    info["pobj"] = parent.split("-")[1].lower()
    info["Pobj"] = info["pobj"][0].upper() + info["pobj"][1:]
    info["POBJ"] = info["pobj"].upper()

    if CODE.has_key(info["extname"]):
        for k in info.keys():
            CODE[info["extname"]] = CODE[info["extname"]].replace(k, info[k])
        write_code(CODE[info["extname"]])

def write_code(lines):
    row,col = vim.current.window.cursor
    vim.current.buffer[row:row] = lines.splitlines()
EOF
