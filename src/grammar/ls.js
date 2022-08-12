// Generated automatically by nearley, version 2.20.1
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }

    const {lexer} = require("../lexer/lexer.js")

    const {ast} = require("./parserTools.js")
var grammar = {
    Lexer: lexer,
    ParserRules: [
    {"name": "Script", "symbols": ["MainScope", "EOF"], "postprocess": ast("Script")},
    {"name": "MainScope$ebnf$1", "symbols": []},
    {"name": "MainScope$ebnf$1$subexpression$1", "symbols": ["Sep", "MainScope"]},
    {"name": "MainScope$ebnf$1", "symbols": ["MainScope$ebnf$1", "MainScope$ebnf$1$subexpression$1"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "MainScope", "symbols": ["Statement", "MainScope$ebnf$1"], "postprocess": ast("MainScope")},
    {"name": "StatementList$ebnf$1", "symbols": []},
    {"name": "StatementList$ebnf$1$subexpression$1", "symbols": ["Sep", "StatementList"]},
    {"name": "StatementList$ebnf$1", "symbols": ["StatementList$ebnf$1", "StatementList$ebnf$1$subexpression$1"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "StatementList", "symbols": ["Statement", "StatementList$ebnf$1"], "postprocess": ast("StatementList")},
    {"name": "Statement", "symbols": ["BlockStatement"], "postprocess": id},
    {"name": "Statement", "symbols": ["IfStatement"], "postprocess": id},
    {"name": "Statement", "symbols": ["Expression"], "postprocess": id},
    {"name": "IfStatement$ebnf$1$subexpression$1", "symbols": [{"literal":"else"}, "Statement"]},
    {"name": "IfStatement$ebnf$1", "symbols": ["IfStatement$ebnf$1$subexpression$1"], "postprocess": id},
    {"name": "IfStatement$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "IfStatement", "symbols": [{"literal":"if"}, {"literal":"("}, "Expression", {"literal":")"}, "Statement", "IfStatement$ebnf$1"], "postprocess": ast("IfStatement", {sep: ' '})},
    {"name": "Expression", "symbols": ["MemberExpression"], "postprocess": id},
    {"name": "MemberExpression", "symbols": ["PrimaryExpression"], "postprocess": id},
    {"name": "MemberExpression", "symbols": ["MemberExpression", {"literal":"["}, "Expression", {"literal":"]"}], "postprocess": ast("MemberExpressionIndex")},
    {"name": "MemberExpression", "symbols": ["MemberExpression", {"literal":"."}, "IdentifierReference"], "postprocess": ast("MemberExpressionProperty")},
    {"name": "PrimaryExpression", "symbols": ["IdentifierReference"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["String"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["Number"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["ArrayLiteral"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["ObjectLiteral"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["MapLiteral"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": [{"literal":"this"}], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": ["FunctionExpression"], "postprocess": id},
    {"name": "PrimaryExpression", "symbols": [{"literal":"("}, "Expression", {"literal":")"}], "postprocess": ast("ParenthesizedExpression")},
    {"name": "PrimaryExpression", "symbols": ["ArrowExpression"], "postprocess": id},
    {"name": "FunctionExpression$ebnf$1", "symbols": ["ExpressionList"], "postprocess": id},
    {"name": "FunctionExpression$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "FunctionExpression", "symbols": [{"literal":"function"}, {"literal":"("}, "FunctionExpression$ebnf$1", {"literal":")"}, "BlockStatement"], "postprocess": ast("FunctionExpression")},
    {"name": "BlockStatement$ebnf$1", "symbols": ["StatementList"], "postprocess": id},
    {"name": "BlockStatement$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "BlockStatement", "symbols": [{"literal":"{"}, "BlockStatement$ebnf$1", {"literal":"}"}], "postprocess": ast("BlockStatement")},
    {"name": "ArrowExpression$ebnf$1", "symbols": ["ExpressionList"], "postprocess": id},
    {"name": "ArrowExpression$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "ArrowExpression", "symbols": [{"literal":"("}, "ArrowExpression$ebnf$1", {"literal":")"}, {"literal":"=>"}, "Statement"], "postprocess": ast("ArrowExpression")},
    {"name": "ArrowExpression", "symbols": ["PrimaryExpression", {"literal":"=>"}, "Statement"], "postprocess": ast("ArrowExpression")},
    {"name": "PropertyList$ebnf$1", "symbols": []},
    {"name": "PropertyList$ebnf$1$subexpression$1", "symbols": [{"literal":","}, "PropertyList"]},
    {"name": "PropertyList$ebnf$1", "symbols": ["PropertyList$ebnf$1", "PropertyList$ebnf$1$subexpression$1"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "PropertyList", "symbols": ["PropertyAssign", "PropertyList$ebnf$1"], "postprocess": ast("PropertyList")},
    {"name": "PropertyAssign$subexpression$1", "symbols": ["BindingIdentifier", {"literal":":"}, "Expression"]},
    {"name": "PropertyAssign", "symbols": ["PropertyAssign$subexpression$1"], "postprocess": ast("PropertyAssign")},
    {"name": "ExpressionList$ebnf$1", "symbols": []},
    {"name": "ExpressionList$ebnf$1$subexpression$1", "symbols": [{"literal":","}, "ExpressionList"]},
    {"name": "ExpressionList$ebnf$1", "symbols": ["ExpressionList$ebnf$1", "ExpressionList$ebnf$1$subexpression$1"], "postprocess": function arrpush(d) {return d[0].concat([d[1]]);}},
    {"name": "ExpressionList", "symbols": ["Expression", "ExpressionList$ebnf$1"], "postprocess": ast("ExpressionList")},
    {"name": "BindingIdentifier", "symbols": [(lexer.has("ID") ? {type: "ID"} : ID)], "postprocess": ast("BindingIdentifier")},
    {"name": "IdentifierReference", "symbols": [(lexer.has("ID") ? {type: "ID"} : ID)], "postprocess": ast("IdentifierReference")},
    {"name": "String", "symbols": [(lexer.has("String") ? {type: "String"} : String)], "postprocess": id},
    {"name": "Number", "symbols": [(lexer.has("Integer") ? {type: "Integer"} : Integer)], "postprocess": id},
    {"name": "Number", "symbols": [(lexer.has("Decimal") ? {type: "Decimal"} : Decimal)], "postprocess": id},
    {"name": "Number", "symbols": [(lexer.has("Binary") ? {type: "Binary"} : Binary)], "postprocess": id},
    {"name": "Number", "symbols": [(lexer.has("Hexadecimal") ? {type: "Hexadecimal"} : Hexadecimal)], "postprocess": id},
    {"name": "ArrayLiteral$ebnf$1", "symbols": ["ExpressionList"], "postprocess": id},
    {"name": "ArrayLiteral$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "ArrayLiteral", "symbols": [{"literal":"["}, "ArrayLiteral$ebnf$1", {"literal":"]"}], "postprocess": ast("ArrayLiteral")},
    {"name": "ObjectLiteral$ebnf$1", "symbols": ["PropertyList"], "postprocess": id},
    {"name": "ObjectLiteral$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "ObjectLiteral", "symbols": [{"literal":"{"}, "ObjectLiteral$ebnf$1", {"literal":"}"}], "postprocess": ast("ObjectLiteral")},
    {"name": "MapLiteral$subexpression$1", "symbols": ["PropertyList"]},
    {"name": "MapLiteral$subexpression$1", "symbols": [{"literal":":"}]},
    {"name": "MapLiteral", "symbols": [{"literal":"["}, "MapLiteral$subexpression$1", {"literal":"]"}], "postprocess": ast("MapLiteral")},
    {"name": "Sep$ebnf$1", "symbols": [{"literal":";"}], "postprocess": id},
    {"name": "Sep$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "Sep", "symbols": ["Sep$ebnf$1"], "postprocess": ast("Sep")},
    {"name": "EOF", "symbols": [(lexer.has("EOF") ? {type: "EOF"} : EOF)], "postprocess": id}
]
  , ParserStart: "Script"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
