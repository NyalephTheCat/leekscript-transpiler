from functools import cache
from transformers.basic import BasicWriter
from lark import Lark

@cache
def get_parser():
    with open("src/parser/lsv4.lark", "r", encoding="UTF-8") as f:
        ls_parser = Lark(f.read(), start="script")
    return ls_parser

@cache
def parse_file(filename):
    with open(filename, "r", encoding="UTF-8") as f:
        tree = get_parser().parse(f.read())
    return tree

@cache
def transpile(infile, outfile):
    tree = parse_file(infile)

    #print(tree.pretty())
    
    with open(outfile, "w+", encoding="UTF-8") as f:
        f.write(BasicWriter().transform(tree))

transpile("input.lk", "output.lk")