import 'package:hasura_connect/hasura_connect.dart';

Future sendPost(double aqi, String geo, String name, String date, double co,
    double no2, double o3, double pm10, double pm25, double so2)async{
  String url = 'https://devportoedu.herokuapp.com/v1/graphql';
  HasuraConnect hasuraConnect = HasuraConnect(url);
  String doc = """
    mutation{
      insert_localizacoes(objects: {aqi: $aqi, geo: $geo, name: $name, date: $date, co: $co, no2: $no2, o3: $o3, pm10: $pm10, pm25: $pm25, so2: $so2}){
        returning {
          id
        }
      }
    }
  """;

  var r = await hasuraConnect.mutation(doc);
}
