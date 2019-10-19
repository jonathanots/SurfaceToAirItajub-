import 'package:surfaceair/models/measureModel.dart';

class LocalModel{
  final String city;
  final double latitude;
  final double longitude;
  final String country;
  final String location;
  final List<MeasureModel> measures;

  LocalModel(this.city, this.latitude, this.longitude, this.country, 
          this.location, this.measures);
}