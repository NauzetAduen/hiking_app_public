
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:latlong/latlong.dart' as prefix0;

class Haversine {
  // implementation of Haversine formula
  // https://en.wikipedia.org/wiki/Haversine_formula

  // static double distanceFromFirstToSecond(LatLng first, LatLng second) {
  //   double firstParentesisPart =
  //       math.pow((math.sin((second.latitude - first.latitude) / 2)), 2);
  //   double midParentesis = math.cos(first.latitude) * math.cos(second.latitude);
  //   double lastParentesisPart =
  //       math.pow((math.sin((second.longitude - first.longitude) / 2)), 2);
  //   double complete = firstParentesisPart + midParentesis * lastParentesisPart;
  //   double total = 2 * math.pi * math.acos(complete);
  //   return (total * 100) / 2;
  // }

  static double calculateDistance(Set<Marker> result) {
    List<Marker> list = result.toList();
    double totalDistance = 0.0;
    for (int i = 0; i < list.length - 1; i++) {
      final Distance d = Distance();
      prefix0.LatLng p1 =
          prefix0.LatLng(list[i].position.latitude, list[i].position.longitude);
      prefix0.LatLng p2 = prefix0.LatLng(
          list[i + 1].position.latitude, list[i + 1].position.longitude);

      final meters = d.as(LengthUnit.Meter, p1, p2);
      totalDistance += meters;
    }
    return totalDistance;
  }
}
