@{%

const { lexer } = require("./lexer.js")

%}

@lexer lexer

Script ->
    null                                                                       {% () => {return {type: "Script"}} %}
  | GlobalScopeList                                                            {% ([body]) => {return {type: "Script", body: body}} %}

GlobalScopeList ->
    GlobalScopeElem                                                            {% ([elem]) => {return {type: "GlobalScopeList", list: [elem]}} %}
  | GlobalScopeList __ GlobalScopeElem                                          {% ([list,,elem]) => {return {type: "GlobalScopeList", list: [...list.list, elem]}} %}

GlobalScopeElem ->
    GlobalDeclaration                                                          {% id %}
  | ClassDefinition                                                            {% id %}
  | IncludeStatement                                                           {% id %}
  | Statement                                                                  {% id %}

StatementList ->
    Statement                                                                  {% ([elem]) => {return {type: "StatementList", list: [elem]}} %}
  | StatementList __ Statement                                                  {% ([list,,elem]) => {return {type: "StatementList", list: [...list.list, elem]}} %}

Statement ->
    EmptyStatement                                                             {% id %}
  | BlockStatement                                                             {% id %}
  | VariableDeclaration                                                        {% id %}
  | FunctionDeclaration                                                        {% id %}
  | ForStatement                                                               {% id %}
  | IfStatement                                                                {% id %}
  | WhileStatement                                                             {% id %}
  | DoWhileStatement                                                           {% id %}
  | BreakStatement                                                             {% id %}
  | ContinueStatement                                                          {% id %}
  | ReturnStatement                                                            {% id %}
  | ExpressionStatement                                                        {% ([statement]) => {return {type: "ExpressionStatement", statement}} %}

ExpressionList ->
    Expression                                                                 {% ([item]) => {return {type: "ExpressionList", list: [item]}} %}
  | ExpressionList _ "," _ Expression                                          {% ([list,,,,item]) => {return {type: "ExpressionList", list: [...list.list, item]}} %}

Expression -> #TODO add all math stuff
    Atom                                                                       {% id %}

Atom ->
    NumberLiteral                                                              {% id %}
  | StringLiteral                                                              {% id %}
  | BooleanLiteral                                                             {% id %}
  | ArrayLiteral                                                               {% id %}
  | ObjectLiteral                                                              {% id %}
  | MapLiteral                                                                 {% id %}
  | IdentifierReference                                                        {% id %}
  | Pattern                                                                    {% id %}

##### Statements
### GlobalStatement

GlobalDeclaration ->
    "global" __ BindingIdentifier _ Initializer sep                            {% ([,,id,,value]) => {return {type: "GlobalDeclaration", id, value}} %}
  | "global" __ BindingIdentifier _ sep                                        {% ([,,id]) => {return {type: "GlobalDeclaration", id}} %}

# ClassDefinition

ClassDefinition ->
    "class" _ BindingIdentifier _ ClassHeritage _ "{" _ ClassBody _ "}"        {% ([,,name,,heritage,,,,body]) => {return {type: "ClassDefinition", name, heritage, body}} %}

ClassHeritage ->
    "extends" _ IdentifierReference                                            {% ([,,superClass]) => {return {type: "ClassHeritage", superClass}} %}
  | null                                                                       {% () => null %}

ClassBody ->
    ClassMethod                                                                {% ([method]) => {return {type: "ClassBody", list: [method]}} %}
  | ClassProperty                                                              {% ([property]) => {return {type: "ClassBody", list: [property]}} %}
  | Constructor                                                                {% ([constructor]) => {return {type: "ClassBody", list: [constructor]}} %}
  | ClassBody _ ClassMethod                                                    {% ([list,,method]) => {return {type: "ClassBody", list: [...list.list, method]}} %}
  | ClassBody _ ClassProperty                                                  {% ([list,,property]) => {return {type: "ClassBody", list: [...list.list, property]}} %}
  | ClassBody _ Constructor                                                    {% ([list,,constructor]) => {return {type: "ClassBody", list: [...list.list, constructor]}} %}

ClassMethod ->
    Visibility Static BindingIdentifier _ "(" _ ArgumentList _ ")" 
        _ BlockStatement                                                       {% ([visibility,static,name,,,,args,,,,body]) => {return {type:"ClassMethod", name, args, body, visibility, static}} %}

Constructor ->
    Visibility "constructor" _ "(" _ ArgumentList _ ")" 
        _ BlockStatement                                                       {% ([visibility,,,,,args,,,,body]) => {return {type:"Constructor", args, body, visibility}} %}

ClassProperty ->
    Visibility Static BindingIdentifier _ Initializer sep                      {% ([visibility,static,name,,init]) => {return {type: "ClassProperty", visibility, static, name, init}} %}
  | Visibility Static BindingIdentifier sep                                    {% ([visibility,static,name]) => {return {type: "ClassProperty", visibility, static, name}} %}

Visibility ->
    %visibility __                                                             {% ([visibility]) => visibility.value %}
  | null                                                                       {% () => null %}

Static ->
    %static __                                                                 {% ([static]) => static.value %}
  | null                                                                       {% () => null %}

# IncludeStatement

IncludeStatement ->
    "include" _ "(" _ StringLiteral _ ")" sep                                  {% ([,,,,path]) => {return {type: "IncludeStatement", path}} %}

### Statement

EmptyStatement ->
    ";"                                                                        {% () => {return {type:"EmptyStatement"}} %}

BlockStatement ->
    "{" _ "}"                                                                  {% () => {return {type:"BlockStatement"}} %}
  | "{" _ StatementList _ "}"                                                  {% ([,,list]) => {return {type: "BlockStatement", list:list}}%}

VariableDeclaration ->
    "var" __ BindingIdentifier _ Initializer sep                               {% ([,,id,,value]) => {return {type: "VariableDeclaration", id, value}} %}
  | "var" __ BindingIdentifier _ sep                                           {% ([,,id]) => {return {type: "VariableDeclaration", id}} %}

# Function

FunctionDeclaration ->
    "function" __ BindingIdentifier _ "(" _ ArgumentList _ ")" 
        _ BlockStatement                                                       {% ([,,name,,,,args,,,,body]) => {return {type:"FunctionDeclaration", name, args, body}} %}

ArgumentList ->
    null                                                                       {% ([list]) => {return {type: "ArgumentList", list:[]}} %}
  | _ArgumentList                                                              {% ([list]) => {return {type: "ArgumentList", list}} %}

_ArgumentList ->
    AssignementExpression                                                      {% ([arg]) => [arg] %}
  | BindingIdentifier                                                          {% ([arg]) => [arg] %}
  | ArgumentList _ "," _ AssignementExpression                                 {% ([list,,,,arg]) => [...list, arg] %}
  | FormalArgumentList _ "," _ BindingIdentifier                               {% ([list,,,,arg]) => [...list, arg] %}

FormalArgumentList ->
    BindingIdentifier                                                          {% ([arg]) => [arg] %}
  | FormalArgumentList _ "," _ BindingIdentifier                               {% ([list,,,,arg]) => [...list, arg] %}

# For

ForStatement ->
    ForIterStatement                                                           {% id %}
  | ForInStatement                                                             {% id %}

ForIterStatement ->
    "for" _ "(" _ ";" _ ";" _ ")" _ Statement                                  {% ([,,,,,,,,,,statement]) => {return {type: "ForIterStatement", statement}} %}
  | "for" _ "(" _ VariableDeclaration _ ";" _ ")" _ Statement                  {% ([,,,,init,,,,,,statement]) => {return {type: "ForIterStatement", init, statement}} %}
  | "for" _ "(" _ VariableDeclaration _ Expression _ ";" _ ")" _ Statement     {% ([,,,,init,,cond,,,,,,statement]) => {return {type: "ForIterStatement", init, cond, statement}} %}
  | "for" _ "(" _ VariableDeclaration _ Expression _ ";" 
      _ Expression _ ")" _ Statement                                           {% ([,,,,init,,cond,,,,iter,,,,statement]) => {return {type: "ForIterStatement", init, cond, iter, statement}} %}
  | "for" _ "(" _ VariableDeclaration _ Expression _ ";" 
     _ ")" _ Statement                                                         {% ([,,,,init,,,,,iter,,,,statement]) => {return {type: "ForIterStatement", init, iter, statement}} %}
  | "for" _ "(" _ ";" _ Expression _ ";" 
      _ Expression _ ")" _ Statement                                           {% ([,,,,,,cond,,,,iter,,,,statement]) => {return {type: "ForIterStatement", cond, iter, statement}} %}
  | "for" _ "(" _ ";" _ Expression _ ";" 
      _ ")" _ Statement                                                        {% ([,,,,,,cond,,,,,,statement]) => {return {type: "ForIterStatement", cond, statement}} %}
  | "for" _ "(" _ ";" _ ";" 
      _ Expression _ ")" _ Statement                                           {% ([,,,,,,,,iter,,,,statement]) => {return {type: "ForIterStatement", iter, statement}} %}
  | "for" _ "(" _ VariableDeclaration _ ";" 
      _ Expression _ ")" _ Statement                                           {% ([,,,,init,,,,iter,,,,statement]) => {return {type: "ForIterStatement", init, iter, statement}} %}

ForInStatement ->
    "for" _ "(" _ "var" __ BindingIdentifier _ ":" 
        _ "var" __ BindingIdentifier __ "in" __ Expression _ ")" _ Statement   {% ([,,,,,,keyName,,,,,,valueName,,,,expr,,,,statement]) => {return {type: "ForInStatement", keyName, valueName, expr, statement}} %}
  | "for" _ "(" 
        _ "var" __ BindingIdentifier __ "in" __ Expression _ ")" _ Statement   {% ([,,,,,,valueName,,,,expr,,,,statement]) => {return {type: "ForInStatement", valueName, expr, statement}} %}


# If

IfStatement ->
    "if" _ "(" _ Expression _ ")" _ Statement                                  {% ([,,,,cond,,,,then]) => {return {type: "IfStatement", cond, then}} %}
  | "if" _ "(" _ Expression _ ")" _ Statement _ "else" _ Statement             {% ([,,,,cond,,,,then,,,,elseCase]) => {return {type: "IfStatement", cond, then, elseCase}} %}

# While

WhileStatement ->
    "while" _ "(" _ Expression _ ")" _ Statement                               {% ([,,,,cond,,,,loop]) => {return {type: "WhileStatement", cond, loop}} %}

# DoWhile

DoWhileStatement ->
    "do" _ Statement _ "while" _ "(" _ Expression _ ")" _ ";"                  {% ([,,loop,,,,,,cond]) => {return {type: "DoWhileStatement", cond, loop}} %}

# Break

BreakStatement ->
    "break" sep                                                                {% () => {return {type: "BreakStatement"}} %}

# Continue

ContinueStatement ->
    "continue" sep                                                             {% () => {return {type: "ContinueStatement"}} %}

# Return

ReturnStatement ->
    "return" __ Expression sep                                                 {% ([,,value]) => {return {type: "ReturnStatement", value}} %}

# Expression

ExpressionStatement ->
    Expression sep                                                             {% ([statement]) => statement %}

### Expression

AssignementExpression ->
    BindingIdentifier _ Initializer                                            {% ([id,,value]) => {return {type: "AssignementExpression", id, value}} %}

### Utils

Initializer ->
    "=" _ Expression                                                           {% ([,,value]) => value %}

# Pattern

Pattern ->
    PatternArray                                                               {% id %}
  | PatternObject                                                              {% id %}

PatternArray ->
    Pattern _ "[" _ Expression _ "]"                                           {% ([root,,,,index]) => {return {type: "PatternArray", root, index}} %}

PatternObject ->
    Pattern _ "." _ IdentifierReference                                        {% ([root,,,,id]) => {return {type: "PatternObject", root, id}} %}

#### Literals

NumberLiteral ->
    %Integer                                                                   {% ([id]) => id.value %}
  | %Decimal                                                                   {% ([id]) => id.value %}
  | %Hexadecimal                                                               {% ([id]) => id.value %}
  | %Binary                                                                    {% ([id]) => id.value %}

StringLiteral ->
    %String                                                                    {% ([id]) => {return {type: "StringLiteral", value:id.value}} %}

BooleanLiteral ->
    %boolean                                                                   {% ([id]) => id.value %}

ArrayLiteral ->
    "[" _ "]"                                                                  {% () => {return {type: "ArrayLiteral", data:[]}} %}
  | "[" _ ExpressionList _ "]"                                                 {% ([,,data,,]) => {return {type: "ArrayLiteral", data}} %}

MapLiteral ->
    "[" _ ":" _ "]"                                                            {% () => {return {type: "MapLiteral", data:[]}} %}
  | "[" _ PropertyList _ "]"                                                   {% ([,,data,,]) => {return {type: "MapLiteral", data}} %}

ObjectLiteral ->
    "{" _ "}"                                                                  {% () => {return {type: "ObjectLiteral", data: []}} %}
  | "{" _ PropertyList _ "}"                                                   {% ([,,data,,]) => {return {type: "ObjectLiteral", data}} %}

PropertyList ->
    Property                                                                   {% ([property]) => {return {type: "PropertyList", list: [property]}} %}
  | PropertyList _ "," _ Property                                              {% ([list,,,,property]) => {return {type: "PropertyList", list: [...list.list, property]}} %}

Property ->
    PropertyName _ ":" _ Expression                                            {% ([name,,,,value]) => {return {type: "Property", name, value}} %}

PropertyName ->
    %ID                                                                        {% ([name]) => {return {type: "PropertyName", name:name.value}}%}

IdentifierReference ->
    %ID                                                                        {% ([name]) => {return {type: "IdentifierReference", name:name.value}}%}

BindingIdentifier ->
    %ID                                                                        {% ([name]) => {return {type: "BindingIdentifier", name:name.value}}%}

### Whitepsace
_ -> %WS:*                                          {% () => null %}
__ -> %WS:+                                         {% () => null %}
sep ->
    _                                               {% () => ";" %}
  | _ ";" _                                         {% () => ";" %}