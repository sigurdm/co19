// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library("2_Imports_A02_lib_reexport2_filtered");
#import("2_Imports_A02_lib_reexport_filtered.dart", export: true, hide: ["B"], prefix: "P");