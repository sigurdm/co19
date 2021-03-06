/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion An expression like:
 *
 *    { ...a, ...b }
 *    Is syntactically parsed as [mapOrSetLiteral]. To determine whether it
 *    actually is a map or set, the surrounding context is used. Given an
 *    [mapOrSetLiteral] with context type [C]:
 *
 *   If [Set<Null>] is assignable to [C], and [Map<Null, Null>] is not
 *   assignable to [C], then the collection is a set literal.
 *
 *   Otherwise, it is a map literal.
 *
 *   In other words, if it can only be a set, it is. Otherwise, it's a map.
 * @description Checks that if [a] is a map literal and [b] is set literals,
 * it's a compile error.
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=spread-collections

main() {
  List list =  [1, 12, 24];
  Map map = {1: 1, "test": 1, 14: null};

  var res1 = {...map, ...list}; //# 01: compile-time error
  var res2 = {...list, ...map}; //# 02: compile-time error
}
