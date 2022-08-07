@{%
    const {lexer} = require("../lexer/lexer.js")

    const store = (type) => (values) => {return {type, values, terminal: false}}
    const storeList = (type) => (values) => {return {type, values: values[0], terminal: false}}
%}

@lexer lexer

Script ->
    GlobalScopeList:? %EOF                                                     {% store("Script") %}

GlobalScopeList ->
    GlobalScopeElem:+                                                          {% storeList("GlobalScopeList") %}

GlobalScopeElem ->
    GlobalDeclaration                                                          {% id %}
# | ClassDefinition
# | IncludeStatement
# | Statement

#### Global Scope

GlobalDeclaration ->
    "global" BindingIdentifier Initializer:? sep                               {% store("GlobalDeclaration") %}


#### Expression

Expression ->
    Atom                                                                       {% id %}

Atom ->
    IdentifierReference                                                        {% id %}

#### Parts

Initializer ->
    "=" Expression                                                             {% store("Initializer") %}

#### IDs

BindingIdentifier ->
    %ID                                                                        {% id %}

IdentifierReference ->
    %ID                                                                        {% id %}

#### Separator

sep ->
    %Semi:?                                                                    {% id %}