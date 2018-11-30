"Black     DarkBlue DarkGreen DarkCyan  DarkRed     DarkMagenta Brown       DarkYellow                                                                                  
"LightGray DarkGrey Blue      LightBlue Green        LightGreen Cyan
"LightCyan Red      LightRed  Magenta   LightMagenta Yellow     LightYellow White
hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="sasho"
hi      Normal               cterm=bold            ctermfg=LightBlue     ctermbg=Black       guifg=White  guibg=Black                                                   
hi      SpecialKey                                 ctermfg=DarkRed
hi      NonText                                    ctermfg=DarkRed
hi      Directory                                  ctermfg=Brown
hi      ErrorMsg                                   ctermfg=Red           ctermbg=Black                                                                                  
hi      Search                                     ctermfg=Blue          ctermbg=Yellow                                                                                 
hi      MoreMsg                                    ctermfg=DarkGreen
hi      LineNr                                     ctermfg=DarkCyan
hi      Question                                   ctermfg=DarkGreen
hi      Title                                      ctermfg=DarkMagenta
hi      Visual               cterm=reverse
hi      WarningMsg                                 ctermfg=DarkRed
hi      Constant                                   ctermfg=Cyan
hi      Special                                    ctermfg=Red
hi      Identifier                                 ctermfg=Brown
hi      Statement                                  ctermfg=Magenta
hi      PreProc                                    ctermfg=DarkMagenta
hi      Type                                       ctermfg=Brown
hi      Error                                      ctermfg=DarkCyan      ctermbg=Black                                                                                  
hi      Todo                                       ctermfg=Black         ctermbg=DarkCyan                                                                               
hi      CursorLine           cterm=underline
hi      CursorColumn         cterm=underline
hi      MatchParen                                 ctermfg=Blue
hi      TabLine              cterm=bold,underline  ctermfg=LightBlue     ctermbg=Black                                                                                  
hi      TabLineFill          cterm=bold,underline  ctermfg=Black         ctermbg=DarkGreen                                                                              
hi      TabLineSel           cterm=underline,bold  ctermfg=Green         ctermbg=Black                                                                                  
hi      Underlined                                 ctermfg=Red
hi      Folded                                     ctermfg=Red           ctermbg=Black                                                                                  
hi      Ignore                                     ctermfg=Black         ctermbg=Black                                                                                  
hi      FoldColumn                                 ctermfg=Red           ctermbg=Black                                                                                  
hi      link                 IncSearch             Visual
hi      link                 String                Constant
hi      link                 Character             Constant
hi      link                 Number                Constant
hi      link                 Boolean               Constant
hi      link                 Float                 Number
hi      link                 Function              Identifier
hi      link                 Conditional           Statement
hi      link                 Repeat                Statement
hi      link                 Label                 Statement
hi      link                 Operator              Statement
hi      link                 Keyword               Statement
hi      link                 Exception             Statement
hi      link                 Include               PreProc
hi      link                 Define                PreProc
hi      link                 Macro                 PreProc
hi      link                 PreCondit             PreProc
hi      link                 StorageClass          Type
hi      link                 Structure             Type
hi      link                 Typedef               Type
hi      link                 Tag                   Special
hi      link                 SpecialChar           Special
hi      link                 Delimiter             Special
hi      link                 SpecialComment        Special
hi      link                 Debug                 Special

