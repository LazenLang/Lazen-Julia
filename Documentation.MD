# The Lazen Programming Language

<h2>Why ?</h2>
Lazen is designed to be simple, safe and elegant.<br>
It aims to re-introduce clever computer programming concepts/features in a "better" or "simpler" way.
At the moment, this language has no real reason for you to give of your time for it. Documentation is still interesting.
<br><br>
The language's compiler is not implemented yet.<br>

<h2>Features</h2>
<h3>Concatenation/PLUS operator</h3>
Concatenation is done by using the PLUS (+) operator and always results a String if one of the operand's type is<br>String or Char.<br><br>

If not, the PLUS operator, if placed between two expressions of type Integer or Double, is the logical binary PLUS operator and results an Integer if all of his operands are Integers, but Double if one of his operands is a Double.<br><br>

However, if placed before an expression of type Integer or Double and after no expression, the PLUS operator is the logical unary PLUS operator. Note that the unary PLUS operator is unnecessary.
<br><br>

Example

```
  "a" + 5 + 'c'
    # results a String, because one of the operand's value's type is String or Char
  
  5 + 5
    # results an Integer, because the PLUS operator is placed between two expressions of type Integer or Double
```
<br>

<h3>Ternary Operator</h3>
A ternary operator is a pair of two operators that takes three expressions as operands.
<br><br>
Example

```
  2 > 1 ? "that's okay !" : "that's okay too !"
```
<br>

In this example, the first operand is a boolean expression (an expression which when evaluated, gives True or False).<br>
The second and the third operands are expressions too, but not necessarily boolean.

If 2 is greater than 1, then the expression should be "that's okay !", otherwise, it should be "that's okay too !".
