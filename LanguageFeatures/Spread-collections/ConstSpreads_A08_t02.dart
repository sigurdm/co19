/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion The existing rules against self-reference prohibit a collection
 * from spreading into itself:
 *   const list = [...list]; // Error.
 * @description: Checks that constant set cannot spread itself
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=spread-collections

main() {
  const Set set1 = {...set1};  //# 01: compile-time error
  const Set set2 = {...?set2}; //# 02: compile-time error
}
