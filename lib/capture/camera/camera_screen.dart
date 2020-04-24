import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gtd/capture/capture_bloc.dart';
import 'package:gtd/capture/capture_event.dart';
import 'package:gtd/core/core_blocs/navigator_bloc.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String fileName = '${DateTime.now()}.png';

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, elevation: 0, title: Text('Adjunta una imagen'),),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              fileName,
            );

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path, fileName: fileName),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String fileName;

  const DisplayPictureScreen({Key key, this.imagePath, this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    File imageFile = File(imagePath);
    Image thumbnail = Image.file(imageFile);

    return Scaffold(
      appBar: AppBar(title: Text('Adjuntamos esta imagen?'), backgroundColor: Colors.orange,),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(children: <Widget>[
        thumbnail,
        SizedBox(height: 20,),
        RaisedButton(
          padding: EdgeInsets.only(top: 20, bottom: 20, left: 100, right: 100),
          color: Colors.orange,
          onPressed: () {
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
            BlocProvider.of<NavigatorBloc>(context).add(NavigatorActionPop());
            BlocProvider.of<CaptureBloc>(context).add(AttachImage(takenImage: thumbnail, fileName: fileName, imageFile: imageFile));
          },
          child: Text('Adjuntar imagen', style: TextStyle(color: Colors.white),),
        )
      ],)
    );
  }
}