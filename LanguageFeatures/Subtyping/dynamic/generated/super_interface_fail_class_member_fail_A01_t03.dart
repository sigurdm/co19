/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion We say that a type T0 is a subtype of a type T1 (written T0 <: T1)
 * when:
 * Super-Interface: T0 is an interface type with super-interfaces S0,...Sn
 * - and Si <: T1 for some i
 * @description Check that if there is no i, such that Si <: T1, then T0 is not
 * subtype of T1
 * @author sgrekhov@unipro.ru
 */
/**
 * @description Check that if type T0 is not a subtype of a type T1, then
 * instance of T0 cannot be be assigned to the mixin member of type T1
 * @author sgrekhov@unipro.ru
 */
/*
 * This test is generated from super_interface_fail_A01.dart and 
 * class_member_fail_x03.dart.
 * Don't modify it. If you want to change this file, change one of the files 
 * above and then run generator.dart to regenerate the tests.
 */


import '../../utils/common.dart';
import '../../../../Utils/expect.dart';

class T1 {}

// Missing subtype relation to T1
abstract class S0 {}
abstract class S1 {}
abstract class S2 {}

abstract class T0 implements S0, S1, S2  {}

class T implements T0 {}

T0 t0Instance = new T();
T1 t1Instance = new T1();




class ClassMemberSuper1_t03 {
  T1 m;

  void set superSetter(T1 val) {}
}

class ClassMember1_t03 extends Object with ClassMemberSuper1_t03 {

  test1() {
    m = forgetType(t0Instance);
  }

  test2() {
    superSetter = forgetType(t0Instance);
  }
}

class ClassMemberSuper2_t03<X> {
  X m;

  void set superSetter(X val) {}
}

class ClassMember2_t03<X> extends ClassMemberSuper2_t03<X> {

  test1() {
    m = forgetType(t0Instance);
  }

  test2() {
    superSetter = forgetType(t0Instance);
  }
}

main() {
  Expect.throws(() {
    new ClassMember1_t03().m = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t03().superSetter = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t03().test1();
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember1_t03().test2();
  }, (e) => e is TypeError);

  // Test type parameters

  //# <-- NotGenericFunctionType
  Expect.throws(() {
    new ClassMember2_t03<T1>().m = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t03<T1>().superSetter = forgetType(t0Instance);
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t03<T1>().test1();
  }, (e) => e is TypeError);
  Expect.throws(() {
    new ClassMember2_t03<T1>().test2();
  }, (e) => e is TypeError);
  //# -->
}
