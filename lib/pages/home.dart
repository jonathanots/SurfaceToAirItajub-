import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:surfaceair/models/cityModel.dart';
import 'package:surfaceair/models/localModel.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:surfaceair/repository/city.dart';

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
  String localName = '';

  Completer<GoogleMapController> _controller = Completer();
   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(38.883056, -77.016389),
    zoom: 15,
  );


  void _initialize()async{
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

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
  }

  @override
  void initState() {
    super.initState();
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
                          tiltGesturesEnabled: true,
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
                            borderRadius: BorderRadius.circular(10),
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
                                  cursorWidth: 2,
                                  cursorRadius: Radius.zero,
                                  onSubmitted: (value){
                                    _searchPlace(value);
                                  },
                                  style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Gibson",
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.normal),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.search),
                                    alignLabelWithHint: true,
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
                        Positioned(
                          bottom: MediaQuery.of(context).size.height*0.02,
                          right: MediaQuery.of(context).size.width*0.25,
                          child: IconButton(
                            tooltip: "Informações",
                            icon: Icon(Icons.info, color: Colors.blue, size: 40),
                            onPressed: (){
                              dialogInfo(context);
                            },
                          ),
                        )
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
                          Flexible(child: Text(localName != '' ? localName : "Nenhum local encontrado. ",
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
                      onPressed: (){
                        _searchPlace(_locationController.text);
                      },
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

  void _searchPlace(String word)async{
    markers.clear();
    City city = City();
    CityModel result = await city.getCity(word);
    if(result != null){
      setState(() {
        localName = result.city;
      });
      _add(result);
    }
    else{
      setState(() {
        localName = '';
      });
      dialogError(context);
    }
  }

  void _add(CityModel city) {
    double lat = city.lat;
    double long = city.long;
    String id = city.aqi;
    var markerIdVal = id;
    final MarkerId markerId = MarkerId(markerIdVal);

    print("$lat, $long");

    var bitmap;
    double aqi = double.parse(id);
    if(aqi <= 50)
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
    else if(aqi <= 100)
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    else if(aqi <= 150)
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    else if(aqi <= 200)
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    else if(aqi <= 300)
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    else 
      bitmap = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat, long),
      icon: bitmap,
      infoWindow: InfoWindow(title: " Índice da qualidade do ar: $markerIdVal"),
      onTap: () {
        dialogDetails(context, city);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
    Position pos = Position(latitude: city.lat, longitude: city.long);
    moveToPlace(pos);
  }

  void moveToPlace(Position _place)async{
    CameraPosition _placePosition = CameraPosition(
    target: LatLng(_place.latitude, _place.longitude),
    zoom: 13.3,
    tilt: 18,
  );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_placePosition));
  }

  void dialogError(context){
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Desculpe, mas ainda não possuimos dados desse local.", textAlign: TextAlign.justify,),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.cyan,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            child: Text("Voltar"),
          )
        ],
      )
    );
  }

  void dialogDetails(context, CityModel city){
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Local: ${city.city}", textAlign: TextAlign.justify,),
        titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
        content: Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Table(
                border: TableBorder.all(),
                columnWidths: {1: FractionColumnWidth(.5)},
                defaultColumnWidth: FlexColumnWidth(10),
                defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                children: [
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.075,
                        child: Text("Poluentes", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.075,
                        child: Text("Concentração", textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("MP10", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.pm10}", textAlign: TextAlign.center,)),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("MP2.5", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.pm25}", textAlign: TextAlign.center,)),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("O3", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.o3}", textAlign: TextAlign.center,)),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("CO", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.co}", textAlign: TextAlign.center,)),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("NO2", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.no2}", textAlign: TextAlign.center,)),
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("SO2", textAlign: TextAlign.center,)),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: Text("${city.so2}", textAlign: TextAlign.center,)),
                    ]
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.cyan,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            child: Text("Voltar"),
          ) 
        ],
      )
    );
  }

  void dialogInfo(context){
    showDialog(
      context: context,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Informações:", textAlign: TextAlign.center,),
        titleTextStyle: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
        content: Container(
          height: MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Marcador verde informa que a qualidade do ar é ótima.", 
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.green),
                    ),
                    Text("Marcador amarelo informa que a qualidade do ar é boa.", 
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.yellow),
                    ),
                    Text("Marcador vermelho informa que a qualidade do ar é ruim.", 
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.red),
                    ),
                    Text("Marcador violeta informa que a qualidade do ar é muito ruim.", 
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.purple),
                    ),
                    Text("Marcador rosa informa que a qualidade do ar é muito perigosa.", 
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.pink),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.cyan,
            textColor: Colors.white,
            onPressed: () => Navigator.pop(context),
            child: Text("Voltar"),
          ) 
        ],
      )
    );
  }
}