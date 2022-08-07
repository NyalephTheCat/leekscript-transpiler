const { buildTransformer } = require("./visitor");

function opt(el) { return el ? el : ""}

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
    Script: (node) => `${opt(node.values[0])}${node.values[1]}`,
    GlobalScopeList: (node) => `${node.values.join("\n")}`,
    GlobalDeclaration: (node) => `${node.values[0]} ${node.values[1]}${opt(node.values[2])}${node.values[3]}`,

    Initializer: (node) => ` = ${node.values[1]}`,

    BindingIdentifier: (node) => node.values[0],

    EOF: () => "",

    CommentHolder: (node) => node.values.join("\n"),
}, {}, {
    defaultTerminal: (node) => node.value
})

module.exports = { printer, commenter }