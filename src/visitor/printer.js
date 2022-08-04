const { getTransformer } = require("./utils.js")

const indent = (str) => {
    console.log(str)
    return str.split("\n").map(x => "    " + x).join("\n")
}

module.exports.printer = getTransformer({
    default: (node) => node,
    
    Script: ({body}) => body ? body : "",

    GlobalScopeList: ({list}) => list.join("\n"),
    StatementList: ({list}) => list.join("\n"),

    GlobalDeclaration: ({id, value}) => `global ${id}${value?` = ${value}`:""};`,

    EmptyStatement: () => `;`,
    BlockStatement: ({list}) => list ? `{\n${indent(list)}\n}` : "{}",
    VariableDeclaration: ({id, value}) => `var ${id}${value?` = ${value}`:""};`,
    FunctionDeclaration: ({name, args, body}) => `function ${name}(${args}) ${body}`,
    ArgumentList: ({list}) => list.join(", "),

    ForIterStatement: ({init, cond, iter, statement}) => `for (${init ? init : ";"}${cond ? " " + cond : ""};${iter ? " " + iter : ""}) ${statement}`,
    ForInStatement: ({keyName, valueName, expr, statement}) => `for (${keyName ? `var ${keyName} : ` : ""}var ${valueName} in ${expr}) ${statement}`,

    ReturnStatement: ({value}) => `return ${value};`,

    BindingIdentifier: ({name}) => name,
    IdentifierReference: ({name}) => name,
})