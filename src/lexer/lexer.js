const moo = require("moo")

const lexer = moo.compile({
    ID: { match: /[a-zA-Z_][a-zA-Z0-9_]*/, type: moo.keywords(Object.fromEntries([
        'for',
        'global',
        'var',
    ].map(k => ['kw-' + k, k])))},

    Equal: "=",
    
    Semi: ";",

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