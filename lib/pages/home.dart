import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:surfaceair/models/localModel.dart';
import 'dart:async';

import 'package:surfaceair/repository/measures.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<LocalModel> resultList = [];

  Completer<GoogleMapController> _controller = Completer();
   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  

  void _initialize()async{
    Measures measure = Measures();
    var result =  await measure.getMeasures();
    setState(() {
      resultList = result; 
    });
    print(resultList.length);
    for(var ans in resultList){
      _add(ans.latitude, ans.longitude, ans.city);
    }
    CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(resultList.last.latitude, resultList.last.longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: Set<Marker>.of(markers.values),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          RaisedButton(
            onPressed: ()=>Navigator.pushNamed(context, '/test'),
            color: Colors.black,
            child: Text("dsnauidbsauibdsai"),
          )
      
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }


  void _add(double lat, double long, String id) {
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(title: markerIdVal),
      onTap: () {},
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }
}