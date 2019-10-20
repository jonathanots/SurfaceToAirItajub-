import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:surfaceair/repository/db.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
   const FirstPage({Key key}) : super(key: key);
}

class _FirstPageState extends State<FirstPage> {

  final _formKey = GlobalKey<FormState>();

  /*
   * FormField Controller 
  */

  TextEditingController aqi = TextEditingController();
  TextEditingController lat = TextEditingController();
  TextEditingController long = TextEditingController();
  TextEditingController nameCity = TextEditingController();
  TextEditingController co = TextEditingController();
  TextEditingController no2 = TextEditingController();
  TextEditingController o3 = TextEditingController();
  TextEditingController pm10 = TextEditingController();
  TextEditingController pm25 = TextEditingController();
  TextEditingController so2 = TextEditingController();
  var date = new MaskedTextController(mask: '00/00/0000');
  var time = new MaskedTextController(mask: '00:00:00:00');


  /*
  * text mask
  */
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
               height: MediaQuery.of(context).size.height*0.885,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  containerFlexible(nameCity, "Name city", "",TextInputType.text, aqi, "AQI", "",TextInputType.number),
                  containerFlexible(date, "Date", "dd/mm/yyyy",TextInputType.number, time, "Time", "00:00:00:00",TextInputType.number),
                  containerFlexible(lat, "Lat", "",TextInputType.number, long, "Long", "",TextInputType.number),
                  containerFlexible(co, "CO", "",TextInputType.number, no2, "NO2", "",TextInputType.number),
                  containerFlexible(o3, "O3", "",TextInputType.number, so2, "SO2", "",TextInputType.number),
                  containerFlexible(pm10, "pm10", "",TextInputType.number, pm25, "pm25", "",TextInputType.number),
                  Divider(color: Colors.transparent),
                  Center(
                    child: RaisedButton(
                      color: Colors.cyan,
                      textColor: Colors.white,
                      child: Text("Submit"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      onPressed: ()async{
                        if(_formKey.currentState.validate()){
                          await sendPost(double.parse(aqi.text), double.parse(lat.text), 
                          double.parse(long.text), nameCity.text, "${date.text} ${time.text}", 
                          double.parse(co.text), double.parse(no2.text), double.parse(o3.text), 
                          double.parse(pm10.text), double.parse(pm25.text), double.parse(so2.text));
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ),
    );
  }


  Widget containerFlexible(TextEditingController tecFirst, String labelNameFisrt, String hintFisrt,TextInputType keyboardTypeFisrt,
  TextEditingController tecSecond, String labelNameSecond, String hintSecond,TextInputType keyboardTypeSecond){
   return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child:textFormField(tecFirst, labelNameFisrt,hintFisrt,keyboardTypeFisrt),
            ),
            SizedBox(width: 20.0,),
            Flexible(
              child:textFormField(tecSecond, labelNameSecond, hintSecond,keyboardTypeSecond),
            ),
          ],
        );
  }

  Widget textFormField(TextEditingController tec, String labelName, String hint,TextInputType keyboardType){
    return TextFormField(
      controller: tec,
      decoration: InputDecoration(labelText: labelName,hintText: hint),
      keyboardType: keyboardType,
      validator: (value){
        if(value.isEmpty) return "Campo não pode ser vazio!";
      },
    );
  }
}