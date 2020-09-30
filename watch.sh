#!/bin/sh

project_chsum=""

watch_project() {
  chsum2=`find . -type f \( -name "*.tex" -o -name "*.bib" \) -mtime -5 -exec md5 {} \;`
  if [[ $project_chsum != $chsum2 ]] ; then
    pdflatex -synctex=1 -interaction=nonstopmode thesis.tex
    bibtex thesis.aux

    project_chsum=$chsum2
  fi
}

while [[ true ]]
do
  watch_project
  sleep 5
done