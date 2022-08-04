# Leekscript transpiler

todo: add more info here :)

Currently there is only a basic parser located in `./src/parser/ls.ne`

The parser is really limited and still misses a lot of operations possible

# Stuff planned:

- Fully valid leekscript 4 parser
- Binder
- Function inliner
- Formatter
- Optimisator
- Comment preserving AST/Grammar??

Features planned:

```js
// Property extraction on objects
const { property } = object

// List expansion
list = [...[1, 2, 3], 4] // list = [1, 2, 3, 4]

// Switch statement
switch (a) {
  case 1:
    // something
  case 2:
    // something
  default:
    // otherwise
}

// Elisions in lists
list = [1, 2,,,, 6] // list = [1, 2, null, null, null, 6] 

// Enum
enum Name {
  Value, // Starts with 0
  ValueOne,
  ValueTwo,
  ValueTen = 10,
  ValueEleven
}

// Better imports
// Method type definition (To be defined better)
import module from "lib"
import { func, constant } from "./relative/path"

// In ./relative/path
export func a() {}
export constant b
// In lib
export default const b = 10;
```

More features might be planned such as type hints but they need to be refined to ensure a coherant grammar
