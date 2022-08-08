function ast(name, props, transform = (values) => values) {
    return (values) => {return {type: name, values: transform(values), ...props}}
}


module.exports = {
    ast
}