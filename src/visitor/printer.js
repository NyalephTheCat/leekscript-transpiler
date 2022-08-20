const { options } = require("yargs");
const { buildTransformer } = require("./visitor");

function indent(el, options) { return el.replace(/^/gm, options.indent) }

function defaultPrinter(node) {
    return (node.values)
        .flat(2)
        .filter((el) => el != null)
        .join(node.sep ?? "")
}

const commenter = buildTransformer({}, {}, {
    default: (ast) => ast,
    defaultTerminal: (ast) => {
        if (!ast.comments || ast.comments.length === 0) return ast;
        const comments = ast.comments;
        delete ast.comments
        return {type: "CommentHolder", values: [...comments, ast]}
    }
});

const printer = buildTransformer({
    ScriptBody: (node) => node.values[0].join("\n"),
    GlobalDeclaration: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${val[2] ? ` ${val[2]}` : ""}`;
    },
    VarDeclaration: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${val[2] ? ` ${val[2]}` : ""}`;
    },
    BlockStatement: (node, options) => {
        var val = node.values;
        val[1] = val[1].join("\n");
        return `${val[0]}\n${indent(val[1], options)}\n${val[2]}`;
    },
    IfStatement: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${val[2]}${val[3]} ${val[4]}${val[5] ? ` ${val[5][0]} ${val[5][1]}` : ""}`
    },
    WhileStatement: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${val[2]}${val[3]} ${val[4]}${val[5] ? ` ${val[5][0]} ${val[5][1]}` : ""}`
    },
    DoWhileStatement: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]} ${val[2]} ${val[3]}${val[4]}${val[5]}`
    },
    Initializer: (node) => {
        node.sep = " ";
        return defaultPrinter(node);
    },
    ForStatement: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${val[2]}${val[3]} ${val[4]}`
    },
    ForInHeader: (node) => {
        var val = node.values;
        return `${val[0] ? `${val[0][0]} ${val[0][1]}${val[0][2]} ` : ""}${val[1]} ${val[2]} ${val[3]} ${val[4]}`
    },
    EOF: () => "",
    EmptyStatement: () => ";",
    Sep: (node, options) => options.semi(node.getSibling(-1)) ? ";" : "",
    Comment: (node) => node.value + "\n"
}, {
    semi: (prev) => {
        return ![
            "BlockStatement", 
            "IfStatement", 
            "ForStatement", 
            "WhileStatement", 
            "FunctionStatement"
        ].includes(prev[0]?.type)
    },
    indent: '    ',
}, {
    default: defaultPrinter,
    defaultTerminal: (node) => node.value
})

module.exports = { printer, commenter }