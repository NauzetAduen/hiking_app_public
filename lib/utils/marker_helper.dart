import 'dart:collection';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerHelper{

  static Map<String,dynamic> setToMap(Set<Marker> markersList){
    Map<String, dynamic> map = {};
    int index = 0;
    markersList.forEach((marker){
      map['$index'] = {
        'latitude' : marker.position.latitude,
        'longitude':  marker.position.longitude
        };
      index++;
    });
    return map;
  }

  //OBJETIVE =  Map<String, dynamic> markers;
  static Map<String,dynamic> mapToMap(Map<dynamic, dynamic> json){
    Map<String, dynamic> map = HashMap();
    json.forEach((a,b){
       map['$a'] = b;
    });
    return map;
  }
}