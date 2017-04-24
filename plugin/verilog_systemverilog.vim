" Global plugin settings
let g:verilog_disable_indent="eos"

" Command definitions
command! -nargs=* VerilogErrorFormat call verilog_systemverilog#VerilogErrorFormat(<f-args>)
command!          VerilogFollowInstance call verilog_systemverilog#FollowInstanceTag(line('.'), col('.'))
command!          VerilogFollowPort call verilog_systemverilog#FollowInstanceSearchWord(line('.'), col('.'))
command!          VerilogGotoInstanceStart call verilog_systemverilog#GotoInstanceStart(line('.'), col('.'))
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogFoldingAdd
            \ call verilog_systemverilog#PushToVariable('verilog_syntax_fold_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogFoldingRemove
            \ call verilog_systemverilog#PopFromVariable('verilog_syntax_fold_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogDisableIndentAdd
            \ call verilog_systemverilog#PushToVariable('verilog_disable_indent_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogDisableIndentRemove
            \ call verilog_systemverilog#PopFromVariable('verilog_disable_indent_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogErrorUVMAdd
            \ call verilog_systemverilog#PushToVariable('verilog_efm_uvm_lst', '<args>')
command! -nargs=+ -complete=customlist,verilog_systemverilog#CompleteCommand
            \ VerilogErrorUVMRemove
            \ call verilog_systemverilog#PopFromVariable('verilog_efm_uvm_lst', '<args>')

" Configure tagbar
" This requires a recent version of universal-ctags
let g:tagbar_type_verilog_systemverilog = {
    \ 'ctagstype'   : 'SystemVerilog',
    \ 'kinds'       : [
        \ 'b:blocks:1:1',
        \ 'c:constants:1:0',
        \ 'e:events:1:0',
        \ 'f:functions:1:1',
        \ 'm:modules:0:1',
        \ 'n:nets:1:0',
        \ 'p:ports:1:0',
        \ 'r:registers:1:0',
        \ 't:tasks:1:1',
        \ 'A:assertions:1:1',
        \ 'C:classes:0:1',
        \ 'V:covergroups:0:1',
        \ 'I:interfaces:0:1',
        \ 'M:modport:0:1',
        \ 'K:packages:0:1',
        \ 'P:programs:0:1',
        \ 'R:properties:0:1',
        \ 'T:typedefs:0:1'
    \ ],
    \ 'sro'         : '.',
    \ 'kind2scope'  : {
        \ 'm' : 'module',
        \ 'b' : 'block',
        \ 't' : 'task',
        \ 'f' : 'function',
        \ 'C' : 'class',
        \ 'V' : 'covergroup',
        \ 'I' : 'interface',
        \ 'K' : 'package',
        \ 'P' : 'program',
        \ 'R' : 'property'
    \ },
\ }

" Define regular expressions for Verilog/SystemVerilog statements
let s:verilog_function_task_dequalifier =
    \  '\('
    \ .    '\('
    \ .        'extern\s\+\(\(pure\s\+\)\?virtual\s\+\)\?'
    \ .        '\|'
    \ .        'pure\s\+virtual\s\+'
    \ .    '\)'
    \ .    '\(\(static\|protected\|local\)\s\+\)\?'
    \ .'\)'

let g:verilog_syntax = {
      \ 'assign'      : [{
                        \ 'match_start' : '[^=!]<\?=\(=\)\@!',
                        \ 'match_end'   : '\ze;',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'attribute'   : [{
                        \ 'match_start' : '\(@\s*\)\@<!(\*',
                        \ 'match_end'   : '\*)',
                        \ 'highlight'   : 'verilogDirective',
                        \ 'syn_argument': 'transparent keepend contains=verilogNumber,verilogOperator,verilogString',
                        \ }],
      \ 'block'       : [{
                        \ 'match_start' : '\<begin\>',
                        \ 'match_end'   : '\<end\>',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'block_named' : [{
                        \ 'match_start' : '\<begin\>\s*:\s*\w\+',
                        \ 'match_end'   : '\<end\>',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'class'       : [{
                        \ 'match_start' : '\<\(typedef\s\+\)\@<!\(interface\s\+\)\?class\>',
                        \ 'match_end'   : '\<endclass\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent',
                        \ }],
      \ 'clocking'    : [{
                        \ 'match_start' : '\<clocking\>',
                        \ 'match_end'   : '\<endclocking\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'comment'     : [{
                        \ 'match'       : '//.*',
                        \ 'syn_argument': 'contains=verilogTodo,verilogDirective,@Spell'
                        \ },
                        \ {
                        \ 'match_start' : '/\*',
                        \ 'match_end'   : '\*/',
                        \ 'syn_argument': 'contains=verilogTodo,verilogDirective,@Spell keepend extend'
                        \ }],
      \ 'covergroup'  : [{
                        \ 'match_start' : '\<covergroup\>',
                        \ 'match_end'   : '\<endgroup\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'define'      : [{
                        \ 'match_start' : '`ifn\?def\>',
                        \ 'match_mid'   : '`els\(e\|if\)\>',
                        \ 'match_end'   : '`endif\>',
                        \ }],
      \ 'function'    : [{
                        \ 'match_start' : s:verilog_function_task_dequalifier.'\@<!\<function\>',
                        \ 'match_end'   : '\<endfunction\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'instance'    : [{
                        \ 'match_start' : '^\s*\zs\w\+\(\s*#\s*(\(.*)\s*\w\+\s*;\)\@!\|\s\+\(\<if\>\)\@!\w\+\s*(\)',
                        \ 'match_end'   : ';',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'interface'   : [{
                        \ 'match_start' : '\(\<virtual\s\+\)\@<!\<interface\>\(\s\+class\)\@!',
                        \ 'match_end'   : '\<endinterface\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'module'      : [{
                        \ 'match_start' : '\<\(extern\s\+\)\@<!\<module\>',
                        \ 'match_end'   : '\<endmodule\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend contains=ALLBUT,verilogInterface',
                        \ }],
      \ 'property'    : [{
                        \ 'match_start' : '\<\(\(assert\|cover\)\s\+\)\@<!\<property\>',
                        \ 'match_end'   : '\<endproperty\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'prototype'   : [{
                        \ 'match'       : s:verilog_function_task_dequalifier.'\@<=\<\(task\|function\)\>',
                        \ }],
      \ 'sequence'    : [{
                        \ 'match_start' : '\<sequence\>',
                        \ 'match_end'   : '\<endsequence\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'specify'     : [{
                        \ 'match_start' : '\<specify\>',
                        \ 'match_end'   : '\<endspecify\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ 'statement'   : [{
                        \ 'match'       : '\<interface\>',
                        \ }],
      \ 'task'        : [{
                        \ 'match_start' : s:verilog_function_task_dequalifier.'\@<!\<task\>',
                        \ 'match_end'   : '\<endtask\>',
                        \ 'highlight'   : 'verilogStatement',
                        \ 'syn_argument': 'transparent keepend',
                        \ }],
      \ }

" vi: set expandtab softtabstop=4 shiftwidth=4:
