" File: gnome-code.vim
" Summary: This file is a vim plugin to autogen gobject code.
" Author: yetist <yetist@gmail.com>
" URL: https://github.com/yetist/gnome-code.vim
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
" Version: 2022-02-19 14:44:45
" Usage: do :GnomeCode
"

" Script initialization {{{
if exists("g:gnome_code_loaded")
  finish
endif
let g:gnome_code_loaded = 1
" }}}

function! s:get_package_name() " {{{
  let package = expand("%:t:r")
  let l:len = len(split(package, "-"))

  if l:len < 2
    echohl ErrorMsg
    echo "The file name does not include '-' char"
    echohl None
    let package = input("Enter object name (e.g. package-object):", package)
  endif

  let l:len = len(split(package, "-"))
  while l:len < 2
    echohl ErrorMsg
    echo "\nPackage object name must include '-' char."
    echohl None
    let package = input("Enter package object name (e.g. package-object):", package)
    let l:len = len(split(package, "-"))
  endwhile
  return package
endfunction " }}}

function! s:get_parent_name() " {{{
  let parent = input("Enter parent object name (e.g. gtk-widget):", "g-object")
  let len = len(split(parent, "-"))
  while len < 2
    echohl ErrorMsg
    echo "\nThe parent object name must include '-' char."
    echohl None
    let parent = input("Enter parent object name (e.g. gtk-widget):", parent)
    let len = len(split(parent, "-"))
  endwhile
  return parent
endfunction " }}}

function! s:get_object_dict() " {{{
  let object = s:get_package_name()
  let parent = s:get_parent_name()
  let info = {}

  " package name
  let olist = []
  let object_list = split(object, "-")
  for i in object_list[1:]
    let olist = add(olist, toupper(i[0]) . i[1:])
  endfor

  let info["cpkg"] = tolower(object_list[0])
  let info["Cpkg"] = toupper(info["cpkg"][0]) . info["cpkg"][1:]
  let info["CPKG"] = toupper(info["cpkg"])
  let info["cobj"] = tolower(join(object_list[1:], "_"))
  let info["Cobj"] = join(olist, "")
  let info["COBJ"] = toupper(info["cobj"])

  " parent name
  let plist = []
  let parent_list = split(parent, "-")
  for i in parent_list[1:]
    let plist = add(plist, toupper(i[0]) . i[1:])
  endfor
  let info["ppkg"] = tolower(parent_list[0])
  let info["Ppkg"] = toupper(info["ppkg"][0]) . info["ppkg"][1:]
  let info["PPKG"] = toupper(info["ppkg"])
  let info["pobj"] = tolower(join(parent_list[1:], "_"))
  let info["Pobj"] = join(plist, "")
  let info["POBJ"] = toupper(info["pobj"])

  return info
endfunction " }}}

function! s:escape_tmpl(tmpl) " {{{
  return escape(a:tmpl, '/')
endfunction " }}}

function! s:expand_tmpl(tmpl, value) " {{{
  silent! execute '%s/{{'. s:escape_tmpl(a:tmpl) .'}}/'. s:escape_tmpl(a:value) .'/gI'
endfunction " }}}

function! s:move_cursor() " {{{
  " go to first line
  normal gg
  " serach for cursor if it is found then move cursor there
  if (search('{{CURSOR}}', 'W'))
    let l:lineno = line('.')
    let l:colno = col('.')
    " remove cursor
    s/{{CURSOR}}//
    call cursor(l:lineno, l:colno)
    return 1
  endif
  return 0
endfunction " }}}

" Expand all templates present in current file
function! s:expand_all_tmpl() " {{{
  " mark the current position so that we can return to it if cursor is not found
  normal! mm

  let dict = s:get_object_dict()
  for [key, value] in items(dict)
    call s:expand_tmpl(key, value)
  endfor

  let l:cursor_found = s:move_cursor()

  if !l:cursor_found
    " return to old cursor position
    normal `m
  endif
endfunction " }}}

function! s:init_tmpl_for_ext(filepart, template_path) " {{{
  let l:template_path = fnameescape(a:template_path.'/'.a:filepart.'.gcode.tmpl')
  if (filereadable(l:template_path))
    execute 'silent r '.l:template_path
    return 1
  endif
  return 0
endfunction " }}}

" get default template directory
let s:default_template_directory = expand('<sfile>:p:h:h') . '/templates'

function! GnomeCodeGen() " {{{
  " Paths to search for templates files
  let l:tmpl_paths = finddir("templates", ";",-1)

  " user defined search paths
  if (!exists('g:tmpl_search_paths'))
    let g:tmpl_search_paths = []
  endif
  for l:path in g:tmpl_search_paths
    let l:tmpl_paths = add(l:tmpl_paths, expand(l:path))
  endfor

  " default template path
  let l:tmpl_paths = add(l:tmpl_paths, s:default_template_directory)

  let l:file_ext = expand('%:e') " file extension

  for l:path in l:tmpl_paths
    let l:initialized = s:init_tmpl_for_ext(l:file_ext, l:path)
    if (l:initialized)
      call s:expand_all_tmpl()
      break
    endif
  endfor
endfunction " }}}

" Commands {{{
command! GnomeCode call GnomeCodeGen()
" }}}
