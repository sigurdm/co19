/*
 * Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion The grammar changes for map and set are a little more complex
 * because of the potential ambiguity of collections containing only spreads.
 * The changed and new rules are:
 *
 *    setOrMapLiteral:
 *    mapLiteral |
 *    setLiteral |
 *    mapOrSetLiteral
 *    ;
 *
 *    mapLiteral:
 *    const? typeArguments? '{' mapLiteralEntryList? '}'
 *    ;
 *
 *    mapLiteralEntryList:
 *    mapLiteralEntry ( ',' mapLiteralEntry )* ','?
 *    ;
 *
 *    mapLiteralEntry:
 *    expression ':' expression |
 *    spread
 *    ;
 *
 *    setLiteral:
 *    'const'? typeArguments? '{' spreadableList '}' ;
 *
 *    mapOrSetLiteral:
 *    'const'?  '{' spread (',' spread)* '}' ;
 *
 * @description Checks that exception is thrown if spreadable element is not
 * set for spreadable map.
 * @author iarkh@unipro.ru
 */
// SharedOptions=--enable-experiment=spread-collections

main() {
  Map map1 = {1: 1, 2: 4, 3: 6};
  Map map2;
  int i;

  Map a;
  a = {...map2};          //# 01: compile-error
  a = {...map1, ...map2}; //# 02: compile-error
  a = {...map2, ...map1}; //# 03: compile-error

  a = {...map2, 10: 2};   //# 04: compile-error
  a = {10: 2, ...map2};   //# 05: compile-error

  a = {...map1, i: 10};   //# 06: compile-error
  a = {...map1, 10: i};   //# 07: compile-error
  a = {i: 10, ...map1};   //# 08: compile-error
  a = {10: i, map1};      //# 09: compile-error
}
