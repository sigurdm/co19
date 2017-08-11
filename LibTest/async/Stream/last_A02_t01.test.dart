/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Future<T> last
 * If this stream is empty (a done event occurs before the first data event),
 * the resulting future completes with a StateError.
 * @description Checks that future completes with a StateError when this
 * stream is empty.
 * @author kaigorodov
 */
library last_A02_t01;
import "dart:async";
import "../../../Utils/async_utils.dart";
import "../../../Utils/expect.dart";

void test(Stream<T> create(Iterable<T> data)) {
  Stream s = create([]);
  asyncStart();
  s.last.then(
    (value) {
      Expect.fail("Returned future should complete with error");
    },
    onError: (error) {
      Expect.isTrue(error is StateError);
      asyncEnd();
    }
  );
}