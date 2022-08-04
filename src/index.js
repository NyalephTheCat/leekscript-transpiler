const nearley = require("nearley");
const fs = require("fs")
const grammar = require("./grammar/ls.js");
const util = require('node:util');
require("colors");
const {diffLines} = require("diff");

const {printer} = require("./visitor/printer.js")

const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar))

const filename = "test"

const inputString = fs.readFileSync(filename).toString()
const results = parser.feed(inputString).results

const outString = printer(results[0]) ?? ""

fs.writeFileSync("out-" + filename, outString)

const diff = diffLines(inputString, outString)

diff.forEach((part) => {
    // green for additions, red for deletions
    // grey for common parts
    const color = part.added ? 'green' :
        part.removed ? 'red' : 'grey';
    process.stdout.write(part.value[color]);
});

console.log("\n", util.inspect(results, {depth: null}))