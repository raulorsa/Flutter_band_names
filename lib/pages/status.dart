import 'package:band_names/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: SafeArea(
              child: Center(child: Column(children: [
          Text('ServerStatus: ${socketService.serverStatus}'),
        ],),),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.security),
        onPressed: (){
          socketService.socket.emit('nuevo-mensaje', {
            'nombre': 'Flutter',
            'mensaje':'Hola desde Flutter'});
        }
      ),
      
    );
  }
}