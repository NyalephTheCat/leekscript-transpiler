const { buildTransformer } = require("./visitor");

function indent(el, {indent}) {
    if (el == null) return "";
    return el.replace(/\n/gm, "\n" + indent) 
}

function opt(el) { return el ? el : "" }

function flatten(items) {
    const flat = [];
  
    items.forEach(item => {
      if (Array.isArray(item)) {
        flat.push(...flatten(item));
      } else {
        flat.push(item);
      }
    });
  
    return flat;
  }

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
        return {type: "MetaHolder", values: [...comments, ast]}
    }
});

const printer = buildTransformer({
    ScriptBody: (node) => node.values[0].join(""),
    Sequence: (node) => {
        if (!node.values[0]) return ""

        return flatten(node.values).join("");
    },
    GlobalDeclaration: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${opt(val[2])}`;
    },
    VarDeclaration: (node) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${opt(val[2])}`;
    },
    BlockStatement: (node, options) => {
        var val = node.values;
        return `${val[0]}${indent(val[1].join(""), options)}${indent(val[2], options)}${val[3]}`;
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
    ClassDefinition: (node, options) => {
        var val = node.values;
        return `${val[0]} ${val[1]}${opt(val[2])} ${val[3]}${indent(val[4], options)}${val[5]}`
    },
    ConstructorDeclaration: (node) => {
        var val = node.values;
        return `${val[0] ? val[0] + " " : ""}${val[1]}${val[2]} ${val[3]}`
    },
    MethodDeclaration: (node) => {
        var val = node.values;
        return `${val[0] ? val[0] + " " : ""}${val[1] ? val[1] + " " : ""}${val[2]}${val[3]} ${val[4]}`
    },
    ClassPropertyDelcaration: (node) => {
        var val = node.values;
        return `${val[0] ? val[0] + " " : ""}${val[1] ? val[1] + " " : ""}${val[2]}${val[3] ? " " + opt(val[3]) : ""}${val[4]}`
    },
    FunctionBody: (node, options) => {
        var val = node.values;
        val[1] = indent(val[1].join(""), options)
        if (val[2])
            val[2] = indent(val[2], options)
        return `${val[0]} ${([...val[1], val[2]]).join("")} ${val[3]}`
    },
    ExecutionArguments: (node) => {
        var val = node.values;
        if (val[1]) 
            val[1] = val[1].replace(",", ", ");
        return val.join("")
    },
    ReturnStatement: (node) => {
        var val = node.values;
        if (val.length == 3) return `${val[0]} ${val[1]}${val[2]}`
        return `${val[0]}${val[1]}`
    },
    String: (node) => node.text,
    EOF: () => "",
    EmptyStatement: () => ";",
    Sep: (node, options) => options.semi(node.getSibling(-1)) ? ";" : "",
    Comment: (node) => node.value + "\n",
    NewLine: (node) => node.value
}, {
    semi: (prev) => {
        return prev == null || ![
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