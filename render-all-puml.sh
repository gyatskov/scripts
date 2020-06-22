#!/usr/bin/env bash
##
## @author Gennadij Yatskov (gennadij@yatskov.de)
##

readonly PLANTUML_BINARY=/opt/plantuml.jar

for file in ./*.puml; do java -jar ${PLATNUML_BINARY} -tsvg $file; done

