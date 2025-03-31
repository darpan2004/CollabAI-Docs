 import 'package:collab_ai_docs/clients/socket_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket;
  Socket get socketClient=>_socketClient!;
 void joinRoom(String documentId) {
  print("Attempting to join room: " + documentId);
_socketClient!.onConnect((_) {
  print("✅ Socket connected!");

  // Emit join only after connection
  _socketClient!.emit('join', ["ada"]);
  print("📩 Sent join event");
});

}

 }