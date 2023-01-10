@{%
    const { lexer } = require("../lexer/lexer.js")

    const { ast, opt } = require("./parserTools.js")
%}

@lexer lexer

####### Macros

Seq1[ELEMENT, SEP] -> $ELEMENT ($SEP $ELEMENT):*                               {% ast("Sequence1") %}
Seq[ELEMENT, SEP] -> ($ELEMENT ($SEP $ELEMENT):*):?                            {% ast("Sequence") %}

####### Main

Script -> ScriptBody:? %EOF                                                    {% ast("Script") %}
ScriptBody -> GlobalStatement:+                                                {% ast("ScriptBody") %}

GlobalStatement ->
    GlobalDeclaration Sep                                                      {% ast("GlobalStatement") %}
  | ImportDeclaration Sep                                                      {% ast("GlobalStatement") %}
  | ClassDefinition Sep                                                        {% ast("GlobalStatement") %}
  | Statement                                                                  {% ast("GlobalStatement") %}

Statement ->
  ( VarDeclaration
  | IfStatement
  | ForStatement
  | WhileStatement
  | DoWhileStatement
  | FunctionDeclaration
  | BreakStatement
  | ContinueStatement
  | BlockStatement
  ) Sep                                                                        {% ast("Statement") %}
  | ExpressionStatement ";"                                                    {% ast("Statement") %}
  | ";"                                                                        {% id %}

######## Global Statement

GlobalDeclaration ->
    "global" BindingIdentifier Initializer:?                                   {% ast("GlobalDeclaration") %}

ImportDeclaration ->
    "include" "(" StringLiteral ")"                                            {% ast("ImportDeclaration") %}

ClassDefinition ->
    "class" BindingIdentifier ClassExtension:? "{" ClassBody "}"               {% ast("ClassDefinition") %}

ClassExtension ->
    "extends" IdentifierName                                                   {% ast("ClassExtension", {sep: " "}) %}

ClassBody ->
   ( ConstructorDeclaration 
   | MethodDeclaration 
   | ClassPropertyDelcaration):*                                               {% ast("ClassBody") %}

ConstructorDeclaration ->
    Protection:? "constructor" Arguments FunctionBody                          {% ast("ConstructorDeclaration") %}

MethodDeclaration ->
    Protection:? "static":? BindingIdentifier Arguments FunctionBody           {% ast("MethodDeclaration") %}

ClassPropertyDelcaration ->
    Protection:? "static":? BindingIdentifier Initializer:? Sep                {% ast("ClassPropertyDelcaration") %}

Protection ->
    "public"                                                                   {% id %}
  | "private"                                                                  {% id %}
  | "protected"                                                                {% id %}

######## Statement

VarDeclaration ->
    "var" BindingIdentifier Initializer:?                                      {% ast("VarDeclaration") %}

IfStatement ->
    "if" "(" Expression ")" Statement ("else" Statement):?                     {% ast("IfStatement") %}

ForStatement ->
    "for" "(" (ForInHeader | ForIterHeader) ")" Statement                      {% ast("ForStatement") %}

ForInHeader ->
    ("var" BindingIdentifier ":"):? "var" BindingIdentifier "in" Expression    {% ast("ForInHeader") %}

ForIterHeader ->
    ("var" BindingIdentifier Initializer:? | Expression):? ";" Expression:? 
        ";" Expression:?                                                       {% ast("ForIterHeader") %}

WhileStatement ->
    "while" "(" Expression ")" Statement                                       {% ast("WhileStatement") %}

DoWhileStatement ->
    "do" Statement "while" "(" Expression ")"                                  {% ast("DoWhileStatement") %}

FunctionDeclaration ->
    "function" BindingIdentifier Arguments FunctionBody                        {% ast("FunctionDeclaration") %}

FunctionBody ->
    "{" Statement:* ReturnStatement:? "}"                                      {% ast("FunctionBody") %}

BreakStatement ->
    "break"                                                                    {% ast("BreakStatement") %}

ContinueStatement ->
    "continue"                                                                 {% ast("ContinueStatement") %}

ReturnStatement ->
    "return" Expression Sep                                                    {% ast("ReturnStatement") %}
  | "return" ";"                                                               {% ast("ReturnStatement") %}

BlockStatement ->
    "{" Statement:* ReturnStatement:? "}"                                      {% ast("BlockStatement") %}

EmptyStatement ->
    ";"                                                                        {% id %}

######## Expression

ExpressionStatement ->
    Expression                                                                 {% id %}

Expression ->
    FunctionExpression                                                         {% id %}
  | AssignmentExpression                                                       {% id %}

FunctionExpression ->
    BindingIdentifier ExecutionArguments                                       {% ast("FunctionExpression") %}

ExecutionArguments ->
    "(" Seq[Expression, ","] ")"                                               {% ast("ExecutionArguments") %}

AssignmentExpression ->
    ConditionalExpression                                                      {% id %}
  | ArrowFunction                                                              {% id %}
  | LeftHandSideExpression "=" AssignmentExpression                            {% ast("AssignmentExpression", {sep: " "}) %}
  | LeftHandSideExpression %BinAssign AssignmentExpression                     {% ast("AssignmentExpression", {sep: " "}) %}

ConditionalExpression ->
    ShortCircuitExpression                                                     {% id %}
  | ShortCircuitExpression "?" AssignmentExpression ":" AssignmentExpression   {% ast("ConditionalExpression", {sep: " "}) %}

ShortCircuitExpression ->
    LogicalORExpression                                                        {% id %}
  | CoalesceExpression                                                         {% id %}

CoalesceExpression ->
    BitwiseORExpression                                                        {% id %}
  | BitwiseORExpression "??" BitwiseORExpression                               {% ast("CoalseceExpression", {sep: " "}) %}

LogicalORExpression ->
    LogicalANDExpression                                                       {% id %}
  | LogicalORExpression "||" LogicalANDExpression                              {% ast("LogicalOrExpression", {sep: " "}) %}

LogicalANDExpression ->
    BitwiseORExpression                                                        {% id %}
  | LogicalANDExpression "&&" BitwiseORExpression                              {% ast("LogicalANDExpression", {sep: " "}) %}

BitwiseORExpression ->
    BitwiseXORExpression                                                       {% id %}
  | BitwiseORExpression "|" BitwiseXORExpression                               {% ast("BitwiseORExpression", {sep: " "}) %}

BitwiseXORExpression ->
    BitwiseANDExpression                                                       {% id %}
  | BitwiseXORExpression "^" BitwiseORExpression                               {% ast("BitwiseXORExpression", {sep: " "}) %}

BitwiseANDExpression ->
    EqualityExpression                                                         {% id %}
  | BitwiseANDExpression "&" BitwiseANDExpression                              {% ast("BitwiseANDExpression", {sep: " "}) %}

EqualityExpression ->
    RelationalExpression                                                       {% id %}
  | EqualityExpression "==" RelationalExpression                               {% ast("EqualityExpression", {sep: " "}) %}
  | EqualityExpression "!=" RelationalExpression                               {% ast("EqualityExpression", {sep: " "}) %}

RelationalExpression ->
    ShiftExpression                                                            {% id %}
  | RelationalExpression "<" ShiftExpression                                   {% ast("RelationalExpression", {sep: " "}) %}
  | RelationalExpression ">" ShiftExpression                                   {% ast("RelationalExpression", {sep: " "}) %}
  | RelationalExpression "<=" ShiftExpression                                  {% ast("RelationalExpression", {sep: " "}) %}
  | RelationalExpression ">=" ShiftExpression                                  {% ast("RelationalExpression", {sep: " "}) %}
  | RelationalExpression "instanceof" ShiftExpression                          {% ast("RelationalExpression", {sep: " "}) %}
  | RelationalExpression "in" ShiftExpression                                  {% ast("RelationalExpression", {sep: " "}) %}

ShiftExpression ->
    AdditiveExpression                                                         {% id %}
  | ShiftExpression "<<" AdditiveExpression                                    {% ast("ShiftExpression", {sep: " "}) %}
  | ShiftExpression ">>" AdditiveExpression                                    {% ast("ShiftExpression", {sep: " "}) %}
  | ShiftExpression ">>>" AdditiveExpression                                   {% ast("ShiftExpression", {sep: " "}) %}

AdditiveExpression ->
    MultiplicativeExpression                                                   {% id %}
  | AdditiveExpression "+" MultiplicativeExpression                            {% ast("AdditiveExpression", {sep: " "}) %}
  | AdditiveExpression "-" MultiplicativeExpression                            {% ast("AdditiveExpression", {sep: " "}) %}

MultiplicativeExpression ->
    ExponentiationExpression                                                   {% id %}
  | MultiplicativeExpression "*" ExponentiationExpression                      {% ast("MultiplicativeExpression", {sep: " "}) %}
  | MultiplicativeExpression "/" ExponentiationExpression                      {% ast("MultiplicativeExpression", {sep: " "}) %}
  | MultiplicativeExpression "\\" ExponentiationExpression                     {% ast("MultiplicativeExpression", {sep: " "}) %}
  | MultiplicativeExpression "%" ExponentiationExpression                      {% ast("MultiplicativeExpression", {sep: " "}) %}

ExponentiationExpression ->
    UnaryExpression                                                            {% id %}
  | UpdateExpression "**" ExponentiationExpression                             {% ast("ExponentiationExpression", {sep: " "}) %}

UnaryExpression ->
    UpdateExpression                                                           {% id %}
  | "typeof" UnaryExpression                                                   {% ast("UnaryExpression", {sep: " "}) %}
  | "+" UnaryExpression                                                        {% ast("UnaryExpression") %}
  | "-" UnaryExpression                                                        {% ast("UnaryExpression") %}
  | "~" UnaryExpression                                                        {% ast("UnaryExpression") %}
  | "!" UnaryExpression                                                        {% ast("UnaryExpression") %}

UpdateExpression ->
    LeftHandSideExpression                                                     {% id %}
  | LeftHandSideExpression "++"                                                {% ast("UpdateExpression") %}
  | LeftHandSideExpression "--"                                                {% ast("UpdateExpression") %}
  | "++" UnaryExpression                                                       {% ast("UpdateExpression") %}
  | "--" UnaryExpression                                                       {% ast("UpdateExpression") %}

LeftHandSideExpression ->
    NewExpression                                                              {% id %}
  | CallExpression                                                             {% id %}
  | OptionalExpression                                                         {% id %}

OptionalExpression ->
    MemberExpression OptionalChain                                             {% ast("OptionalExpression") %}
  | CallExpression OptionalChain                                               {% ast("OptionalExpression") %}
  | OptionalExpression OptionalChain                                           {% ast("OptionalExpression") %}

OptionalChain ->
    "?." Arguments                                                             {% ast("OptionalChain") %}
  | "?." "[" Expression "]"                                                    {% ast("OptionalChain") %}
  | "?." IdentifierName                                                        {% ast("OptionalChain") %}
  | OptionalChain Arguments                                                    {% ast("OptionalChain") %}
  | OptionalChain "[" Expression "]"                                           {% ast("OptionalChain") %}
  | OptionalChain "." IdentifierName                                           {% ast("OptionalChain") %}

Arguments ->
    "(" Seq[IdentifierReference, ","] ")"                                      {% ast("Arguments") %}

NewExpression ->
    MemberExpression                                                           {% id %}
  | "new" MemberExpression                                                     {% ast("NewExpression", {sep: " "}) %}

CallExpression ->
   CallExpression                                                              {% ast("CallExpression") %}
  | CallExpression "[" Expression "]"                                          {% ast("CallExpression") %}
  | CallExpression "." IdentifierName                                          {% ast("CallExpression") %}

MemberExpression ->
    PrimaryExpression                                                          {% id %}
  | SuperProperty                                                              {% id %}
  | MemberExpression "[" Expression "]"                                        {% ast("MemberExpression") %}
  | MemberExpression "." IdentifierName                                        {% ast("MemberExpression") %}
  | "new" MemberExpression Arguments                                           {% ast("MemberExpression") %}

SuperProperty ->
    "super" "[" Expression "]"                                                 {% ast("SuperProperty") %}
  | "super" "." IdentifierName                                                 {% ast("SuperProperty") %}

CoverCallExpressionAndArrowHead ->
    "(" Seq[Expression, ","] ")"                                               {% ast("CoverCallExpressionAndArrowHead") %}

Initializer ->
    "=" AssignmentExpression                                                   {% ast("Initializer", {sep: " "}) %}

ArrowFunction ->
    ArrowParameters "=>" ConciseBody                                           {% ast("ArrowFunction", {sep: " "}) %}

ArrowParameters ->
    BindingIdentifier                                                          {% id %}
  | CoverCallExpressionAndArrowHead                                            {% id %}

ConciseBody ->
    "{" FunctionBody "}"                                                       {% ast("ConciseBody") %}
  | AssignmentExpression                                                       {% id /* TODO clean */ %}

FunctionExpression ->
    "function" Arguments "{" FunctionBody "}"                                  {% ast("FunctionExpression") %}

PrimaryExpression ->
    "this"                                                                     {% id %}
  | IdentifierReference                                                        {% id %}
  | Literal                                                                    {% id %}
  | ObjectLiteral                                                              {% id %}
  | ArrayLiteral                                                               {% id %}
  | MapLiteral                                                                 {% id %}
  | FunctionExpression                                                         {% id %}
  | ParenthesizedExpression                                                    {% id %}

ParenthesizedExpression ->
  "(" Expression ")"                                                           {% ast("ParenthesizedExpression") %}

###### Literal

Literal ->
    NullLiteral                                                                {% id %}
  | BooleanLiteral                                                             {% id %}
  | NumericLiteral                                                             {% id %}
  | StringLiteral

NullLiteral -> "null"                                                          {% id %}

BooleanLiteral ->
    "true"                                                                     {% id %}
  | "false"                                                                    {% id %}

NumericLiteral ->
    %Integer                                                                   {% id %}
  | %Decimal                                                                   {% id %}
  | %Hexadecimal                                                               {% id %}
  | %Binary                                                                    {% id %}

StringLiteral ->
    %String                                                                    {% id %}

ArrayLiteral ->
    "[" Seq[AssignmentExpression, ","] "]"                                     {% ast("ArrayLiteral") %}

MapLiteral ->
    "[" ":" "]"                                                                {% ast("MapLiteral") %}
  | "[" Seq1[PropertyDefinition, ","] "]"                                      {% ast("MapLiteral") %}

ObjectLiteral ->
    "{" Seq[PropertyDefinition, ","] "}"                                       {% ast("ObjectLiteral") %}

PropertyDefinition ->
#   IdentifierReference                                                        {% id %}
    PropertyName ":" AssignmentExpression                                      {% ast("PropertyDefinition") %}
# | MethodDefinition

BindingIdentifier -> %ID                                                       {% id %}
IdentifierName -> %ID                                                          {% id %}
IdentifierReference -> %ID                                                     {% id %}
PropertyName -> %ID                                                            {% id %}

Sep ->
    ";":?                                                                      {% ast("Sep") %}