@{%
    const { lexer } = require("../lexer/lexer.js")

    const { ast, opt } = require("./parserTools.js")
%}

@lexer lexer

####### Macros

Seq1[ELEMENT, SEP] -> $ELEMENT ($SEP $ELEMENT):*                               {% ast("Sequence") %}
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
  | ReturnStatement
  | BlockStatement
  | ExpressionStatement
  ) Sep                                                                        {% ast("Statement") %}
# | ";"                                                                        {% ast("EmptyStatement") %}

######## Global Statement

GlobalDeclaration ->
    "global" BindingIdentifier Initializer:?                                   {% ast("GlobalDeclaration") %}

ImportDeclaration ->
    "import" "(" StringLiteral ")"                                             {% ast("ImportDeclaration") %}

ClassDefinition ->
    "class" BindingIdentifier ClassExtension:? "{" ClassBody "}"               {% ast("ClassDefinition") %}

ClassExtension ->
    "extends" IdentifierName                                                   {% ast("ClassExtension") %}

ClassBody ->
   (ConstructorDeclaration | MethodDeclaration 
      | ClassPropertyDelcaration | ";"):*                                      {% ast("ClassBody") %}

ConstructorDeclaration ->
    Protection:? "constructor" Arguments FunctionBody                          {% ast("ConstructorDeclaration") %}

MethodDeclaration ->
    Protection:? "static":? BindingIdentifier Arguments FunctionBody           {% ast("MethodDeclaration") %}

ClassPropertyDelcaration ->
    Protection:? "static":? BindingIdentifier Initializer:?                    {% ast("ClassPropertyDeclaration") %}

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
    "{" Statement:* "}"                                                        {% ast("FunctionBody") %}

BreakStatement ->
    "break"                                                                    {% ast("BreakStatement") %}

ContinueStatement ->
    "continue"                                                                 {% ast("ContinueStatement") %}

ReturnStatement ->
    "return" Expression:?                                                      {% ast("ReturnStatement") %}

BlockStatement ->
    "{" Statement:* "}"                                                        {% ast("BlockStatement") %}

EmptyStatement ->
    ";"                                                                        {% ast("EmptyStatement") %}

######## Expression

ExpressionStatement ->
    Expression                                                                 {% ast("ExpressionStatement") %}

Expression ->
    AssignmentExpression                                                       {% id %}

AssignmentExpression ->
    ConditionalExpression                                                      {% id %}
  | ArrowFunction                                                              {% id %}
  | LeftHandSideExpression "=" AssignmentExpression                            {% ast("AssignmentExpression") %}
  | LeftHandSideExpression %BinAssign AssignmentExpression                     {% ast("AssignmentExpression") %}

ConditionalExpression ->
    ShortCircuitExpression                                                     {% id %}
  | ShortCircuitExpression "?" AssignmentExpression ":" AssignmentExpression   {% ast("ConditionalExpression") %}

ShortCircuitExpression ->
    LogicalORExpression                                                        {% id %}
  | CoalesceExpression                                                         {% id %}

CoalesceExpression ->
    BitwiseORExpression                                                        {% id %}
  | BitwiseORExpression "??" BitwiseORExpression                               {% ast("CoalseceExpression") %}

LogicalORExpression ->
    LogicalANDExpression                                                       {% id %}
  | LogicalORExpression "||" LogicalANDExpression                              {% ast("LogicalOrExpression") %}

LogicalANDExpression ->
    BitwiseORExpression                                                        {% id %}
  | LogicalANDExpression "&&" BitwiseORExpression                              {% ast("LogicalANDExpression") %}

BitwiseORExpression ->
    BitwiseXORExpression                                                       {% id %}
  | BitwiseORExpression "|" BitwiseXORExpression                               {% ast("BitwiseORExpression") %}

BitwiseXORExpression ->
    BitwiseANDExpression                                                       {% id %}
  | BitwiseXORExpression "^" BitwiseORExpression                               {% ast("BitwiseXORExpression") %}

BitwiseANDExpression ->
    EqualityExpression                                                         {% id %}
  | BitwiseANDExpression "&" BitwiseANDExpression                              {% ast("BitwiseANDExpression") %}

EqualityExpression ->
    RelationalExpression                                                       {% id %}
  | EqualityExpression "==" RelationalExpression                               {% ast("EqualityExpression") %}
  | EqualityExpression "!=" RelationalExpression                               {% ast("EqualityExpression") %}
  | EqualityExpression "===" RelationalExpression                              {% ast("EqualityExpression") /* TODO ADD ERROR HERE */ %}
  | EqualityExpression "!==" RelationalExpression                              {% ast("EqualityExpression") /* TODO ADD ERROR HERE */ %}

RelationalExpression ->
    ShiftExpression                                                            {% id %}
  | RelationalExpression "<" ShiftExpression                                   {% ast("RelationalExpression") %}
  | RelationalExpression ">" ShiftExpression                                   {% ast("RelationalExpression") %}
  | RelationalExpression "<=" ShiftExpression                                  {% ast("RelationalExpression") %}
  | RelationalExpression ">=" ShiftExpression                                  {% ast("RelationalExpression") %}
  | RelationalExpression "instanceof" ShiftExpression                          {% ast("RelationalExpression") %}
  | RelationalExpression "in" ShiftExpression                                  {% ast("RelationalExpression") %}

ShiftExpression ->
    AdditiveExpression                                                         {% id %}
  | ShiftExpression "<<" AdditiveExpression                                    {% ast("ShiftExpression") %}
  | ShiftExpression ">>" AdditiveExpression                                    {% ast("ShiftExpression") %}
  | ShiftExpression ">>>" AdditiveExpression                                   {% ast("ShiftExpression") %}

AdditiveExpression ->
    MultiplicativeExpression                                                   {% id %}
  | AdditiveExpression "+" MultiplicativeExpression                            {% ast("AdditiveExpression") %}
  | AdditiveExpression "-" MultiplicativeExpression                            {% ast("AdditiveExpression") %}

MultiplicativeExpression ->
    ExponentiationExpression                                                   {% id %}
  | MultiplicativeExpression "*" ExponentiationExpression                      {% ast("MultiplicativeExpression") %}
  | MultiplicativeExpression "/" ExponentiationExpression                      {% ast("MultiplicativeExpression") %}
  | MultiplicativeExpression "\\" ExponentiationExpression                     {% ast("MultiplicativeExpression") %}
  | MultiplicativeExpression "%" ExponentiationExpression                      {% ast("MultiplicativeExpression") %}

ExponentiationExpression ->
    UnaryExpression                                                            {% id %}
  | UpdateExpression "**" ExponentiationExpression                             {% ast("ExponentiationExpression") %}

UnaryExpression ->
    UpdateExpression                                                           {% id %}
  | "typeof" UnaryExpression                                                   {% ast("UnaryExpression") %}
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
  | "new" NewExpression                                                        {% ast("NewExpression") %}

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
    "=" AssignmentExpression                                                   {% ast("Initializer") %}

ArrowFunction ->
    ArrowParameters "=>" ConciseBody                                           {% ast("ArrowFunction") %}

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