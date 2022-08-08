const moo = require("moo")

const lexer = moo.compile({
    ID: { match: /[a-zA-Z_][a-zA-Z0-9_]*/, type: moo.keywords(Object.fromEntries([
        'for',
        'function',
        'global',
        'super',
        'this',
        'var',
    ].map(k => ['kw-' + k, k])))},

    groupings: [
        "(", ")",
        "{", "}",
        "[", "]",
    ],

    Equal: "=",
    
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

    WS: { match: /[\s]+/, lineBreaks: true },
    Comment: { match: /\/\/.*?(?:\n|$)/ },
    MultilineComment: { match: /\/\*.*?\*\// }
})

lexer.lastTok = {type: null}
lexer.next = (next => () => {
    if (lexer.lastTok.type === "EOF") return undefined;
    let tok;
    let comments = [];

    while ((tok = next.call(lexer))) {
        tok.terminal = true;
        lexer.lastTok = tok;
        if (["Comment", "MultilineComment"].includes(tok.type)) {
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
    return tok;
})(lexer.next)

module.exports = { lexer }