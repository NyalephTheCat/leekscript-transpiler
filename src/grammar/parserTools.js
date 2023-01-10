const { inspect } = require("util");

function ast(name, props) {
    return (values) => {
        var self = {
            [inspect.custom]: (depth) => {
                return {
                    type: name,
                    values
                }

            },
            type: name, 
            values, 
            ...props
        }
        
        var i = 0;
        for (var key in values) {
            if (!values[key]) {
                i++;
                continue;
            }
            values[key].parent = self;
            values[key].pos = i++;
        }
        self.getChild = (nth) => self.values[nth];
        self.getPos = (node) => self.values.find((el) => el === node);
        self.getSibling = (rel) => self.parent?.getChild(self.pos + rel);

        return self
    }
}

function opt() {
    return (values) => !values[0] ? null : values
}

module.exports = {
    ast, opt
}