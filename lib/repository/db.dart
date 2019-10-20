import 'package:hasura_connect/hasura_connect.dart';

Future sendPost(double aqi, double latitude, double longitude, String name, String date, double co,
    double no2, double o3, double pm10, double pm25, double so2)async{
  String url = 'https://devportoedu.herokuapp.com/v1/graphql';
  HasuraConnect hasuraConnect = HasuraConnect(url);
  /*String doc = """
    mutation {
      addlocalizacoes( localizacoes :{aqi: $aqi, latitude: $latitude, longitude: $longitude, 
      name: $name, date: $date, co: $co, no2: $no2, o3: $o3, pm10: $pm10, pm25: $pm25, so2: $so2}){
        {
          id
        }
      }
    }
  """;*/

  String docMutation = """
    mutation Add(\$aqi: double!, \$latitude: double!,\$longitude: double!, \$name: String!,
      \$date: String!, \$co: double!, \$no2: double!, \$o3: double!, \$pm10: double!, \$pm25: double!,
      \$so2: double!){
      insert_localizacoes(objects: {aqi: \$aqi, latitude: \$latitude, longitude: \$longitude, 
      name: \$name, date: \$date, co: \$co, no2: \$no2, o3: \$o3, pm10: \$pm10, pm25: \$pm25, so2: \$so2}) 
      {
        affected_rows
      }
    }
  """;

  await hasuraConnect.mutation(docMutation);
}
