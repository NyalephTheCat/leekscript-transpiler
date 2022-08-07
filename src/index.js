const yargs = require("yargs");
const fs = require("fs");
const nearley = require("nearley");
const grammar = require("./grammar/ls");
const { inspect } = require("util");
const { lexer } = require("./lexer/lexer");
const { printer, commenter } = require("./visitor/printer");

const options = yargs
 .usage("Usage: -f <file> -o <output>")
 .option("f", { alias: "file", describe: "The file to parse", type: "string", default: null })
 .option("o", { alias: "out", describe: "The output file", type: "string", default: null})
 .argv;

const input = fs.readFileSync(options.file).toString();

console.log(`${options.file} > ${options.out}`);

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));

var ast = parser.feed(input).results

ast = commenter(ast[0])

//console.log(inspect(ast, { depth: null}))

const out = printer(ast, {});

console.log(out)