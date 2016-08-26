/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion  abstract void forEach(void f(K key, V value))
 * Applies f to each {key, value} pair of the map.
 * @description Checks that something is thrown when the argument is null
 * (compiler error appears if it has a type that is incompatible with the
 * required function type, so no need to check this case for strong mode).
 * @author msyabro
 * @reviewer varlax
 */
library forEach_A01_t02;

import "../../../Utils/expect.dart";

test(Map create([Map content])) {
  Map map = create();
  
  map["1"] = 3;
  map["2"] = 5;
  
  Expect.throws(() => map.forEach(null));
}
