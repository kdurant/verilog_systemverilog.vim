" Vim filetype plugin file
" Language:	SystemVerilog (superset extension of Verilog)

au! BufNewFile,BufRead *.v,*.vh,*.vp setfiletype verilog

au! BufNewFile,BufRead *.sv,*.svi,*.svh,*.svp,*.sva setfiletype systemverilog