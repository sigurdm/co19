/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Since the spread is unpacked and its individual elements added to
 * the containing collection, we don't require the spread expression itself to
 * be assignable to the collection's type. For example, this is allowed:
 *
 *    var numbers = <num>[1, 2, 3];
 *    var ints = <int>[...numbers];
 *
 * This works because the individual elements in numbers do happen to have the
 * right type even though the list that contains them does not. As long as the
 * spread object is "spreadable" — it implements [Iterable] — there is no
 * static error.
 * @description Checks that it's possible to have the spread expression which is
 * not assignable to the collection type for the list.
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=spread-collections

import "../../Utils/expect.dart";

main() {
  var numbers = <num>[1, 2, 3];
  Expect.listEquals([1, 2, 3], <int>[...numbers]);

  var objects = <Object>[2, 7, 9];
  Expect.listEquals([2, 7, 9], <int>[...numbers]);

  var a;
  Expect.throws(() => a = <String>[...objects]);

  var strings = <String>[];
  Expect.listEquals([11], <int>[11, ...Strings]);
}
