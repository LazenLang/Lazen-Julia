# The Lazen Programming Language

<h2>Why ?</h2>
Lazen is designed to be simple, safe and elegant.<br>
It aims to re-introduce clever computer programming concepts/features in a "better" or "simpler" way.<br>
At the moment, this language has no real reason for you to give of your time for it. Documentation is still interesting.
<br><br>
The language's compiler is not implemented yet.<br>

<h1>Features</h1>
<h2>Operators</h2>
<h3>(Concatenation/PLUS operator) and MINUS operator</h3>
Concatenation is done by using the PLUS (+) operator and always results a String if one of the operand's type is<br>String or Char.<br><br>

If not, the PLUS, even like the MINUS operator, if placed between two expressions of type Integer or Double, is a logical binary operator and results an Integer if both of his operands are Integers, Double if one of his operands is a Double.<br>

However, if placed before an expression of type Integer or Double and after no expression, PLUS or MINUS operators are the logical unary POSITIVE and NEGATIVE operators. Note that the unary PLUS operator is unnecessary.
<br><br>

Example

```
  "a" + 5 - 'c'
    # results a String : "a5c", because one of the operand's value's type is String or Char
  
  5 + 5
    /* results an Integer, because the PLUS operator is placed between two expressions of
       type Integer only */
       
  5 - 2.3
    /* results a Double, because the operator is placed between two expressions of type
       Integer OR Double and one of his operands is a Double */
       
  +(5)
    /* results an Integer or a Double, because the operator is placed before an expression
       of type Integer or Double and after no expression */
```
<br>

<h3>Multiplication/Division Operators</h1>
Both multiplication and division operators should be placed between two expressions of Integer or Double type.
They result an Integer if all of the operands are Integers Double if one of the operand is a Double.

<h3>Ternary Operator</h3>
A ternary operator is a pair of symbols that takes three expressions as operands.
<br><br>
Example

```
  2 > 1 ? "that's okay !" : "that's okay too !"
```
<br>

In this example, the first operand is a boolean expression (an expression which when evaluated, gives True or False).<br>
The second and the third operands are expressions too, but not necessarily boolean.

If 2 is greater than 1, then the expression should be "that's okay !", otherwise, it should be "that's okay too !".<br><br>
The second and the third operands should have the same type ("that's okay !" and "that's okay too !" have the same<br>
type here, so that's correct).

<h3>Multipli</h3>
