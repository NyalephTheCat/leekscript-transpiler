@{%
    const {lexer} = require("../lexer/lexer.js")

    const {ast} = require("./parserTools.js")
%}

@lexer lexer

###############################################################################
###                                 Macros                                  ###
###############################################################################


###############################################################################
###                                Generals                                 ###
###############################################################################

Script ->
    MainScope EOF                                                              {% ast("Script") %}

MainScope ->
    Expression (Sep MainScope):*                                               {% ast("MainScope") %}

StatementList ->
    Statement (Sep StatementList):*                                            {% ast("StatementList") %}

Statement ->
    Expression                                                                 {% id %}

Expression ->
    MemberExpression                                                           {% id %}

MemberExpression ->
    PrimaryExpression                                                          {% id %}
  | MemberExpression "[" Expression "]"                                        {% ast("MemberExpressionIndex") %}
  | MemberExpression "." IdentifierReference                                   {% ast("MemberExpressionProperty") %}

PrimaryExpression ->
    IdentifierReference                                                        {% id %}
  | String                                                                     {% id %}
  | Number                                                                     {% id %}
  | ArrayLiteral                                                               {% id %}
  | ObjectLiteral                                                              {% id %}
  | MapLiteral                                                                 {% id %}
  | "this"                                                                     {% id %}
  | FunctionExpression                                                         {% id %}
  | "(" ExpressionList:? ")"                                                   {% ast("ParenthesizedExpressionList") %}

FunctionExpression ->
    "function" "(" ExpressionList:? ")" FunctionBody                           {% ast("FunctionExpression") %}

FunctionBody ->
    "{" StatementList "}"                                                      {% ast("FunctionBody") %}

###############################################################################
###                                 Utils                                   ###
###############################################################################

PropertyList ->
    PropertyAssign ("," PropertyList):*                                        {% ast("PropertyList") %}

PropertyAssign ->
    (BindingIdentifier ":" Expression)                                         {% ast("PropertyAssign") %}

ExpressionList ->
    Expression ("," ExpressionList):*                                          {% ast("ExpressionList") %}

###############################################################################
###                                Literals                                 ###
###############################################################################

######                           Identifiers                             ######

BindingIdentifier ->
    %ID                                                                        {% ast("BindingIdentifier") %}

IdentifierReference ->
    %ID                                                                        {% ast("IdentifierReference") %}

######                             String                                ######

String ->
    %String                                                                    {% id %}

######                             Number                                ######

Number ->
    %Integer                                                                   {% id %}
  | %Decimal                                                                   {% id %}
  | %Binary                                                                    {% id %}
  | %Hexadecimal                                                               {% id %}

######                             Array                                 ######

ArrayLiteral ->
    "[" ExpressionList:? "]"                                                   {% ast("ArrayLiteral") %}

######                             Object                                ######

ObjectLiteral ->
    "{" PropertyList:? "}"                                                     {% ast("ObjectLiteral") %}

######                              Map                                  ######

MapLiteral ->
    "[" (PropertyList | ":") "]"                                               {% ast("MapLiteral") %}

######                            Separator                              ######

Sep ->
    ";":?                                                                      {% ast("Sep") %}

######                              EOF                                  ######

EOF ->
    %EOF                                                                       {% id %}