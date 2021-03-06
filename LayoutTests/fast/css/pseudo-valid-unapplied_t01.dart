/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/** 
 * @description This test performs a check for the :valid CSS selector on
 * various input elements and other elements where it shouldn't be applied.
 */
import "dart:html";
import "../../testcommon.dart";

main() {
  var style = new Element.html('''
      <style>
       :valid { background: red; }
       :invalid { background: red; }
       input { background: lime; }
       object { background: lime; }
       button { background: lime; }
       progress { background: lime; }
       meter { background: lime; }
       option { background: lime; }
       select { background: lime; }
      </style>
      ''', treeSanitizer: new NullTreeSanitizer());
  document.head.append(style);

  document.body.setInnerHtml('''
      <p id="description"></p>
      <form method="get">
      <input name="input-text-readonly" type="text" value="Lorem ipsum" readonly/>
      <input name="input-text-disabled" type="text" value="Lorem ipsum" disabled/>
      <input name="input-button" type="button" value="Lorem ipsum">
      <input name="input-reset" type="reset" value="Lorem ipsum"/>
      <input name="input-hidden" type="hidden" value="Lorem ipsum"/>
      <input name="input-image" type="image">
      <fieldset name="fieldset"></fieldset>
      <object name="object"></object>
      <button name="button-button" type="button">Lorem ipsum</button>
      <button name="button-reset" type="reset">Lorem ipsum</button>
      <progress id="progress" value=50 max=100>50</progress>
      <meter id="meter" value=50 max=100>50</meter>
      <select id="select" required><option id="option" value="1">One</option></select>
      </form>
      <div id="console"></div>
      ''', treeSanitizer: new NullTreeSanitizer());

  getBackgroundColor(nameOrId) {
    var list = document.getElementsByName(nameOrId);
    var element = list.length > 0 ? list[0] : document.getElementById(nameOrId);
    return getComputedStyle(element, null).getPropertyValue('background-color');
  }

  var names = [
    "input-text-readonly",
    "input-text-disabled",
    "input-button",
    "input-reset",
    "input-hidden",
    "input-image",
    "object",
    "button-button",
    "button-reset",
    "progress",
    "meter",
    "option",
  ];

  var normalColor = "rgb(0, 255, 0)";
  for (var i = 0; i < names.length; i++)
    shouldBeLikeString(getBackgroundColor(names[i]), normalColor,
        message: "Failed for: " + names[i]);
}
