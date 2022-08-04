const moo = require("moo")

module.exports.lexer = moo.states({
    main: {
        ReservedWord: [
            "break",
            "case",
            "catch",
            "class",
            "const",
            "continue",
            "debugger",
            "default",
            "delete",
            "do",
            "else",
            "enum",
            "export",
            "extends",
            "finally",
            "for",
            "function",
            "global",
            "if",
            "import",
            "in",
            "include",
            "instanceof",
            "new",
            "null",
            "return",
            "super",
            "switch",
            "this",
            "throw",
            "try",
            "typeof",
            "var",
            "void",
            "while",
            "with",
            "yield",
        ],
        
        boolean: [
            "true",
            "false",
        ],

        groupings: [
            "(", ")",
            "{", "}",
            "[", "]",
        ],

        binAssignementOperator: [
            "&&=", "||=",
        ],

        assignementOperator: [
            "**=",
            "*=", "/=", "\\=", "%=", 
            "+=", "-=", 
            "<<=", ">>=", ">>>=", 
            "&=", "^=", "|=",
        ],

        operator: [
            "++", "--",
            "+", "-", "~", "!",
            "**",
            "*", "/", "\\",
            "<<", ">>>", ">>",
            ">=", "<=",
            ">", "<",
            // "===", "!==",
            "==", "!=",
            "&&", "||",
            "&", "^", "|",
            "?", ":",
            "="
        ],

        semi: ";",

        // Numbers
        Hexadecimal: { match: /0[xX][0-9A-Fa-f](?:_?[0-9A-Fa-f])*/ },
        Octal: { match: /0[oO][0-7](?:_?[0-7])*/ },
        Binary: { match: /0[bB][01](?:_?[01])*/ },
        Decimal: { match: /[0-9](?:_?[0-9])*\.[0-9](?:_?[0-9])*|\.[0-9](?:_?[0-9])*/ },
        Integer: { match: /[0-9](?:_?[0-9])*/ },

        String: [
            {match: /"(?:\\["\\rn]|[^"\\])*?"/, lineBreaks: true, value: x => x.slice(1, -1)},
            {match: /'(?:\\['\\rn]|[^'\\])*?'/, lineBreaks: true, value: x => x.slice(1, -1)},
        ],

        WS: { match: /[\s]/, lineBreaks: true },

        ID: { match: /[_a-zA-Z](?:[_a-zA-Z0-9])*/ }, // Matches every non reserved id
    }
})