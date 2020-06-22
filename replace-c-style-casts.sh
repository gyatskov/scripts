#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)

perl -p -i -e "s/(?<!(?<!operator)(?>[ =+\-]))\B(?'type'(?<![>)\]])\(\s*?(?>[[:alpha:]_]+(?>[\w_\:\s\[\]]|[*&](?!\w))*|(?&type))+?\))\s*(?'expr'[\w_]*\(\s*(?&expr)\s*\)|(?>[\w_]|[*&](?=\w+))+?[[:blank:]:\w*\/\->\+.\[\]]*)/static_cast<\1>(\2)/g" `fd "\.(cpp|h)$" .`

