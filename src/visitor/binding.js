const { transform } = require("./utils.js")

module.exports.binder = function(ast) {
    var returnScope = ast;

    const visitor = {
        default: (node) => node,

        ReturnStatement: (node) => {return { ...node, bind:returnScope }}
    }

    return transform(ast, visitor);
}