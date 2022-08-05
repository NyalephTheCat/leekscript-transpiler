const { getTransformer } = require("./utils.js")

const indent = (str) => {
    if (typeof str !== "string") {
        console.log(str)
        return str;
    }
    return str.split("\n").map(x => "    " + x).join("\n")
}

module.exports.printer = getTransformer({
    default: (node) => node,
    
    Script: ({body}) => body ? body : "",

    GlobalScopeList: ({list}) => list.join("\n"),
    StatementList: ({list}) => list.join("\n"),

    GlobalDeclaration: ({id, value}) => `global ${id}${value?` = ${value}`:""};`,

    ClassDefinition: ({name, heritage, body}) => `class ${name}${heritage ? ` ${heritage}` : ""} {\n${indent(body)}\n}`,
    ClassHeritage: ({superClass}) => `extends ${superClass}`,
    ClassBody: ({list}) => list.join("\n"),
    ClassProperty: ({visibility, static, name, init}) => `${visibility ? visibility + " " : ""}${static ? static + " " : ""}${name}${init ? init : ""};`,
    ClassMethod: ({visibility, static, name, args, body}) => `${visibility ? visibility + " " : ""}${static ? static + " " : ""}${name}(${args}) ${body}`,
    Constructor: ({visibility, args, body}) => `${visibility ? visibility + " " : ""}constructor(${args}) ${body}`,

    IncludeStatement: (path) => `include(${path.path});`,

    EmptyStatement: () => `;`,
    BlockStatement: ({list}) => list ? `{\n${indent(list)}\n}` : "{}",
    VariableDeclaration: ({id, value}) => `var ${id}${value?` = ${value}`:""};`,
    FunctionDeclaration: ({name, args, body}) => `function ${name}(${args}) ${body}`,
    ArgumentList: ({list}) => list.join(", "),

    ForIterStatement: ({init, cond, iter, statement}) => `for (${init ? init : ";"}${cond ? " " + cond : ""};${iter ? " " + iter : ""}) ${statement}`,
    ForInStatement: ({keyName, valueName, expr, statement}) => `for (${keyName ? `var ${keyName} : ` : ""}var ${valueName} in ${expr}) ${statement}`,

    IfStatement: ({cond, then, elseCase}) => `if (${cond}) ${then}${elseCase ? ` else ${elseCase}` : ""}`,

    WhileStatement: ({cond, loop}) => `while (${cond}) ${loop}`,
    DoWhileStatement: ({cond, loop}) => `do ${loop} while (${cond});`,

    BreakStatement: () => `break;`,
    ContinueStatement: () => `continue;`,

    ReturnStatement: ({value}) => `return ${value};`,

    ExpressionStatement: ({statement}) => `${statement};`,
    ExpressionList: ({list}) => list.join(", "),

    BindingIdentifier: ({name}) => name,
    IdentifierReference: ({name}) => name,
    PropertyName: ({name}) => name,

    StringLiteral: ({value}) => `"${value}"`,
    ArrayLiteral: ({data}) => `[${data}]`,
    MapLiteral: ({data}) => data ? "[:]" : `[${data}]`,
    ObjectLiteral: ({data}) => `{${data}}`,

    PropertyList: ({list}) => list.join(", "),
    Property: ({name, value}) => `${name}: ${value}`,
})