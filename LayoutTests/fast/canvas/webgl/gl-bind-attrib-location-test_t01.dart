/*
 * Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/** 
 * @description This test ensures WebGL implementations don't allow names that
 * start with 'gl_' when calling bindAttribLocation.
 */
import "dart:html";
import "dart:web_gl" as wgl;
import 'dart:typed_data';
import "../../../testcommon.dart";
import "resources/webgl-test.dart";

main() {
  document.body.setInnerHtml('''
      <div id="console"></div>
      <canvas style="border: 1px solid black;" id="canvas" width="50" height="50"></canvas>
      <script id="vshader" type="text/something-not-javascript">
      attribute vec4 vPosition;
      attribute vec4 vColor;
      varying vec4 color;
      void main()
      {
        gl_Position = vPosition;
        color = vColor;
      }
      </script>
      <script id="fshader" type="text/something-not-javascript">
#ifdef GL_ES
      precision highp float;
#endif
      varying vec4 color;
      void main()
      {
        gl_FragColor = color;
      }
      </script>
      <div>PASS</div>
      ''', treeSanitizer: new NullTreeSanitizer());

  debug("Canvas.getContext");

  var gl = create3DContext(document.getElementById("canvas"));
  shouldBeNonNull(gl);

  fail(x,y, buf, shouldBe) {
    var reason = "pixel at ($x,$y) is ${buf.sublist(0,4)}, should be $shouldBe";
    testFailed(reason);
  }

  pass() {
    testPassed("drawing is correct");
  }

  loadShader(shaderType, shaderId) {
    // Get the shader source.
    var shaderSource = document.getElementById(shaderId).text;

    // Create the shader object
    var shader = gl.createShader(shaderType);
    if (shader == null) {
      debug("*** Error: unable to create shader '"+shaderId+"'");
      return null;
    }

    // Load the shader source
    gl.shaderSource(shader, shaderSource);

    // Compile the shader
    gl.compileShader(shader);

    // Check the compile status
    var compiled = gl.getShaderParameter(shader, wgl.COMPILE_STATUS);
    if (!compiled) {
      // Something went wrong during compilation; get the error
      var error = gl.getShaderInfoLog(shader);
      debug("*** Error compiling shader '"+shader+"':"+error);
      gl.deleteShader(shader);
      return null;
    }
    return shader;
  }

  debug("Checking gl.bindAttribLocation.");

  var program = gl.createProgram();
  gl.bindAttribLocation(program, 0, "gl_foo");
  glErrorShouldBe(gl, wgl.INVALID_OPERATION,
      "bindAttribLocation should return INVALID_OPERATION if name starts with 'gl_'");
  gl.bindAttribLocation(program, 0, "gl_TexCoord0");
  glErrorShouldBe(gl, wgl.INVALID_OPERATION,
      "bindAttribLocation should return INVALID_OPERATION if name starts with 'gl_'");

  var vs = loadShader(wgl.VERTEX_SHADER, "vshader");
  var fs = loadShader(wgl.FRAGMENT_SHADER, "fshader");
  gl.attachShader(program, vs);
  gl.attachShader(program, fs);

  var positions = gl.createBuffer();
  gl.bindBuffer(wgl.ARRAY_BUFFER, positions);
  gl.bufferData(wgl.ARRAY_BUFFER, new Float32List.fromList([ 0.0,0.5,0.0, -0.5,-0.5,0.0, 0.5,-0.5,0.0 ]), wgl.STATIC_DRAW);

  var colors = gl.createBuffer();
  gl.bindBuffer(wgl.ARRAY_BUFFER, colors);
  gl.bufferData(wgl.ARRAY_BUFFER, new Float32List.fromList([
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0,
      0.0,1.0,0.0,1.0]), wgl.STATIC_DRAW);

  setBindLocations(colorLocation, positionLocation) {
    gl.bindAttribLocation(program, positionLocation, "vPosition");
    gl.bindAttribLocation(program, colorLocation, "vColor");
    gl.linkProgram(program);
    gl.useProgram(program);
    var linked = (gl.getProgramParameter(program, wgl.LINK_STATUS) != 0);
    assertMsg(linked, "program linked successfully");

    debug("vPosition: ${gl.getAttribLocation(program, 'vPosition')}");
    debug("vColor   : ${gl.getAttribLocation(program, 'vColor')}");
    assertMsg(gl.getAttribLocation(program, "vPosition") == positionLocation,
        "location of vPositon should be $positionLocation");
    assertMsg(gl.getAttribLocation(program, "vColor") == colorLocation,
        "location of vColor should be $colorLocation");

    gl.bindBuffer(wgl.ARRAY_BUFFER, positions);
    gl.enableVertexAttribArray(positionLocation);
    gl.vertexAttribPointer(positionLocation, 3, wgl.FLOAT, false, 0, 0);
    gl.bindBuffer(wgl.ARRAY_BUFFER, colors);
    gl.enableVertexAttribArray(colorLocation);
    gl.vertexAttribPointer(colorLocation, 4, wgl.FLOAT, false, 0, 0);
  }

  checkDraw(colorLocation, positionLocation, r, g, b, a) {
    gl.clearColor(0, 0, 0, 1);
    gl.clear(wgl.COLOR_BUFFER_BIT | wgl.DEPTH_BUFFER_BIT);
    gl.drawArrays(wgl.TRIANGLES, 0, 3);

    var width = 50;
    var height = 50;
    var buf = new Uint8List(width * height * 4);
    gl.readPixels(0, 0, width, height, wgl.RGBA, wgl.UNSIGNED_BYTE, buf);

    checkPixel(x, y, r, g, b, a) {
      var offset = (y * width + x) * 4;
      if (buf[offset + 0] != r ||
          buf[offset + 1] != g ||
          buf[offset + 2] != b ||
          buf[offset + 3] != a) {
            fail(x, y, buf, [r,g,b,a]);
            return false;
          }
      return true;
    }

    // Test several locations
    // First line should be all black
    var success = true;
    for (var i = 0; i < 50; ++i)
      success = success && checkPixel(i, 0, 0, 0, 0, 255);

    // Line 15 should be red for at least 10 rgba pixels starting 20 pixels in
    for (var i = 0; i < 10; ++i)
      success = success && checkPixel(20 + i, 15, r, g, b, a);

    // Last line should be all black
    for (var i = 0; i < 50; ++i)
      success = success && checkPixel(i, 49, 0, 0, 0, 255);

    if (success)
      pass();

    gl.disableVertexAttribArray(positionLocation);
    gl.disableVertexAttribArray(colorLocation);
  }

  setBindLocations(2, 3);
  checkDraw(2, 3, 0, 255, 0, 255);

  setBindLocations(0, 3);
  gl.disableVertexAttribArray(0);
  gl.vertexAttrib4f(0, 1, 0, 0, 1);
  checkDraw(0, 3, 255, 0, 0, 255);

  glErrorShouldBe(gl, wgl.NO_ERROR);
}