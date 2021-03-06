/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @description This test checks if checkValidity() correctly fires an invalid
 * event on invalid form control elements.
 */
import "dart:html";
import "../../testcommon.dart";

main() {
  document.body.setInnerHtml('''
      <p id="description"></p>
      <form method="get">
      <input name="victim" type="text" required/>
      <input name="victim" type="text" pattern="Lorem ipsum" value="Loremipsum"/>
      <textarea name="victim" required></textarea>
      </form>
      <div id="console"></div>
      ''', treeSanitizer: new NullTreeSanitizer());

  List<TextInputElement> v = document.getElementsByName("victim");
  var count = 0;

  for (var elem in v)
    elem.onInvalid.listen((_) => ++count);

  for (var elem in v)
    shouldBe(elem.checkValidity(), false);

  shouldBe(count, 3);
}
