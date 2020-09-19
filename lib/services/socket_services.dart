

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:flutter/material.dart';

enum ServerStatus{
  OnLine,
  OffLine,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  get serverStatus => this._serverStatus;
  IO.Socket get  socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService(){
    this.initConfig();
  }

  void initConfig(){

    // Dart client
    this._socket = IO.io('http://192.168.1.156:3000/', {
    //IO.Socket socket = IO.io('http://localhost:3000/', {
      'transports': ['websocket'],
      'autoConnect': true,

    });

    this._socket.on('connect', (_){
      print('connect');
      //socket.emit('msg', 'test');
      this._serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    //socket.on('event', (data) => print(data));
    //socket.on('disconnect', ( _ ) => print('disconnect'));
    //socket.on('fromServer', ( _ ) => print(_));

    this._socket.on('disconnect', ( _ ) { 
      print('disconnect');
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });

    this._socket.on('nuevo-mensaje', ( payload ) { 
      this._serverStatus = ServerStatus.OffLine;
      notifyListeners();
    });


  }
}