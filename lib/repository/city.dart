import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:surfaceair/models/cityModel.dart';

class City{
  

  Future<CityModel> getCity(String searchCity)async{
    var url = "https://api.waqi.info/feed/$searchCity/?token=03fcdc059eac1ef98f25cc7c679f92b10848ca10";
    

      var data = await http.get(url);
      var jsonData = json.decode(data.body);
      
      if(jsonData["status"] != "error"){
        jsonData = jsonData["data"];
        double _lat, _long;
        int i = 0;
        for(var c in jsonData["city"]["geo"]){
          if(i == 0){
            _lat = c;
          }else{
            _long = c;
          }
          i++;
        }
        CityModel city = CityModel(jsonData["aqi"].toString(), jsonData["city"]["name"], 
        _lat, _long, 
        double.parse(jsonData["iaqi"]["co"]["v"].toString()),
        double.parse(jsonData["iaqi"]["no2"]["v"].toString()), 
        double.parse(jsonData["iaqi"]["o3"]["v"].toString()), 
        double.parse(jsonData["iaqi"]["pm10"]["v"].toString()), 
        double.parse(jsonData["iaqi"]["pm25"]["v"].toString()), 
        double.parse(jsonData["iaqi"]["so2"]["v"].toString()));

        return city;
      }else{
        return null;
      }
  }

}