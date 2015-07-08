/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/** 
 * @description Multicol intrinsic width calculation
 */
import "dart:html";
import "../../testcommon.dart";
import "../../../Utils/async_utils.dart";
import "../../resources/check-layout.dart";
import "pwd.dart";

main() {
  var f = new DocumentFragment.html('''
      <style>
          .gap15 { -webkit-column-gap:15px; column-gap:15px; }
          .mc3 { -webkit-columns:3; columns:3; }
          .mc3w50 { -webkit-columns:3 50px; columns:3 50px; }
          .mc3w150 { -webkit-columns:3 150px; columns:3 150px; }
          .mcw50 { -webkit-columns:50px; columns:50px; }
          .mcw150 { -webkit-columns:150px; columns:150px; }
          .intrinsic { width:intrinsic; }
          .hidden { visibility:hidden; } /* hide garbage produced from &#x200b; characters */
      </style>
      ''', treeSanitizer: new NullTreeSanitizer());
  document.head.append(f);

  document.body.setInnerHtml('''
      <!-- min intrinsic width, non-auto column-count -->
      <div style="width:1px;">
          <div class="intrinsic mc3 gap15" data-expected-width="330">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count -->
      <div style="width:1000px;">
          <div class="intrinsic mc3 gap15" data-expected-width="330">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- min intrinsic width, non-auto column-count, breakable lines -->
      <div style="width:1px;">
          <div class="intrinsic mc3 gap15" data-expected-width="330">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count, breakable lines -->
      <div style="width:1000px;">
          <div class="intrinsic mc3 gap15" data-expected-width="630">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>

      <!-- min intrinsic width, non-auto column-count and small column-width -->
      <div style="width:1px;">
          <div class="intrinsic mc3w50 gap15" data-expected-width="50">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count and small column-width -->
      <div style="width:1000px;">
          <div class="intrinsic mc3w50 gap15" data-expected-width="330">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- min intrinsic width, non-auto column-count and small column-width, breakable lines -->
      <div style="width:1px;">
          <div class="intrinsic mc3w50 gap15" data-expected-width="50">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count and small column-width, breakable lines -->
      <div style="width:1000px;">
          <div class="intrinsic mc3w50 gap15" data-expected-width="630">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>

      <!-- min intrinsic width, non-auto column-count and large column-width -->
      <div style="width:1px;">
          <div class="intrinsic mc3w150 gap15" data-expected-width="100">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count and large column-width -->
      <div style="width:1000px;">
          <div class="intrinsic mc3w150 gap15" data-expected-width="480">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- min intrinsic width, non-auto column-count and large column-width, breakable lines -->
      <div style="width:1px;">
          <div class="intrinsic mc3w150 gap15" data-expected-width="100">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      <!-- max intrinsic width, non-auto column-count and large column-width, breakable lines -->
      <div style="width:1000px;">
          <div class="intrinsic mc3w150 gap15" data-expected-width="630">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>

      <!-- min intrinsic width, auto column-count and small column-width -->
      <div style="width:1px;">
          <div class="intrinsic mcw50 gap15" data-expected-width="50">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- max intrinsic width, auto column-count and small column-width -->
      <div style="width:1000px;">
          <div class="intrinsic mcw50 gap15" data-expected-width="100">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- min intrinsic width, auto column-count and small column-width, breakable lines -->
      <div style="width:1px;">
          <div class="intrinsic mcw50 gap15" data-expected-width="50">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      <!-- max intrinsic width, auto column-count and small column-width, breakable lines -->
      <div style="width:1000px;">
          <div class="intrinsic mcw50 gap15" data-expected-width="200">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>

      <!-- min intrinsic width, auto column-count and large column-width -->
      <div style="width:1px;">
          <div class="intrinsic mcw150 gap15" data-expected-width="100">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- max intrinsic width, auto column-count and large column-width -->
      <div style="width:1000px;">
          <div class="intrinsic mcw150 gap15" data-expected-width="150">
              <div style="width:100px; height:10px;"></div>
          </div>
      </div>
      <!-- min intrinsic width, auto column-count and large column-width, breakable lines -->
      <div style="width:1px;">
          <div class="intrinsic mcw150 gap15" data-expected-width="100">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      <!-- max intrinsic width, auto column-count and large column-width, breakable lines -->
      <div style="width:1000px;">
          <div class="intrinsic mcw150 gap15" data-expected-width="200">
              <div class="hidden"><div style="display:inline-block; width:100px; height:10px;"></div>&#x200b;<div style="display:inline-block; width:100px; height:10px;"></div></div>
          </div>
      </div>
      ''', treeSanitizer: new NullTreeSanitizer());

  asyncStart();
  window.onLoad.listen((_) {
    checkLayout('.intrinsic');
    asyncEnd();
  });
}