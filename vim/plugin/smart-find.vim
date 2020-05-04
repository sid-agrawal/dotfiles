
if v:version < 700 || &cp
   finish
endif

function! s:getModuleString()
   let currLine = getline('.')
   let pos = col('.') - 1
   let pat = '[a-zA-Z0-9_.]'
   let retval = ''

   if currLine[pos] !~ pat
      return ''
   endif

   let i = pos
   while currLine[i] =~ pat
      let retval = currLine[i] . retval
      let i -= 1
   endwhile

   let i = pos + 1
   while currLine[i] =~ pat
      let retval .= currLine[i]
      let i += 1
   endwhile

   return retval
endfunction

function! s:findGrep(path, pathExpr, definition)
   let findCmd = printf('find %s -type f %s', a:path, a:pathExpr)
   let grepCmd = printf("grep -EHn '(def|class) +%s\\>|^%s *='", a:definition, 
            \ a:definition)
   let cmd = findCmd . ' | xargs ' . grepCmd
   return split(system(cmd), '\n')
endfunction

function! s:findCmdPathExpr(parts, basePath)
   let modulePath = ''
   let targetModule = a:parts[-1]
   let fmt = "\\( -path '%s/%%s%s.py' -or "
            \ . "-path '%s/%%s%s/__init__.py' -or "
            \ . "-path '%s/%%s%s/__init__' \\)"
   let fmt = printf(fmt, a:basePath, targetModule, a:basePath, targetModule,
            \ a:basePath, targetModule )
   if len(a:parts) > 1
      for part in a:parts[:-2]
         let modulePath .= part . '/'
      endfor
   endif
   return printf(fmt, modulePath, modulePath, modulePath)
endfunction

function! s:handleSingleMatch(line)
   let [filename, lineNo; rest] = split(a:line, ':')
   exec 'edit ' . filename
   exec ':' . lineNo
   exec 'normal! zz'
endfunction

function! s:handleMultipleMatches(line)
   let org_efm = &errorformat
   let &errorformat = '%f:%l:%m'
   cclose
   cexpr '---------------------------------------------------------------------------'
   caddexpr lines
   " Open the results window (and restore cursor position)
   keepjumps cfirst 1
   exec "normal! \<C-o>"
   copen
   
   " Typing q closes quickfix window.
   nnoremap <buffer> <silent> q :cclose<CR>

   let &errorformat = org_efm
endfunction

" Features to add:
" - Search in the same file for definition of func if string is 'self.func('
" - Add command to prompt user for definition
" - Add feature to search for module like *.*.grab
"   - Maybe search for '**.grab'?
" - If string is only one object (e.g. func or var name) search in file
"   - If no matches, check if it is an import. 
"     - Then we can try searching the path for that module.
" - Have a command to try search src tree for definition 
"   - This might not be too bad. Something like this might work:
"     find /src -path '*ArosTest/__init.__.py' | xargs grep -EHn 'def run\('
"     Maybe this should be default behavior?
" - Test when there are multiple matches?
"
" TODO
" - Move functions to autoload directory.
" - Add error msg if searching for invalid string or no matches.

function! s:findDefinition(str)
   let parts = split(a:str, '\.')
   if len(parts) < 2
      let msg = printf("%s is not an object in a module", a:str)
      echohl ErrorMsg | echo msg | echohl None
      return -1
   endif

   for path in split(&path, ',')
      let pathExpr = s:findCmdPathExpr(parts[:-2], path)
      let lines = s:findGrep(path, pathExpr, parts[-1])
      if len(lines) == 1
         call s:handleSingleMatch(lines[0])
         return
      elseif len(lines) > 1
         call s:handleMultipleMatches(lines)
         return
      endif
   endfor

   if !len(lines)
      let msg = printf('%s was not found', a:str)
      echohl ErrorMsg | echo msg | echohl None
      return -1
   endif
endfunction

function! s:getInput()
   call inputsave()
   let s = input("Search for: ")
   call inputrestore()
   return s
endfunction

command! FindDefinitionUnderCursor silent :call s:findDefinition(s:getModuleString())
command! FindDefinition :call s:findDefinition(s:getInput())
