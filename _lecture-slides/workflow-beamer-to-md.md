#  Convert old beamer slides to markdown

1. Terminal> "pandoc -o newslides.md oldslides.tex"

1. If errors, may need to adjust .tex file. Multiple \end{document} calls cause trouble

1. To remove excess `.1in` or `.2in` use Emacs: (1) `M-x replace-regexp` (2) `\.[0-9]in`

1. To add `---` to top of slides (titles begun with `###`, use Emacs (1) `M %` (2) `###` Ret `--- C-q C-j C-q C-j ##` [`C-q` is quoted escape while `C-j` is a return in the mini buffer.]

