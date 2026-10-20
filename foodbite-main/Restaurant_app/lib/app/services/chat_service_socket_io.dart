/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'package:socket_io_client/socket_io_client.dart' as socketclient;
import 'package:vendor/app/env.dart';

class ChatService {
  socketclient.Socket? _socket;
  bool _listenerAttached = false;

  bool get isConnected => _socket?.connected ?? false;

  /// Connect & join room
  void connectToServer(String chatRoomId, Function(dynamic data) onMessage) {
    if (_socket != null && _socket!.connected) return;

    _socket = socketclient.io(Environments.apiBaseURL, socketclient.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('joinRoom', {'chatRoomId': chatRoomId});

      // ✅ attach listener only once
      if (!_listenerAttached) {
        _socket!.on('receiveMessage', onMessage);
        _listenerAttached = true;
      }
    });
  }

  /// Send message safely
  void sendMessage({required String chatRoomId, required String senderId, required String message, required String role, required String randomId, String? firstName, String? lastName, required String cover}) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('sendMessage', {'chatRoomId': chatRoomId, 'senderId': senderId, 'message': message, 'role': role, 'randomId': randomId, 'senderFirstName': firstName, 'senderLastName': lastName, 'senderCover': cover});
  }

  /// Disconnect safely
  void disconnect() {
    if (_socket != null) {
      _socket!.off('receiveMessage');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _listenerAttached = false;
    }
  }
}
