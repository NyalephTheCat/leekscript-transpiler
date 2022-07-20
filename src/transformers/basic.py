from lark import Transformer, Visitor, v_args
import textwrap as tr

class BasicWriter(Transformer):
    def __init__(self):
        super().__init__()
        self.out = ""
        self.indentChar = "    "

    def script(self, val):
        return "\n".join(val)

    def import_declaration(self, val):
        return "import(" + val[0] + ")"

    def global_declaration(self, val):
        return "global " + ", ".join(val)

    def block(self, val):
        return "{\n" + tr.indent(val[0], self.indentChar) + "\n}\n"

    def if_statement(self, val):
        out = "if " + val[0] + "\n" + tr.indent(val[1], self.indentChar)
        if len(val) <= 2: return
        return out + "\nelse " + val[2]

    def function_declaration(self, val):
        out = "function"
        i = 0
        if len(val) > 2: 
            out += " " + val[i]
            i += 1
        return out + " " + val[i] + " " + val[i + 1]

    def param_list(self, val):
        return "(" + ", ".join(val) + ")"

    def class_declaration(self, val):
        out = "class " + val[0] + " "
        i = 0
        if len(val) > 2:
            out += "extends " + val[1] + " "
            i += 1
        return out + val[i + 1]

    def class_body(self, val):
        return "{\n" + tr.indent("\n".join(val), self.indentChar) + "\n}"

    def method_declaration(self, val):
        return " ".join(val)

    def property_declaration(self, val):
        i = 0
        i += val[0] in [ "public", "private", "protected" ]
        i += val[i] == "static"
        out = " ".join(val[:-1])
        if len(val) - i == 2:
            return out + " = " + val[-1] + ";"
        return out + " " + val[-1] + ";"

    def pattern_assign(self, val):
        if len(val) == 1: 
            return val[0]
        return val[0] + " = " + val[1]

    def parenthesized_expression(self, val):
        return "(" + val[0] + ")"

    def spreadable(self, val):
        if len(val) == 1: return val[0]
        return "..." + val[1]

    def semi(self, val):
        return ";"

    def STRING(self, val):
        return str(val[0])

    def __default__(self, val, children, meta):
        return children[0]

    def __default_token__(self, val):
        return val