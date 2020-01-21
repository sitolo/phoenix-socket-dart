import 'dart:async';

import 'package:phoenix_socket/phoenix_socket.dart';
import 'package:uuid/uuid.dart';

main() async {
  final socket1 = PhoenixSocket("ws://localhost:4000/socket/websocket");
  await socket1.connect();
  var channel1 = socket1.addChannel(topic: "channel3");
  await channel1.join().future;
  var uuid = Uuid().v4();

  channel1.push("ping", {'from': uuid});

  await for (var message in channel1.messages) {
    if (message.event != 'pong' || message.payload['from'] == uuid) continue;
    print("received ${message.event} from ${message.payload['from']}");
    Timer(Duration(seconds: 1), () {
      channel1.push("ping", {'from': uuid});
    });
  }
}
