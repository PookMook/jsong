# jsong
Json Graph

Fully compatible with JSON (meaning JSONG parser should parse JSON)
last item in iterable/object can be followed by ,
multiline with ``

Non = !
reference = @path.path['key'=='value'] (relative ^.^ to go up 2 row, root. as the root JSONG element, filter only for iterable), works as value
atomic = < JSON >
set = #[]
map = #{}
function = (arg1, arg2)(CODE;return arg*3) OR (arg1, arg2)=>(arg1+arg2)
function to be evaluated = (arg, arg)(CODE;return arg*3)(value, value) works as value
promise = #(CODE; resolve 'sucess'; reject 'error';)
generator = *(arg)(yield arg; return arg+1)
concatenation = + 'name: ' + @root.identities[id==@root.search.id].name

