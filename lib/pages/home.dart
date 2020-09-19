import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '1', name: 'Héroes del Silencio', votes: 8),
    Band(id: '1', name: 'Queen', votes: 5),
    Band(id: '1', name: 'Bon Jovi', votes: 4),
  ];


  @override
  void initState() { 
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands); 
    
     

    super.initState();
    
  }

 _handleActiveBands(dynamic payload){
 this.bands = (payload as List)
        .map((band) => Band.fromMap(band) )
        .toList();
        
        setState(() {});
  }
 
  

  @override
  void dispose() {
    // TODO: implement dispose
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);


    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
      elevation: 1,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 10),
          child: (socketService.serverStatus == ServerStatus.OnLine)? 
          Icon(Icons.check_circle, color: Colors.blue[300]):
          Icon(Icons.offline_bolt, color: Colors.red[300])
        ),
      ],
      title: Text('BandNames', style: TextStyle(color: Colors.black87)),),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i){
        return _bandTile(bands[i]);
      }),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed:() => addNewBand(),
        ),
      
      
      
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
  
  Dismissible(
    direction: DismissDirection.startToEnd,
    background: Container(
      padding: EdgeInsets.only(left: 8),
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text('Delete Band', style: TextStyle(color: Colors.white))),
      ),
      onDismissed: (direction){
        socketService.emit('delete-band', {'id' : band.id});
      },
      key: Key(band.id),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text ( band.name),
          trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
          onTap: (){
            socketService.socket.emit('vote-band', {'id': band.id});
            print(band.name);
          },
        ),
  );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if (Platform.isAndroid) {
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
        title: Text('New band name:'),
        content: TextField(
          controller: textController,
          ),
        actions: [
          MaterialButton(
            child: Text('Add'), 
            elevation: 5,
            textColor: Colors.blue,
            onPressed: (){
              addBandToList(textController.text);
          })
        ],
      );
    },
    );
    } else {


    showCupertinoDialog(context: context, builder: (_){
      return CupertinoAlertDialog(
        title: Text('New band name:'),
        content: CupertinoTextField(
          controller: textController,),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text),),

              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text ('Dismiss'),
                onPressed:() => Navigator.pop(context)
                )
          ],
      );
    });
    }
  }
  


  void addBandToList( String name){
    if (name.length >1){
      //this.bands.add( new Band(id: DateTime.now().toString(), name: name, votes: 0));

      //emitir: add-band
      //{name}

      final socketService = Provider.of<SocketService>(context, listen: false);

      socketService.socket.emit('add-band', {'name': name});
    }

    setState(() {
      
    });

    Navigator.pop(context);
  }

}