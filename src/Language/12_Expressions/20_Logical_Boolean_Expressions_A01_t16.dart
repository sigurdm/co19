/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion The logical boolean expressions combine boolean objects using the boolean
 * conjunction and disjunction operators.
 * logicalOrExpression:
 *   logicalAndExpression ('||' logicalAndExpression)*
 * ;
 * logicalAndExpression:
 *   bitwiseOrExpression ('&&' bitwiseOrExpression)*
 * ;
 * A logical boolean expression is either a bitwise expression, or an
 * invocation of a logical boolean operator on an expression e1 with argument e2.
 * @description Checks that it is permitted to chain as many OR or AND expressions
 * as one wants to.
 * @author rodionov
 * @reviewer iefremov
 */


main() {
  var t = true, f = false;
  t || f || f || f || t || t;
  t && f && f && f && t && t;
  t || f && f || f && t || t;
}
