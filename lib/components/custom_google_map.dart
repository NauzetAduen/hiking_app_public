import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget{
  final List<Polyline> _polygons;
  final LatLng startPosition;
  final List<Marker> _markers;
  final double zoom;

  CustomGoogleMap(this._polygons, this._markers, this.startPosition, this.zoom);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      polylines: Set.from(_polygons),
      markers: Set.from(_markers),
      initialCameraPosition: CameraPosition(target: startPosition, zoom: zoom),
      gestureRecognizers: Set()
        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
        ..add(Factory<VerticalDragGestureRecognizer>(
            () => VerticalDragGestureRecognizer())),
    );
  }

}