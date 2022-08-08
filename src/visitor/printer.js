const { buildTransformer } = require("./visitor");

function opt(el) { return el ? el : ""}
function indent(el, options) { return el.replace(/^/gm, options.indent) }

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
    Comma: (node, options) => `${node.value} `,
    Colon: (node, options) => `${node.value} `,
    Sep: (_, options) => options.semi ? ";" : "",
    EOF: () => "",

    Comment: (node) => node.value + "\n"
}, {
    semi: true,
    indent: '  ',
}, {
    default: (node) => (node.values)
                            .flat(2)
                            .filter((el) => el != null)
                            .join(node.sep ?? ""),
    defaultTerminal: (node) => node.value
})

module.exports = { printer, commenter }