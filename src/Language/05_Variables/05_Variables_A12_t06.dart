/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion A variable declaration of one of the forms
 * T v;, T v = e; , const T v = e;, ﬁnal T v; or ﬁnal T v = e;
 * always induces an implicit getter function with signature
 *   T get v
 * @description Checks that a static warning is produced when assigning result of
 * T get v() invocation to a variable whose type may not be assigned to T. 
 * The variable declaration is of the form const T v = e;.
 * @static-warning
 * @author msyabro
 * @reviewer iefremov
 * @reviewer rodionov
 * @needsreview issue 3323
 */

import "../../Utils/dynamic_check.dart";

class A {
  const int v = 100;
}

main() {
  A a = new A();
  checkTypeError(() {bool b = a.v;});
}