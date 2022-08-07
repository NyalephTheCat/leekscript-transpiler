function transform(ast, visitor, options = {}, transformerOption = {default: (el) => el, defaultTerminal: (el) => el}) {
    if (ast === null) return null;
    ast = transformerOption.onEnter(ast, options);

    if (Array.isArray(ast)) { return ast.map((el) => transform(el, visitor, options, transformerOption)) }

    const hasRule = !!visitor[ast.type]
    
    if (ast.terminal) {
        return transformerOption.onExit(hasRule ? visitor[ast.type](ast, options) : transformerOption.defaultTerminal(ast, options));
    }
    if (ast.values)
        ast.values = ast.values.map((el) => transform(el, visitor, options, transformerOption))
    return transformerOption.onExit(hasRule ? visitor[ast.type](ast, options) : transformerOption.defaultTerminal(ast, options));
}

function buildTransformer(visitor, defaultOptions, transformerOption) {
    return (ast, options) => module.exports.transform(
        ast, 
        visitor, 
        Object.assign(defaultOptions, options), 
        Object.assign({default: (el) => el, defaultTerminal: (el) => el, onEnter: (el) => el, onExit: (el) => el}, transformerOption)
    )
}

module.exports = { buildTransformer, transform }