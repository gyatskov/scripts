#!/usr/bin/env bash
## @author Gennadij Yatskov (gennadij@yatskov.de)
readonly parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
rgi='rg --no-heading --line-number --column'

# Regex construction
readonly datatype='\(\w*[[:alpha:]_]+[[:alnum:]*_&:\s\[\]]+\w*\)'
readonly identifier='([[:alpha:]]+[[:alnum:]_.:\[\]]+)'
readonly regex_simple="$datatype"'\s*'"$identifier"

# Recursive regex matching parantheses
readonly datatype_recursive='\((?>[[:alpha:]_]+[[:alnum:]_*&\:\s\[\]]+|(?R))*\)'
#readonly identifier_recursive='\((?>[[:alpha:]_*&]+[[:alnum:]*_&\:\w\[\]]+|(?R))*\)'
readonly identifier_recursive='\((?>[[:alpha:]_*&]+[[:alnum:]*_&\:\s\[\]]+|(?R))*\)'
#readonly regex_recursive="$datatype_recursive"'\s*'"$identifier_recursive"

readonly regex_recursive="(?'all'\B(?'type'(?<![>)\]])\(\s*?(?>[[:alpha:]_]+(?>[\w_\:\s\[\]]|[*&](?!\w))*|(?&type))+?\))\s*(?'expr'\(\s*(?&expr)+\s*\)|(?&all)|(?>[\w_]|[*&](?=\w++))+?[[:blank:]:\w*\/\->\+.\[\]]*))"

readonly regex="$regex_recursive"

# Using ripgrep (any tool supporting PCRE2 will do)
readonly glob='*.{cpp,h}'
#$rgi -g "$glob" -e "$regex" --pre $parent_path/preprocess.sh --pre-glob "$glob"
$rgi -g "$glob" --pcre2 -e "$regex" --pre $parent_path/preprocess.sh --pre-glob "$glob"

# Filter using e.g.
# ... | grep -v -E "contrib|3rdParty"





# Named type and expression
#(?'type'\(\s*(?>[[:alpha:]_]+[\w_\*&\:\s\[\]]+|(?&type))*\))\s*(?'expr'\(\s*(?&expr)\s*\)|\s*[\w_*&]+[\w*\*\/\-\+\.\[\]]*)

# Recursive superpattern
# (?'all'\B(?'type'(?<![>)\]])\(\s*?(?>[[:alpha:]_]+(?>[\w_\:\s\[\]]|[*&](?!\w))*|(?&type))+?\))\s*(?'expr'\(\s*(?&expr)+\s*\)|(?&all)|(?>[\w_]|[*&](?=\w++))+?[[:blank:]:\w*\/\->\+.\[\]]*))

#(?'all'\B(?'type'(?<![>)\]])\(\s*?(?>[[:alpha:]_]+(?>[\w_\:\s\[\]]|[*&](?!\w))*|(?&type))+?\))\s*(?'expr'\(\s*(?&expr)+\s*\)|(?&expr)|(?>[\w_]|[*&](?=\w++))+?[[:blank:]:\w*\/\->\+.\[\]]*))

# Named type and expression w/ condition
#(?'type'\(\s*(?>[[:alpha:]_]+[\w_\*&\:\s\[\]]+|(?&type))*\))\s*(?('type')(?'expr'\(\s*(?&expr)\s*\)|\s*[\w_*&]+[\w*\*\/\-\+\.\[\]]*))


#\B(?'type'(?<![>)\]])\(\s*?(?>[[:alpha:]_]+(?>[\w_\:\s\[\]]|[*&](?!\w))*|(?&type))+?\))\s*(?'expr'[\w_]*\(\s*(?&expr)\s*\)|(?>[\w_]|[*&](?=\w+))+?[[:blank:]:\w*\/\->\+.\[\]]*)



# Expressions
#(?(DEFINE)(?'binop'[+*%\-\/]|==|!=)(?'identifier'[[:alpha:]_]+\w*)(?'literal'[\d]+([.]\d*)?[fFuUlL]{0,2}))(?'subexpr'\((?&subexpr)\)|(?(R&subexpr)(?>(?&literal)|(?&identifier))|(?&subexpr)(?&binop)(?&subexpr))|(?&identifier)|(?&literal))


# Regex with test suite: 
# * https://regex101.com/r/opfshZ/1
# * https://regex101.com/r/UIj3JO/1

