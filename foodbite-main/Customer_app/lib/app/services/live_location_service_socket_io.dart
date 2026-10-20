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
import 'package:user/app/env.dart';

class LiveLocationServiceSocket {
  socketclient.Socket? _socket;
  bool _listenerAttached = false;

  bool get isConnected => _socket?.connected ?? false;

  void connectToServer(String driverId, Function(dynamic data) onLocation) {
    if (_socket != null && _socket!.connected) return;

    _socket = socketclient.io(Environments.apiBaseURL, socketclient.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build());

    _socket!.connect();

    _socket!.onConnect((_) {
      _socket!.emit('joinLiveLocation', {'driverId': driverId});

      // ✅ Attach listener ONLY ONCE
      if (!_listenerAttached) {
        _socket!.on('receiveLocation', onLocation);
        _listenerAttached = true;
      }
    });
  }

  void sendLocation(String driverId, double latitude, double longitude) {
    if (_socket == null || !_socket!.connected) return;

    _socket!.emit('sendLocation', {'driverId': driverId, 'latitude': latitude, 'longitude': longitude});
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.off('receiveLocation');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _listenerAttached = false;
    }
  }
}
