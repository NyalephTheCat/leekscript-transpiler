@{%

const { lexer } = require("./lexer.js")

%}

@lexer lexer

Script -> ScriptBody:?                                     {% id %}
ScriptBody -> StatementList                                {% id %}
StatementList ->
    StatementListItem                                      {% ([item]) => [item] %}
  | StatementList StatementListItem                        {% ([list, item]) => [...list, item] %}
StatementListItem ->
    Statement                                              {% id %}
  | Declaration                                            {% id %}

Statement ->
    BlockStatement
  | GlobalStatement
  | VariableStatement
  | EmptyStatement
  | ExpressionStatement
  | IfStatement
  | BreakableStatement
  | ContinueStatement
  | BreakStatement
  | ReturnStatement
# | WithStatement
# | LabelledStatement
# | ThrowStatement
# | DebuggerStatement

Declaration ->
    HoistableDeclaration
  | ClassDeclaration
  | LexicalDeclaration

HoistableDeclaration ->
    FunctionDeclaration
# | GeneratorDeclaration
# | AsyncFunctionDeclaration
# | AsyncGeneratorDeclaration

BreakableStatement ->
    IterationStatement
# | SwitchStatement

IterationStatement ->
    DoWhileStatement
  | WhileStatement
  | ForStatement
  | ForInStatement
# | ForOfStatement

BlockStatement -> Block
Block -> 
    "{" _ "}"
  | "{" _ StatementList _ "}"

EmptyStatement -> 
    ";"

GlobalStatement ->
    "global" _ VariableDeclarationList sep

VariableStatement ->
    "var" _ VariableDeclarationList sep

VariableDeclarationList ->
    VariableDeclaration
# | VariableDeclarationList _ "," _ VariableDeclaration

VariableDeclaration ->
    BindingIdentifier
  | BindingIdentifier _ Initializer
# | BindingPattern _ Initializer

Initializer ->
    "=" _ AssignementExpression

AssignementExpression ->
    ConditionalExpression
# | YieldExpression
  | ArrowFunction
# | AsyncArrowFunction
  | LeftHandSideExpression _ "=" _ AssignementExpression
  | LeftHandSideExpression _ %assignementOperator _ AssignementExpression
  | LeftHandSideExpression _ %binAssignementOperator _ AssignementExpression

ConditionalExpression ->
    ShortCircuitExpression
  | ShortCircuitExpression _ "?" _ AssignementExpression _ ":" _ AssignementExpression

ShortCircuitExpression ->
    LogicalORExpression
# | CoalesceExpression

LogicalORExpression ->
    LogicalANDExpression
  | LogicalORExpression _ "||" _ LogicalANDExpression

LogicalANDExpression ->
    BitwiseORExpression
  | LogicalANDExpression _ "&&" _ BitwiseORExpression

BitwiseORExpression ->
    BitwiseXORExpression
  | BitwiseORExpression _ "|" _ BitwiseXORExpression

BitwiseXORExpression ->
    BitwiseANDExpression
  | BitwiseXORExpression _ "^" _ BitwiseXORExpression

BitwiseANDExpression -> 
    EqualityExpression
  | BitwiseANDExpression _ "&" _ EqualityExpression

EqualityExpression ->
    RelationalExpression
  | EqualityExpression _ "==" _ RelationalExpression
  | EqualityExpression _ "!=" _ RelationalExpression

RelationalExpression ->
    ShiftExpression
  | RelationalExpression _ "<" _ ShiftExpression
  | RelationalExpression _ ">" _ ShiftExpression
  | RelationalExpression _ "<=" _ ShiftExpression
  | RelationalExpression _ ">=" _ ShiftExpression
  | RelationalExpression _ "instanceof" _ ShiftExpression
# | RelationalExpression _ "in" _ ShiftExpression

ShiftExpression ->
    AdditiveExpression
  | ShiftExpression _ "<<" _ AdditiveExpression
  | ShiftExpression _ ">>" _ AdditiveExpression
  | ShiftExpression _ ">>>" _ AdditiveExpression

AdditiveExpression ->
    MultiplicativeExrpession
  | AdditiveExpression _ "+" _ MultiplicativeExrpession
  | AdditiveExpression _ "-" _ MultiplicativeExrpession

MultiplicativeExrpession ->
    ExponentExpression
  | MultiplicativeExrpession _ "*" _ MultiplicativeExrpession
  | MultiplicativeExrpession _ "/" _ MultiplicativeExrpession
  | MultiplicativeExrpession _ "\\" _ MultiplicativeExrpession
  | MultiplicativeExrpession _ "%" _ MultiplicativeExrpession

ExponentExpression ->
    UnaryExpression
  | UnaryExpression _ "**" _ ExponentExpression

UnaryExpression ->
    UpdateExpression
# | "delete" _ UnaryExpression
# | "void" _ UnaryExpression
# | "typeof" _ UnaryExpression
  | "+" _ UnaryExpression
  | "-" _ UnaryExpression
  | "~" _ UnaryExpression
  | "!" _ UnaryExpression
# | AwaitExpression

UpdateExpression ->
    LeftHandSideExpression
  | LeftHandSideExpression "++"
  | LeftHandSideExpression "--"
  | "++" UnaryExpression
  | "--" UnaryExpression

LeftHandSideExpression ->
    NewExpression
  | CallExpression
# | OptionalExpression

NewExpression ->
    MemberExpression
  | "new" NewExpression

CallExpression ->
    CoverCallExpressionAndAsyncArrowHead
  | SuperCall
  | ImportCall
  | CallExpression _ Arguments
  | CallExpression _ "[" _ Expression "]"
  | CallExpression _ "." _ IdentifierName
# | CallExpression _ TemplateLiteral
# | CallExpression _ "." _ PrivateIdentifier

CoverCallExpressionAndAsyncArrowHead ->
    MemberExpression _ Arguments

SuperCall ->
    "super" _ Arguments

ImportCall ->
    "import" _ "(" _ AssignementExpression ")"

Arguments ->
    "(" _ ")"
  | "(" _ ArgumentList _ ")"
  | "(" _ ArgumentList _ ")"
  | "(" _ ArgumentList _ "," _ ")"

ArgumentList ->
    AssignementExpression
# | "..." _ AssignementExpression
  | ArgumentList _ "," _ AssignementExpression
# | ArgumentList _ "," _ "..." _ AssignementExpression

OptionalExpression ->
    MemberExpression _ OptionalChain
  | CallExpression _ OptionalChain
  | OptionalExpression _ OptionalChain

OptionalChain ->
    "?." _ Arguments
  | "?." _ "[" _ Expression "]"
  | "?." _ IdentifierName
# | "?." _ TemplateLiteral
# | "?." _ PrivateIdentifier
  | OptionalChain _ Arguments
  | OptionalChain _ "[" _ Expression _ "]"
  | OptionalChain _ "." _ IdentifierName
# | OptionalChain _ TemplateLiteral
# | OptionalChain _ "." _ PrivateIdentifier
    
MemberExpression ->
    PrimaryExpression
  | MemberExpression _ "[" _ Expression _ "]"
  | MemberExpression _ "." _ IdentifierName
# | MemberExpression _ TemplateLiteral
  | SuperProperty
# | MetaProperty
  | "new" MemberExpression Arguments
# | MemberExpression "." PrivateIdentifier

PrimaryExpression ->
    "this"
  | IdentifierReference
  | Literal
  | ArrayLiteral
  | ObjectLiteral
  | FunctionExpression
# | GeneratorExpression
# | AsyncFunctionExpression
# | AsyncGeneratorExpression 
# | RegularExpressionLiteral
# | TemplateLiteral
  | CoverParenthesizedExpressionAndArrowParameterList

CoverParenthesizedExpressionAndArrowParameterList ->
    "(" _ Expression _ ")"
  | "(" _ Expression _ "," _ ")"
  | "(" _ ")"
# | "(" _ "..." _ BindingIdentifier _ ")"
# | "(" _ "..." _ BindingPattern _ ")"
# | "(" _ Expression _ "," _ "..." _ BindingIdentifier _ ")"
# | "(" _ Expression _ "," _ "..." _ BindingPattern _ ")"

SuperProperty ->
    "super" _ "[" Expression "]"
  | "super" _ "." _ IdentifierName

ExpressionStatement ->
    Expression sep

Expression ->
    AssignementExpression
  | Expression _ "," _ AssignementExpression

IfStatement ->
    "if" _ "(" _ Expression _ ")" _ Statement _ "else" _ Statement
  | "id" _ "(" _ Expression _ ")" _ Statement

DoWhileStatement ->
    "do" _ Statement _ "while" _ "(" Expression _ ")" _ ";"

WhileStatement ->
    "while" _ "(" _ Expression _ ")" Statement

ForStatement ->
    "for" _ "(" (_ "var" _ VariableDeclarationList):? _ ";" (_ Expression):? _ ";" (_ Expression):? _ ")" _ Statement

ForInStatement ->
    "for" _ "(" _ "var" _ VariableDeclarationList _ ":" (_ "var" _ VariableDeclarationList):? _ "in" _ Expression _ ")" _ Statement

ContinueStatement ->
    "continue" sep

BreakStatement ->
    "break" sep

ReturnStatement ->
    "return" _ ";"
  | "return" _ Expression sep

FunctionDeclaration ->
    "function" _ BindingIdentifier _ "(" _ FormalParameters _ ")" _ "{" FunctionBody "}"
    "function" _ "(" _ FormalParameters _ ")" _ "{" FunctionBody "}"

FunctionBody ->
    FunctionStatementList

FunctionStatementList ->
    StatementList:?

FormalParameters ->
    null
# | FunctionRestParameter
  | FormalParametersList
  | FormalParametersList _ ","
# | FormalParametersList _ "," _ FunctionRestParameter

FormalParametersList ->
    FormalParameter
  | FormalParametersList _ "," _ FormalParameter

#FunctionRestParameter ->
#  BindingRestElement

FormalParameter ->
    BindingElement

LexicalDeclaration ->
    VarLetOrConst _ BindingList _ ";"

VarLetOrConst ->
    "var"
  | "let"
  | "const"

ArrowFunction ->
    ArrowParameters _ "=>" ConciseBody

ArrowParameters ->
    BindingIdentifier
  | CoverParenthesizedExpressionAndArrowParameterList

ConciseBody ->
    ExpressionBody
  | "{" _ FunctionBody _ "}"

ExpressionBody ->
    AssignementExpression

FunctionExpression ->
    "function" _ BindingIdentifier _ "(" _ FormalParameter _ ")" _ "{" _ FunctionBody _ "}"
  | "function" _ "(" _ FormalParameter _ ")" _ "{" _ FunctionBody _ "}"

BindingPattern ->
    ObjectBindingPattern
  | ArrayBindingPattern

ObjectBindingPattern ->
    "{" _ "}"
  | "{" _ BindingPropertyList _ "}"

ArrayBindingPattern ->
    "[" _ "]"#
  | "[" _ BindingElementList _ "]"

BindingElementList ->
    BindingElement
  | BindingElementList _ "," _ BindingElement

BindingPropertyList ->
    BindingProperty
  | BindingPropertyList _ "," _ BindingProperty

BindingProperty ->
    BindingIdentifier _ Initializer
  | PropertyName _ ":" _ BindingElement

BindingElement ->
    BindingIdentifier _ Initializer
  | BindingPattern _ ":" _ Initializer

### Literal

Literal ->
    NullLiteral
  | BooleanLiteral
  | NumericLiteral
  | StringLiteral

NullLiteral -> 
    "null"

BooleanLiteral ->
    "true"
  | "false"

NumericLiteral ->
    %Integer
  | %Decimal
  | %Hexadecimal
  | %Binary

StringLiteral ->
    %String

ArrayLiteral ->
    "[" _ "]"
  | "[" _ ElementList _ "]"

ElementList ->
    AssignementExpression
  | ElementList _ "," _ AssignementExpression

ObjectLiteral ->
    "{" _ "}"
  | "{" _ PropertyDefinitionList _ "}"

PropertyDefinitionList ->
    PropertyDefinition
  | PropertyDefinitionList _ "," _ PropertyDefinition

PropertyDefinition ->
    IdentifierReference
  | IdentifierReference _ Initializer
  | PropertyName _ ":" _ AssignementExpression
  | MethodDefinition
# | "..." AssignementExpression

PropertyName ->
    LiteralPropertyName
# | ComputedPropertyName

#ComputedPropertyName ->
#   "[" _ AssignementExpression _ "]"

ClassDeclaration ->
    "class" _ BindingIdentifier _ ClassTail

ClassTail ->
    "{" _ ClassBody _ "}"
  | "{" _ "}"
  | ClassHeritage _ "{" _ ClassBody _ "}"
  | ClassHeritage _ "{" _ "}"

ClassHeritage ->
    "extends" __ LeftHandSideExpression
    
ClassBody ->
    ClassElementList

ClassElementList ->
    ClassElement
  | ClassElementList _ ClassElement

ClassElement ->
    MethodDefinition
  | "static" __ MethodDefinition
  | FieldDefinition _ ";"
  | "static" __ FieldDefinition _ ";"
  | ";"

MethodDefinition ->
    ClassElementName _ "(" _ UniqueFormalParameters _ ")" _ "{" _ FunctionBody _ "}"
# | GeneratorMethod
# | "get" _ ClassElementName _ "(" _ ")" _ "{" _ FunctionBody _ "}"
# | "set" _ ClassElementName _ "(" _ PropertySetParameterList _ ")" _ "{" _ FunctionBody _ "}"

PropertySetParameterList ->
    FormalParameter

UniqueFormalParameters -> 
    FormalParameters

FieldDefinition ->
    ClassElementName Initializer
  | ClassElementName

BindingList ->
    LexicalBinding
  | BindingList _ "," _ LexicalBinding

LexicalBinding ->
    BindingIdentifier _ Initializer
  | BindingIdentifier
  | BindingPattern _ Initializer

### Identifiers
# These have different names because one might want to differentiate them 
# to know what is planned to do with the ID

# Binding
BindingIdentifier -> %ID
BindingElement -> BindingIdentifier Initializer

# Name
IdentifierName -> %ID

# Reference
IdentifierReference -> %ID

# Class
ClassElementName -> %ID

LiteralPropertyName -> 
    %ID
  | StringLiteral
  | NumericLiteral

### Whitespaces
_   -> %WS:*                                               {% () => null %}
__  -> %WS:+                                               {% () => null %}
sep -> ";":?                                               {% () => ";" %}