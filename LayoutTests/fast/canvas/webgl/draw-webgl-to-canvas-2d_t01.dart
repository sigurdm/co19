/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/** 
 * @description 
 */
import "dart:html";
import "dart:web_gl" as wgl;
import "../../../testcommon.dart";

main() {
  document.body.setInnerHtml('''
      <span id="description" style="color: white">
      This test checks for drawing webgl to canvas 2d. The test process is as follows:
      1. draw a green rect on a webgl context.
      2. draw a red rect on a canvas 2d context, and check a pixel (should be red).
      3. draw the webgl contents on the canvas 2d context, and check a pixel (should be green).
      4. wait for few frames.
      5. draw a red rect on the canvas 2d context, and check a pixel (should be red).
      6. draw the webgl contents on the canvas 2d context, and check a pixel (see below explanation).

      Above test is executed for both preserve and non-preserve webgl contexts.
      For the preserve webgl context, the pixel on #6 is green.
      For the non-preserve webgl context, the pixel on #6 is undefined.[1]

      [1] http://www.khronos.org/registry/webgl/specs/latest/1.0/.
      "This default behavior can be changed by setting the preserveDrawingBuffer
      attribute of the WebGLContextAttributes object. If this flag is true, the
      contents of the drawing buffer shall be preserved until the author either clears
      or overwrites them. If this flag is false, attempting to perform operations
      using this context as a source image after the rendering function has returned
      can lead to undefined behavior.".
      </span>
      <canvas id="preserve-canvas3d" width="100" height="100"></canvas>
      <canvas id="preserve-canvas2d" width="100" height="100"></canvas>
      <canvas id="nonpreserve-canvas3d" width="100" height="100"></canvas>
      <canvas id="nonpreserve-canvas2d" width="100" height="100"></canvas>
      ''', treeSanitizer: new NullTreeSanitizer());

  var preserve_ctx2D;
  var preserve_canvas3D;
  var preserve_gl;
  var nonpreserve_ctx2D;
  var nonpreserve_canvas3D;
  var nonpreserve_gl;
  var imgdata;

  createContexts() {
    preserve_ctx2D = getContext2d("preserve-canvas2d");
    preserve_canvas3D = document.getElementById('preserve-canvas3d');
    preserve_gl = preserve_canvas3D.getContext('webgl', {'preserveDrawingBuffer': true});
    nonpreserve_ctx2D = getContext2d("nonpreserve-canvas2d");
    nonpreserve_canvas3D = document.getElementById('nonpreserve-canvas3d');
    nonpreserve_gl = nonpreserve_canvas3D.getContext('webgl', {'preserveDrawingBuffer': false});
  }

  renderWebGL(gl) {
    gl.clearColor(0, 1, 0, 1);
    gl.clear(wgl.WebGL.COLOR_BUFFER_BIT);
  }

  drawWebGLToCanvas2D(ctx2D, canvas3D, isDrawingBufferUndefined) {
    // draw red rect on canvas 2d.
    ctx2D.fillStyle = 'red';
    ctx2D.fillRect(0, 0, 100, 100);
    var imageData = ctx2D.getImageData(0, 0, 1, 1);
    imgdata = imageData.data;
    shouldBe(imgdata[0], 255);
    shouldBe(imgdata[1], 0);
    shouldBe(imgdata[2], 0);

    // draw the webgl contents (green rect) on the canvas 2d context.
    ctx2D.drawImage(canvas3D, 0, 0);
    ctx2D.getImageData(0, 0, 1, 1);
    imageData = ctx2D.getImageData(0, 0, 1, 1);
    imgdata = imageData.data;
    if (isDrawingBufferUndefined) {
      // Current implementation draws transparent texture on the canvas 2d context,
      // although the spec said it leads to undefined behavior.
      shouldBe(imgdata[0], 255);
      shouldBe(imgdata[1], 0);
      shouldBe(imgdata[2], 0);
    } else {
      shouldBe(imgdata[0], 0);
      shouldBe(imgdata[1], 255);
      shouldBe(imgdata[2], 0);
    }

    if (isDrawingBufferUndefined)
      asyncEnd();
  }

  // create both canvas 2d and webgl contexts.
  createContexts();
  // prepare webgl contents.
  renderWebGL(preserve_gl);
  renderWebGL(nonpreserve_gl);

  debug("Check for drawing webgl to canvas 2d on the same frame.");
  debug("1) when drawingBuffer is preserved.");
  drawWebGLToCanvas2D(preserve_ctx2D, preserve_canvas3D, false);
  debug("2) when drawingBuffer is not preserved.");
  drawWebGLToCanvas2D(nonpreserve_ctx2D, nonpreserve_canvas3D, false);

  asyncStart();
  setTimeout(() {
    debug("Check for drawing webgl to canvas 2d several frames after drawing webgl contents.");
    debug("1) when drawingBuffer is preserved.");
    drawWebGLToCanvas2D(preserve_ctx2D, preserve_canvas3D, false);
    debug("2) when drawingBuffer is not preserved. It leads to undefined behavior.");
    drawWebGLToCanvas2D(nonpreserve_ctx2D, nonpreserve_canvas3D, true);
  }, 50);
}
