/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion We say that a type T0 is a subtype of a type T1 (written T0 <: T1)
 * when:
 * Interface Compositionality: T0 is an interface type
 * C0<S0, ..., Sk> and T1 is C0<U0, ..., Uk> and each Si <: Ui
 * @description Check that if type T0 is an interface type
 * C0<S0, ..., Sk> and T1 is C0<U0, ..., Uk> and each Si <: Ui then T0 is a
 * subtype of T1
 * @author sgrekhov@unipro.ru
 */
import '../../utils/common.dart';

abstract class U0 {}
abstract class U1 {}
abstract class U2 {}

abstract class S0 extends U0 {}
abstract class S1 extends U1 {}
abstract class S2 extends U2 {}

class C0<X, Y, Z> {}

C0<S0, S1, S2> t0Instance = new C0<S0, S1, S2>();
C0<U0, U1, U2> t1Instance = new C0<U0, U1, U2>();




class LocalVariableTest {

  LocalVariableTest() {
    C0<U0, U1, U2> t1 = forgetType(t0Instance);
    t1 = forgetType(t0Instance);
  }

  static staticTest() {
    C0<U0, U1, U2> t1 = forgetType(t0Instance);
    t1 = forgetType(t0Instance);
  }

  test() {
    C0<U0, U1, U2> t1 = forgetType(t0Instance);
    t1 = forgetType(t0Instance);
  }
}

main() {
  foo() {
    C0<U0, U1, U2> t1 = forgetType(t0Instance);
    t1 = forgetType(t0Instance);
  }

  C0<U0, U1, U2> t1 = forgetType(t0Instance);
  t1 = forgetType(t0Instance);
  foo();
  LocalVariableTest x = new LocalVariableTest();
  x.test();
  LocalVariableTest.staticTest();
}