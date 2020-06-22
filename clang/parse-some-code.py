#!/usr/bin/env python

##
## import sys
## import clang.cindex
##
## def find_typerefs(node, typename):
##     if node.kind.is_reference():
##         ref_node = clang.cindex.Cursor_ref(node)
##         print(ref_node)
##         if ref_node.spelling == typename:
##             print('Found: %s [line %s, col %s]' % (
##                 typename, node.location.line, node.location.column
##             ))
##     for c in node.get_children():
##         find_typerefs(c, typename)
##
## index = clang.cindex.Index.create()
## #print(help(tu))
## tu = index.parse(sys.argv[1])
## print('Translation unit: ', tu.spelling)
## print([t for t in tu.get_tokens()])
## find_typerefs(tu.cursor, sys.argv[2])



#===- cindex-includes.py - cindex/Python Inclusion Graph -----*- python -*--===#
#
#                     The LLVM Compiler Infrastructure
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
#
#===------------------------------------------------------------------------===#


def main():
    import sys
    from clang.cindex import Index

    from optparse import OptionParser, OptionGroup

    parser = OptionParser("usage: %prog [options] {filename} [clang-args*]")
    parser.disable_interspersed_args()
    (opts, args) = parser.parse_args()
    if len(args) == 0:
        parser.error('invalid number arguments')

    # FIXME: Add an output file option
    out = sys.stdout

    index = Index.create()
    tu = index.parse(None, args)
    if not tu:
        parser.error("unable to load input")

    # A helper function for generating the node name.
    def name(f):
        if f:
            return "\"" + f.name + "\""

    # Generate the include graph
    out.write("digraph G {\n")
    for i in tu.get_includes():
        line = "  ";
        if i.is_input_file:
            # Always write the input file as a node just in case it doesn't
            # actually include anything. This would generate a 1 node graph.
            line += name(i.include)
        else:
            line += '%s->%s' % (name(i.source), name(i.include))
        line += "\n";
        out.write(line)
    out.write("}\n")

if __name__ == '__main__':
    main()