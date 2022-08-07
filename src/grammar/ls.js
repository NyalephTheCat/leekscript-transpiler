// Generated automatically by nearley, version 2.20.1
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }

    const {lexer} = require("../lexer/lexer.js")

    const store = (type) => (values) => {return {type, values, terminal: false}}
    const storeList = (type) => (values) => {return {type, values: values[0], terminal: false}}
var grammar = {
    Lexer: lexer,
    ParserRules: [
    {"name": "Script$ebnf$1", "symbols": ["GlobalScopeList"], "postprocess": id},
    {"name": "Script$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "Script", "symbols": ["Script$ebnf$1", (lexer.has("EOF") ? {type: "EOF"} : EOF)], "postprocess": store("Script")},
    {"name": "GlobalScopeList$ebnf$1", "symbols": ["GlobalScopeElem"]},
    {"name": "GlobalScopeList$ebnf$1", "symbols": ["GlobalScopeList$ebnf$1", "GlobalScopeElem"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "GlobalScopeList", "symbols": ["GlobalScopeList$ebnf$1"], "postprocess": storeList("GlobalScopeList")},
    {"name": "GlobalScopeElem", "symbols": ["GlobalDeclaration"], "postprocess": id},
    {"name": "GlobalDeclaration$ebnf$1", "symbols": ["Initializer"], "postprocess": id},
    {"name": "GlobalDeclaration$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "GlobalDeclaration", "symbols": [{"literal":"global"}, "BindingIdentifier", "GlobalDeclaration$ebnf$1", "sep"], "postprocess": store("GlobalDeclaration")},
    {"name": "Expression", "symbols": ["Atom"], "postprocess": id},
    {"name": "Atom", "symbols": ["IdentifierReference"], "postprocess": id},
    {"name": "Initializer", "symbols": [{"literal":"="}, "Expression"], "postprocess": store("Initializer")},
    {"name": "BindingIdentifier", "symbols": [(lexer.has("ID") ? {type: "ID"} : ID)], "postprocess": id},
    {"name": "IdentifierReference", "symbols": [(lexer.has("ID") ? {type: "ID"} : ID)], "postprocess": id},
    {"name": "sep$ebnf$1", "symbols": [(lexer.has("Semi") ? {type: "Semi"} : Semi)], "postprocess": id},
    {"name": "sep$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "sep", "symbols": ["sep$ebnf$1"], "postprocess": id}
]
  , ParserStart: "Script"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
