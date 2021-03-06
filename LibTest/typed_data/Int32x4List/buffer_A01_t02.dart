/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion ByteBuffer buffer
 * Returns the byte buffer associated with this object.
 * @description Checks that [buffer] is read-only and can't be set.
 * @author ngl@unipro.ru
 */

import "dart:typed_data";
import "../../../Utils/expect.dart";

Int32x4 i32x4(n) => new Int32x4(n, n, n, n);

void check(List<Int32x4> list) {
  dynamic l = new Int32x4List.fromList(list);
  try {
    l.buffer = new Int32x4List.fromList(list).buffer;
    Expect.fail("[buffer] should be read-only");
  } on NoSuchMethodError {}
}

main() {
  check([]);
  check([i32x4(1)]);
  check([
    i32x4(0), i32x4(1), i32x4(2), i32x4(3), i32x4(4), i32x4(5), i32x4(6),
    i32x4(7), i32x4(8), i32x4(9)
  ]);
}
