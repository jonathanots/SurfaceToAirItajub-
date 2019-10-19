import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:surfaceair/models/localModel.dart';
import 'package:surfaceair/models/measureModel.dart';

class Measures{
  
  Future getMeasures()async{
    var url = "https://api.openaq.org/v1/latest?limit=10000";
    List<LocalModel> localList = [];
    
    try{
      var data = await http.get(url);
      var jsonData = json.decode(data.body)["results"];

      for(var r in jsonData){
        if(r["coordinates"]!= null){
          List<MeasureModel> measuresList = [];
          for(var m in r["measurements"]){
            MeasureModel measure = MeasureModel(m["lastUpdated"], m["parameter"], m["sourceName"],
            m["unit"], double.parse(m["value"].toString()));
            measuresList.add(measure);
          }
          
          LocalModel local = LocalModel(
              r["city"], double.parse(r["coordinates"]["latitude"].toString()) , 
              double.parse(r["coordinates"]["longitude"].toString()),
              r["country"], r["location"], measuresList);
          localList.add(local);
        }
      }
    }catch(error){
      print("Error: $error");
    }
    print(localList.length);
    //print(localList[0].measures.length);

  }

}