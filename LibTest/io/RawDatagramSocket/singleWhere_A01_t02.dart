/*
 * Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Future<T> singleWhere(bool test(T element))
 * Finds the single element in this stream matching test.
 *
 * Like lastWhere, except that it is an error if more than one matching element
 * occurs in the stream.
 *
 * @description Checks that method [singleWhere] returns Future that is filled
 * with (1) the event of this stream, if this event is single event that matches
 * the test, or (2) error otherwise.
 * @author ngl@unipro.ru
 */
import "dart:io";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";

check(test, expected, valueExpected, errorExpected) {
  asyncStart();
  var address = InternetAddress.LOOPBACK_IP_V4;
  RawDatagramSocket.bind(address, 0).then((producer) {
    RawDatagramSocket.bind(address, 0).then((receiver) {
      int sent = 0;
      int counter = 0;
      producer.send([sent++], address, receiver.port);
      producer.send([sent++], address, receiver.port);
      producer.send([sent], address, receiver.port);
      producer.close();

      Stream<RawSocketEvent> bcs = receiver.asBroadcastStream();
      Future fValue = bcs.singleWhere(test);
      fValue.then((value) {
        if (valueExpected) {
          Expect.equals(expected, value);
        } else {
          Expect.fail('Future should be completed with error');
        }
      }).catchError((error) {
        if (errorExpected) {
          Expect.isTrue((error is StateError));
        } else {
          Expect.fail('Future should be completed with event');
        }
      }).whenComplete(() {
        asyncEnd();
      });

      new Timer(const Duration(milliseconds: 200), () {
        Expect.isNull(receiver.receive());
        receiver.close();
      });

      bcs.listen((event) {
        counter++;
        receiver.receive();
      }).onDone(() {
        Expect.equals(4, counter);
      });
    });
  });
}

main() {
  check((e) => e == RawSocketEvent.WRITE, RawSocketEvent.WRITE, true, false);
  check((e) => e == RawSocketEvent.READ, RawSocketEvent.READ, false, true);
  check((e) => e == RawSocketEvent.CLOSED, RawSocketEvent.CLOSED, true, false);
  check((e) => e is RawSocketEvent, RawSocketEvent.WRITE, false, true);
  check((e) => true, RawSocketEvent.WRITE, false, true);
  check((e) => e != RawSocketEvent.WRITE, RawSocketEvent.READ, false, true);
}