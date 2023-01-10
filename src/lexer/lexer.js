const moo = require("moo")
const {inspect} = require('util')

const keywords = Object.fromEntries([
    'abstact',
    'arguments',
    'as',
    'await',
    'break',
    'byte',
    'case',
    'catch',
    'char',
    'class',
    'const',
    'constructor',
    'continue',
    'default',
    'do',
    'double',
    'else',
    'enum',
    'eval',
    'export',
    'extends',
    'false',
    'final',
    'finally',
    'float',
    'for',
    'function',
    'global',
    'goto',
    'if',
    'implements',
    'in',
    'include',
    'instanceof',
    'int',
    'interface',
    'let',
    'long',
    'native',
    'new',
    'not',
    'null',
    'package',
    'private',
    'protected',
    'public',
    'return',
    'short',
    'static',
    'super',
    'switch',
    'synchronized',
    'this',
    'throw',
    'throws',
    'transient',
    'true',
    'try',
    'typeof',
    'var',
    'void',
    'volatile',
    'while',
    'with',
    'yield',
].map(k => ['kw-' + k, k]))

const ops = [
    "+",
    "-",
    "**",
    "*",
    "/",
    "\\",
    "%",
    "^^",
    "||",
    "&&",
    "^",
    "|",
    "&",
    "~",
    "!",
]
const opsAssign = ops.map(el => el + "=")
const compare = [
    "==",
    ">=",
    "<=",
    "!=",
    ">",
    "<",
]

const operators = [...ops, ...opsAssign, ...compare, "="].map(el => "operator" + el)

const lexer = moo.compile({
    NewLine: { match: "\n" },
    WS: { match: /[\s]+/, lineBreaks: true },
    Comment: { match: /\/\/.*?(?:\n|$)/ },
    MultilineComment: { match: /\/\*.*?\*\// },

    OperatorName: operators,
    ID: { match: /[a-zA-Z_][a-zA-Z0-9_]*/, type: moo.keywords(keywords)},

    groupings: [
        "(", ")",
        "{", "}",
        "[", "]",
    ],
    Compare: compare,
    Equal: "=",
    BinAssign: opsAssign,
    BinOps: ops,
    Semi: ";",
    Comma: ",",
    Colon: ":",
    Dot: ".",

    // Numbers
    Hexadecimal: { match: /0[xX][0-9A-Fa-f](?:_?[0-9A-Fa-f])*/ },
    Binary: { match: /0[bB][01](?:_?[01])*/ },
    Decimal: { match: /[0-9](?:_?[0-9])*\.[0-9](?:_?[0-9])*|\.[0-9](?:_?[0-9])*/ },
    Integer: { match: /[0-9](?:_?[0-9])*/ },

    String: [
        {match: /"(?:\\["\\rn]|[^"\\])*?"/, lineBreaks: true, value: x => x.slice(1, -1)},
        {match: /'(?:\\['\\rn]|[^'\\])*?'/, lineBreaks: true, value: x => x.slice(1, -1)},
    ],
})

lexer.lastTok = {type: null}
lexer.next = (next => () => {
    if (lexer.lastTok.type === "EOF") return undefined;
    let tok;
    let comments = [];

    while ((tok = next.call(lexer))) {
        tok.terminal = true;
        lexer.lastTok = tok;
        if (["Comment", "MultilineComment", "NewLine"].includes(tok.type)) {
            comments.push(tok);
            continue;
        } else if (tok.type === "WS") {
            continue;
        }
        break;
    }
    if (tok === undefined) {
        tok = {
            type: 'EOF',
            value: '<eof>',
            text: '',
            offset: 0,
            lineBreaks: 0,
            line: lexer.line,
            col: lexer.col,
        }
        lexer.lastTok = tok
    }
    tok.comments = comments;
    tok.terminal = true;
    tok = {
        [inspect.custom]: (depth) =>  `<${tok.type}: "${tok.value}">`,
        ...tok
    }
    return tok;
})(lexer.next)

module.exports = { lexer }