/*
 * Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion int operator [](int index)
 * Throws an [RangeError] if index is out of bounds.
 * @description Checks that an exception is thrown as expected.
 * @author msyabro
 */
import "dart:typed_data";
import "../../../Utils/expect.dart";

pack(v) => new Float32x4.splat(v);

check(List<Float32x4> list) {
  var l = new Float32x4List.fromList(list);
  try {
    l[-1];
    Expect.fail("RangeError is expected");
  } on RangeError catch(ok) {}
  try {
    l[l.length];
    Expect.fail("RangeError is expected");
  } on RangeError catch(ok) {}
  try {
    l[0x80000000];
    Expect.fail("RangeError is expected");
  } on RangeError catch(ok) {}
  try {
    l[0x7fffffff];
    Expect.fail("RangeError is expected");
  } on RangeError catch(ok) {}
}

main() {
  check([]);
  check([pack(1.0)]);
  List<Float32x4> list = new List(255);
  for(int i = 0; i < 255; ++i) {
    list[i] = pack(i*1.0);
  }
  check(list);
}
