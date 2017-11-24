/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion bool autoUncompress
 *  read / write
 *  Get and set whether the body of a response will be automatically
 *  uncompressed.
 *
 *  The body of an HTTP response can be compressed. In most situations providing
 *  the un-compressed body is most convenient. Therefore the default behavior is
 *  to un-compress the body. However in some situations (e.g. implementing a
 *  transparent proxy) keeping the uncompressed stream is required.
 *
 *  NOTE: Headers in from the response is never modified. This means that when
 *  automatic un-compression is turned on the value of the header Content-Length
 *  will reflect the length of the original compressed body. Likewise the header
 *  Content-Encoding will also have the original value indicating compression.
 *
 *  NOTE: Automatic un-compression is only performed if the Content-Encoding
 *  header value is gzip.
 *
 *  This value affects all responses produced by this client after the value is
 *  changed.
 *  To disable, set to false.
 *
 *  Default is true.
 * @description Checks that headers in the response are never modified
 * @author sgrekhov@unipro.ru
 */
import "dart:io";
import "dart:convert";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";

test() async {
  String helloWorld = 'Hello, test world!';
  HttpServer server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 0);
  server.autoCompress = true;

  asyncStart();
  server.listen((HttpRequest request) {
    request.response
      ..headers.set(HttpHeaders.CONTENT_LENGTH, helloWorld.length)
      ..headers.set(HttpHeaders.CONTENT_ENCODING, "utf-8")
      ..write(helloWorld)
      ..close();
    server.close();
    asyncEnd();
  });

  asyncStart();
  HttpClient client = new HttpClient();
  client.autoUncompress = true;
  client
      .getUrl(Uri.parse(
      "http://${InternetAddress.LOOPBACK_IP_V4.address}:${server.port}"))
      .then((HttpClientRequest request) {
    return request.close();
  }).then((HttpClientResponse response) {
    Expect.listEquals([helloWorld.length.toString()],
        response.headers[HttpHeaders.CONTENT_LENGTH]);
    Expect.listEquals(["utf-8"], response.headers[HttpHeaders.CONTENT_ENCODING]);
    response.transform(UTF8.decoder).listen((content) {
      Expect.equals(helloWorld, content);
      asyncEnd();
    });
  });
  asyncEnd();
}

main() {
  asyncStart();
  test();
}
