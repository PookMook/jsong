# jsong
Json Graph

Fully compatible with JSON (meaning JSONG parser should parse JSON)
last item in iterable/object can be followed by ,
keys don't need to be encapsuled by "" or ''
multiline with ``

```
Non = !
reference = @path.path['key'==='value']@ (starting as the root JSONG element, filter only for iterable), works as value, eg @item[id==3].name@
atomic = < JSON >, eg <{'format':'jsong','coolness':'through the roof!'}>
date = /ISO8601/, eg /2018-01-11T02:30:09.428Z/
set = #[], eg #[1,2,3,5,6]
map = #{}, eg #{"firstKey":"value","secondKey":"association"}
function = (arg1, arg2)(CODE;return arg*3) OR (arg1, arg2)=>(arg1+arg2), eg (name)=>('hello'+name+', how are you?'), or (name)(return 'hello'+name+', how are you?')
function to be evaluated = (arg, arg)(CODE;return arg*3)(value, value) works as value, eg (name)(return 'hello'+name+', how are you?')('Arthur')
promise = #(CODE; resolve 'sucess'; reject 'error';)
generator = *(arg)(yield arg; return arg+1)
concatenation = + , eg 'name: ' + @root.identities[id==@root.search.id].name
```

# examples

```
{
  categories:[
    {
      id:0,
      name:"foo",
    },
    {
      id:1,
      name:"bar"
    }
  ],
  items:[
    {
      id:0,
      title:"How to sync all categories",
      categories:#[@categories['id'===0]@,@categories[1]@],
      linkedItem:#[@items[1]@],
      created_at: /2018-01-11T02:30:09.428Z/
    },
    {
      id:1,
      title:"I'm a reference",
      categories:#[@categories[1]@],
      linkedItem:#[@items[0]@],
      created_at: /2018-01-11T02:40:09.428Z/,
    }
  ]
}
```
