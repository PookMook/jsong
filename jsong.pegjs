// JSON Grammar
// ============
//
// Based on the grammar from RFC 7159 [1].
//
// Note that JSON is also specified in ECMA-262 [2], ECMA-404 [3], and on the
// JSON website [4] (somewhat informally). The RFC seems the most authoritative
// source, which is confirmed e.g. by [5].
//
// [1] http://tools.ietf.org/html/rfc7159
// [2] http://www.ecma-international.org/publications/standards/Ecma-262.htm
// [3] http://www.ecma-international.org/publications/standards/Ecma-404.htm
// [4] http://json.org/
// [5] https://www.tbray.org/ongoing/When/201x/2014/03/05/RFC7159-JSON

// ----- 2. JSON Grammar -----

JSON_text
  = ws value:value ws { return value; }

begin_array     = ws "[" ws
begin_ordered = ws "#" ws
begin_object    = ws "{" ws
end_array       = ws "]" ws
end_object      = ws "}" ws
name_separator  = ws ":" ws
value_separator = ws "," ws
date_delimiter  = ws "/" ws
reference_delimiter = ws "@" ws

ws "whitespace" = [ \t\n\r]*

// ----- 3. Values -----

value
  = false
  / null
  / true
  / object
  / array
  / number
  / dateISO
  / string_strong


false = "false" { return false; }
null  = "null"  { return null;  }
true  = "true"  { return true;  }

// ----- date -------

dateISO
  = date_delimiter chars:date_fragment* date_delimiter
  { return new Date(chars.join("")); }

date_fragment = [0-9\-T:.Z]

// ----- reference ------

reference
 = reference_delimiter path:path_syntax* reference_delimiter
 { return "[" + path.join("").split(".").join("][") + "]"}

path_syntax = [a-zA-Z0-9\[\]\.=!<>"']

// ----- 4. Objects -----

object
  = begin_ordered? begin_object
    members:(
      head:member
      tail:(value_separator m:member { return m; })*
      value_separator?
      {
        var result = {};

        [head].concat(tail).forEach(function(element) {
          result[element.name] = element.value;
        });

        return result;
      }
    )?
    end_object
    { return members !== null ? members: {}; }

member

  = name:string name_separator value:reference {
      return { name: name, value: value };
    }
      / name:string name_separator value:value {
      return { name: name, value: value };
    }

// ----- 5. Arrays -----

array
  = begin_ordered? begin_array
    values:(
      head:value
      tail:(value_separator v:value { return v; })*
      { return [head].concat(tail); }
    )?
    end_array
    { return values !== null ? values : []; }

// ----- 6. Numbers -----

number "number"
  = minus? int frac? exp? { return parseFloat(text()); }

decimal_point
  = "."

digit1_9
  = [1-9]

e
  = [eE]

exp
  = e (minus / plus)? DIGIT+

frac
  = decimal_point DIGIT+

int
  = zero / (digit1_9 DIGIT*)

minus
  = "-"

plus
  = "+"

zero
  = "0"

// ----- 7. Strings -----

string_strong
  = quotation_mark chars:char_unsafe* quotation_mark { return chars.join(""); }

string "string"
  = quotation_mark chars:char_unsafe* quotation_mark { return chars.join(""); }
  / chars:char* { return chars.join(""); }

char
  = unescaped
  / escape
    sequence:(
        '"'
      / "\\"
      / "/"
      / "b" { return "\b"; }
      / "f" { return "\f"; }
      / "n" { return "\n"; }
      / "r" { return "\r"; }
      / "t" { return "\t"; }
      / "u" digits:$(HEXDIG HEXDIG HEXDIG HEXDIG) {
          return String.fromCharCode(parseInt(digits, 16));
        }
    )
    { return sequence; }

char_unsafe
  = char
  / ":"
  / ","
  / "/"
  / "@"

escape
  = "\\"

quotation_mark
  = '"'

unescaped
  = [^\0-\x1F\x22\x5C:,/@]

// ----- Core ABNF Rules -----

// See RFC 4234, Appendix B (http://tools.ietf.org/html/rfc4234).
DIGIT  = [0-9]
HEXDIG = [0-9a-f]i
