@{%

const { lexer } = require("./lexer.js")

%}

@lexer lexer

Script ->
    null                                            {% () => null %}
  | ScriptBody                                      {% ([body]) => {return {type: "Script", body}} %}

ScriptBody -> 
    ReturnableStatementList _                       {% ([list]) => list %}

StatementList ->
    StatementListItem                               {% ([item]) => {return {type: "StatementList", items: [item]}} %}
  | StatementList _ StatementListItem               {% ([list,,item]) => {return {type: "StatementList", items: [...list.items, item]}} %}

ReturnableStatementList ->
    StatementList                                   {% id %}
  | StatementList _ ReturnStatement                 {% ([list,,item]) => {return {type: "StatementList", items: [...list.items, item]}} %}
  | ReturnableStatement                             {% id %}

StatementListItem ->
    Statement                                       {% id %}
  | Declaration                                     {% id %}

#### Statement

Statement ->
    BlockStatement                                  {% id %}
  | EmptyStatement                                  {% id %}
  | IfStatement                                     {% id %}

ReturnableStatement ->
    Statement                                       {% id %}
  | ReturnStatement                                 {% id %}

BlockStatement ->
    "{" _ ReturnableStatementList _ "}"                       {% ([,,statements]) => {return {type:"BlockStatement", statements}} %}
  | "{" _ "}"                                       {% () => {return {type:"BlockStatement"}} %}

EmptyStatement ->
    ";"                                             {% () => {return {type:"EmptyStatement"}} %}

IfStatement ->
    "if" _ "(" _ Expression _ ")" 
        _ ReturnableStatement 
        _ "else" _ ReturnableStatement              {% ([,,,,cond,,,,ifTrue,,,,ifFalse]) => {return {type: "IfStatement", cond, ifTrue, ifFalse}}%}
  | "if" _ "(" _ Expression _ ")" 
        _ ReturnableStatement                       {% ([,,,,cond,,,,ifTrue]) => {return {type: "IfStatement", cond, ifTrue}}%}

ReturnStatement ->
    "return" __ Expression sep                      {% ([,,expr]) => {return {type: "ReturnStatement", expr}} %}

#### Expression

Expression ->
    AssignementExpression                           {% id %}

AssignementExpression ->
    NumberLitteral                                  {% id %}
  | IdentifierReference                             {% id %}

#### Declarations

GlobalScopeDeclaration ->
    Declaration                                     {% id %}
  | GlobalDeclaration                               {% id %}
# | ClassDeclaration

Declaration ->
    VariableDeclaration                             {% id %}

GlobalDeclaration ->
    "global" _ VariableDefinition sep               {% ([,,val]) => {return {type: "GlobalDeclaration", val}} %}

VariableDeclaration ->
    "var" _ VariableDefinition sep                  {% ([,,val]) => {return {type: "VariableDeclaration", val}} %}

VariableDefinition ->
    BindingIdentifier _ Initializer                 {% ([id,,val]) => {return {type: "VariableDefinition", id, val}} %}
  | BindingIdentifier                               {% ([id]) => {return {type: "VariableDefinition", id}} %}

Initializer ->
    "=" _ AssignementExpression                     {% ([,,val]) => {return val} %}

### Identifiers

BindingIdentifier ->
    %ID                                             {% ([id]) => {return {type: "BindingIdentifier", id:id.value}} %}

IdentifierReference ->
    %ID                                             {% ([id]) => {return {type: "IdentifierReference", id:id.value}} %}

### Numbers

NumberLitteral ->
    %Integer                                        {% ([num]) => num.value %}
  | %Decimal                                        {% ([num]) => num.value %}
  | %Hexadecimal                                    {% ([num]) => num.value %}
  | %Binary                                         {% ([num]) => num.value %}

### Whitespaces
_ -> %WS:*                                          {% () => null %}
__ -> %WS:+                                         {% () => null %}
sep ->
    __                                              {% () => ";" %}
  | _ ";" _                                         {% () => ";" %}