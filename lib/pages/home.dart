import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:surfaceair/models/localModel.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:surfaceair/repository/measures.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  
    const HomePage({Key key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  var geolocator = Geolocator();
  Position uLocation;
  List<LocalModel> resultList = [];
  TextEditingController _locationController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(38.883056, -77.016389),
    zoom: 15,
  );


  void _initialize()async{
    Measures measure = Measures();
    var result =  await measure.getMeasures();
    setState(() {
      resultList = result; 
    });
    print(resultList.length);
    int i = 0;
    for(var ans in resultList){
      i += 1;
      _add(ans.latitude, ans.longitude, i.toString());
    }

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: new Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height*0.765,
                        width: MediaQuery.of(context).size.width,
                        child: GoogleMap(
                          scrollGesturesEnabled: true,
                          rotateGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: Set<Marker>.of(markers.values),
                          mapType: MapType.normal,
                          initialCameraPosition: _initialPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height*0.075,
                        right: 20,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height*0.09,
                          width: MediaQuery.of(context).size.width*0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _locationController,
                                  style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Gibson",
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.normal),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    labelText: "Local",
                                    labelStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    ],
                  ),
                  Visibility(
                    visible: true,
                    maintainSize: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(child: Text("Ruad dsanudisabdsa dsadsa",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: (){},
                      color: Colors.cyan,
                      child: Container(child: Text("SELECIONAR", 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0
                        ),
                      )),
                      ),
                    )
                  )
                ],
              ),
            ),
        
          ], 
        ),
      ),
    );
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


  void _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    setState(() {
      uLocation = currentLocation;
      _initialPosition = CameraPosition(
      target: LatLng(uLocation.latitude, uLocation.longitude),
      zoom: 15,
      );
    });
  }
}