import { Injectable } from '@angular/core';
import { io, Socket } from 'socket.io-client';
import { environment } from 'src/environments/environment';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ChatService {
  private socket!: Socket;
  constructor() { }

  connectToServer(chatRoomId: string) {
    // Connect to the server
    this.socket = io(environment.apiUrl, {
      transports: ['websocket'],
      autoConnect: false,
    });

    this.socket.connect();

    // Join the chat room
    this.socket.emit('joinRoom', { chatRoomId });

    // // Listen for messages
    // this.socket.on('receiveMessage', (data: any) => {
    //   console.log('Message received: ', data.message);
    // });
  }

  sendMessage(chatRoomId: string, senderId: string, message: string, randomId: string, firstName: string, lastName: string, cover: string) {
    const authRole = localStorage.getItem('_authRole')
    this.socket.emit('sendMessage', {
      chatRoomId,
      senderId,
      message,
      authRole,
      randomId,
      'senderFirstName': firstName,
      'senderLastName': lastName,
      'senderCover': cover
    });
  }

  receiveMessage(): Observable<any> {
    return new Observable((observer) => {
      this.socket.on('receiveMessage', (data: any) => {
        observer.next(data);
      });
    });
  }

  // Disconnect
  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
    }
  }
}
