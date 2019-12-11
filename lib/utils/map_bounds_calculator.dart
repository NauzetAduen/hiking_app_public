import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBoundsCalculator{

  static LatLngBounds boundsCalculator(List<LatLng> points){
    double maxLatitud = points[0].latitude;
    double maxLongitude = points[0].longitude;
    double minLatitud = points[0].latitude;
    double minLongitude = points[0].longitude;

    for (var i = 1; i < points.length; i++) {
      if(points[i].latitude > maxLatitud) maxLatitud = points[i].latitude;
      else if (points[i].latitude < minLatitud) minLatitud = points[i].latitude;
      
      if(points[i].longitude > maxLongitude) maxLongitude = points[i].longitude;
      else if (points[i].longitude < minLongitude) minLongitude = points[i].longitude;
      
    }
    LatLng ne = LatLng(maxLatitud, maxLongitude);
    LatLng sw = LatLng(minLatitud, minLongitude);
    LatLngBounds bounds = LatLngBounds(northeast: ne, southwest: sw);
    return bounds;

  }
}