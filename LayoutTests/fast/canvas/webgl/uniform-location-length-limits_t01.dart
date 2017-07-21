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
import "resources/webgl-test-utils.dart" as wtu;

main() {
  document.body.setInnerHtml('''
      <canvas id="example" width="50" height="50">
      There is supposed to be an example drawing here, but it's not important.
      </canvas>
      <div id="description">Verify limits on the lengths of uniform locations.</div>
      <div id="console"></div>
      <script id="goodVertexShader1" type="x-shader/x-vertex">
      // A vertex shader where the uniform name is long, but well below the limit.
      struct Nesting2 {
          vec4 identifier62CharactersLong_01234567890123456789012345678901234;
      };

      struct Nesting1 {
          Nesting2 identifier64CharactersLong_0123456789012345678901234567890123456;
      };

      uniform Nesting1 identifier70CharactersLong_01234567890123456789012345678901234567890;

      void main() {
          gl_Position = identifier70CharactersLong_01234567890123456789012345678901234567890.identifier64CharactersLong_0123456789012345678901234567890123456.identifier62CharactersLong_01234567890123456789012345678901234;
      }
      </script>
      <script id="goodVertexShader2" type="x-shader/x-vertex">
      // A vertex shader where the needed uniform location is exactly 256 characters.
      struct Nesting2 {
          vec4 identifier62CharactersLong_01234567890123456789012345678901234;
      };

      struct Nesting1 {
          Nesting2 identifier64CharactersLong_0123456789012345678901234567890123456;
      };

      uniform Nesting1 identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789;

      void main() {
          gl_Position = identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.identifier64CharactersLong_0123456789012345678901234567890123456.identifier62CharactersLong_01234567890123456789012345678901234;
      }
      </script>
      <script id="badVertexShader" type="x-shader/x-vertex">
      // A vertex shader where the needed uniform location is 257 characters.
      struct Nesting2 {
          vec4 identifier63CharactersLong_012345678901234567890123456789012345;
      };

      struct Nesting1 {
          Nesting2 identifier64CharactersLong_0123456789012345678901234567890123456;
      };

      uniform Nesting1 identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789;

      void main() {
          Nesting2 temp = identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.identifier64CharactersLong_0123456789012345678901234567890123456;
          gl_Position = temp.identifier63CharactersLong_012345678901234567890123456789012345;
      }
      </script>
      <script id="fragmentShader" type="x-shader/x-fragment">
      precision mediump float;

      void main() {
          gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
      }
      </script>
      ''', treeSanitizer: new NullTreeSanitizer());

  var gl = wtu.create3DContext(document.getElementById("example"));

  debug("Test uniform location underneath the length limit");
  var program = wtu.loadProgramFromScript(gl, "goodVertexShader1", "fragmentShader");
  shouldBe(gl.getProgramParameter(program, wgl.LINK_STATUS), true);
  var uniformLoc = gl.getUniformLocation(program, "identifier70CharactersLong_01234567890123456789012345678901234567890.identifier64CharactersLong_0123456789012345678901234567890123456.identifier62CharactersLong_01234567890123456789012345678901234");
  shouldBeNonNull(uniformLoc);
  wtu.glErrorShouldBe(gl, wgl.NONE);

  debug("Test uniform location exactly at the length limit");
  program = wtu.loadProgramFromScript(gl, "goodVertexShader2", "fragmentShader");
  shouldBe(gl.getProgramParameter(program, wgl.LINK_STATUS), true);
  uniformLoc = gl.getUniformLocation(program, "identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.identifier64CharactersLong_0123456789012345678901234567890123456.identifier62CharactersLong_01234567890123456789012345678901234");
  shouldBeNonNull(uniformLoc);
  wtu.glErrorShouldBe(gl, wgl.NONE);

  debug("Test uniform location over the length limit");
  program = wtu.loadProgramFromScript(gl, "badVertexShader", "fragmentShader");
  wtu.glErrorShouldBe(gl, wgl.NONE);
  shouldBe(gl.getProgramParameter(program, wgl.LINK_STATUS), true);
  uniformLoc = gl.getUniformLocation(program, "identifier128CharactersLong_0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789.identifier64CharactersLong_0123456789012345678901234567890123456.identifier63CharactersLong_012345678901234567890123456789012345");
  wtu.glErrorShouldBe(gl, wgl.INVALID_VALUE);
  shouldBeNull(uniformLoc);
}