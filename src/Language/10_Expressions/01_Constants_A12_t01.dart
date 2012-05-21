/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion An expression of one of the forms ~e, e1 ^ e2, e1 & e2, e1 | e2,
 * e1 >> e2 or e1 << e2, where e1 and e2 are constant expressions that
 * evaluate to an integer value or to null is a constant expression.
 * @description Checks that various expressions of the specified forms can be elements
 * of a constant list literal and are, therefore, constant expressions.
 * @author iefremov
 * @reviewer rodionov
 */

final constList = const [
  ~1,
  1 ^ 0xFF,
  0xCAFE & 0xBABE,
  0xDEAD | 0xBEEF,
  1 >> 100,
  100 << 1,
  ~(((1 + 2) ~/ 2) & (100500 >> 2))  | (~1 ^ (1<<2)),
];

main() {
  Expect.isTrue(constList is List);
}
