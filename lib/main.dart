import 'package:barcode_scan/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste Camera"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Escanear código de barras',
              ),
              onPressed: () async {
                var _cameras = await availableCameras();

                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(camera: _cameras[0],) ));
                if (result?.toString().isNotEmpty){
                  showDialog(context: this.context,child: AlertDialog(
                    title: Text("Conteudo do codigo de barras:"),
                      content: Text(result),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
