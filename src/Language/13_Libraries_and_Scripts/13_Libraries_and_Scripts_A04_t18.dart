/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion libraryDefinition:
 *   libraryName import* partDirective* topLevelDefinition*
 * ;
 * @description Checks that it is a compile-error if a library contains
 * two library declarations (with different names).
 * @compile-error
 * @author msyabro
 * @reviewer rodionov
 */

import "13_Libraries_and_Scripts_A04_t18_lib.dart";

main() {
  try {
    var someVar = 1;
  } catch(e) {}
}