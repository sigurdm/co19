/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Finally, the conditional [?]/[:] operator only evaluates one of
 * its branches, depending on whether the condition expression evaluates to
 * [true] or [false]. The other branch must also be a potentially constant
 * expression.
 * @description Checks that compile error is thrown if condition of conditional
 * operator [?]/[:] is [false] and the first operand is not a correct constant
 * expression.
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=constant-update-2018
import "../../Utils/expect.dart";

class MyClass {
  final bool res;
  const MyClass() : res = (false ? (null as String).length : true); //# 01: compile-time error
}

main() {
  String i;
  const String str1 = false ? (null as String).length : "OK";        //# 02: compile-time error
  const String str2 = false ? i : "OK";                              //# 03: compile-time error
}
