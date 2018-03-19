/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Future<bool> any(bool test(T element))
 * Checks whether test accepts any element provided by this stream.
 * . . .
 * If the stream ends without finding an element that test accepts, the returned
 * future is completed with false.
 *
 * @description Checks that method any returns false when writeEventsEnabled is
 * true and RawSocketEvent.READ_CLOSED is searched. In this case the listening
 * to the stream is stopped after the last received event.
 * @issue 31881
 * @author ngl@unipro.ru
 */
import "dart:async";
import "dart:io";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";

main() {
  var expectedEvent = RawSocketEvent.READ_CLOSED;
  asyncStart();
  var address = InternetAddress.LOOPBACK_IP_V4;
  RawDatagramSocket.bind(address, 0).then((producer) {
    RawDatagramSocket.bind(address, 0).then((receiver) {
      receiver.writeEventsEnabled = true;
      int sent = 0;
      int count = 0;

      new Timer.periodic(const Duration(microseconds: 1), (timer) {
        producer.send([sent], address, receiver.port);
        sent++;
        if (sent > 3) {
          timer.cancel();
          producer.close();
          receiver.close();
        }
      });

      bool test(x) {
        count++;
        if (count > 4) {
          Expect.fail('count = $count. It should not be more then 4.');
        }
        return x == expectedEvent;
      }

      receiver.any((event) => test(event)).then((value) {
        Expect.equals(false, value);
        Expect.equals(4, count);
      }).whenComplete(() {
        asyncEnd();
      });
    });
  });
}