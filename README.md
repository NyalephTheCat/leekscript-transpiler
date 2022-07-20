# Leekscript transpiler

todo: add more info here :)

Currently there is only a basic parser located in `./src/parser/lsv4.lark`

To run the transpiler, you just need to run `python ./src/index.py`
You might need to edit some variables inside of that file to open the file you want

The parser is really limited and still misses any unary, binary and ternary operation, so `a == b` or `a + b` are not yet valid
The parser is also more permissive than lsv4 currently (allowing such things as the spread operator) 

# Stuff planned:

- Fully valid leekscript 4 parser
- Binder
- Function inliner
- Formatter
- Optimisator