module.exports.transform = function(ast, visitor) {
    if (Array.isArray(ast)) {
        var out = []
        for (var el of ast) out.push(module.exports.transform(el, visitor))

        return out;
    }
    if (!(ast instanceof Object)) return ast
    var node = {}
    for (let key in ast) {
        if (key === "type") node["type"] = ast["type"]
        else node[key] = module.exports.transform(ast[key], visitor)
    }

    if (visitor[ast.type]) return visitor[ast.type](node)
    else if (visitor.default) return visitor.default(node)
    else return node
}
module.exports.getTransformer = function(visitor) {
    return (ast) => module.exports.transform(ast, visitor)
}