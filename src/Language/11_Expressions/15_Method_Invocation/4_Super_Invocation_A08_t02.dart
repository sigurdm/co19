/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion If S.m does not exist, or if F is not a function type,
 * the static type of i is Dynamic;
 * otherwise the static type of i is the declared return type of F.
 * @description Checks that the static type of a super invocation is Dynamic
 * when F is not a function type (but can be assigned to it) by ensuring that 
 * there's no static warning when a result of such invocation is being assigned 
 * to variables with various declared types.
 * @author rodionov
 * @reviewer iefremov
 */

class C {
  Object obj;
  var dyn;
}

class S extends C {
  void test() {
    try {
      String foo = super.obj();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}

    try {
      bool foo = super.dyn();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}

    try {
      C foo = super.obj();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}

    try {
      Object foo = super.dyn();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}

    try {
      List foo = super.obj();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}

    try {
      Map foo = super.dyn();
      Expect.fail("NullPointerException expected.");
    } on NullPointerException catch(ex) {}
  }
}

main() {
  new S().test();
}