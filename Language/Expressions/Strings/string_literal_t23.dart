/*
 * Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion stringLiteral:
 *   (MULTI_LINE_STRING | SINGLE_LINE_STRING)+
 * ;
 * SINGLE_LINE_STRING:
 *   '"' STRING_CONTENT_DQ* '"'
 *   | ''' STRING_CONTENT_SQ* '''
 *   | 'r' ''' (~( ''' | NEWLINE ))* '''
 *   | 'r' '"' (~( '"' | NEWLINE ))* '"'
 * ;
 * STRING_CONTENT_DQ:
 *   ~( '\' | '"' | '$' | NEWLINE )
 *   | '\' ~( NEWLINE )
 *   | STRING_INTERPOLATION
 * ;
 * STRING_CONTENT_SQ:
 *   ~( '\' | ''' | '$' | NEWLINE )
 *   | '\' ~( NEWLINE )
 *   | STRING_INTERPOLATION
 * ;
 * NEWLINE:
 *   '\n'
 *   | '\r'
 * ;
 * @description Checks that a raw string literal can't begin with a double quote
 * and end with single.
 * @compile-error
 * @author msyabro
 * @reviewer rodionov
 */

main() {
  try {
    r"string';
  } catch(e) {}
}