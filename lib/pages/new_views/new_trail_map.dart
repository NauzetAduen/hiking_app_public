import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiking_app/components/leading_appbar.dart';
import 'package:hiking_app/styles/styles.dart';
import 'package:geolocator/geolocator.dart';

class NewTrailMap extends StatefulWidget {
  @override
  _NewTrailMapState createState() => _NewTrailMapState();
}

class _NewTrailMapState extends State<NewTrailMap> {
  Set<Marker> _markers = Set();
  List<Polyline> _polygons = [];
  List<LatLng> _points = [];
  bool isRecording;
  Timer timer;
  @override
  void initState() {
    super.initState();
    isRecording = false;
    _points = _setMarkerToLatLngList();
    _polygons = <Polyline>[
      Polyline(
        points: _points,
        color: Colors.red,
        polylineId: PolylineId("polyID_1"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LeadingAppbar(Text(
        "Creating Markers",
        style: Styles.appbarTextStyleWithLetterSpacing,
      )),
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
          markers: _markers,
          polylines: Set.from(_polygons),
          onTap: (pos) => _addPos(pos),
        ),
        _buildControls()
      ]),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
  borderRadius: BorderRadius.circular(40.0),
  child:   Container(
            color: Colors.white60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: _getPlayStopIcon(),
                  iconSize: 45,
                  onPressed: () {
                    setState(() {
                      if (isRecording) {
                        setState(() {
                          isRecording = !isRecording;
                        });
                        _stopRecord();
                      } else {
                        setState(() {
                          isRecording = !isRecording;
                        });

                        _record();
                      }
                    });
                  },
                ),
                IconButton(
                    color: Colors.red,
                    icon: _getDeleteIcon(),
                    iconSize: 45,
                    onPressed: () {
                      if (_markers.length > 0) {
                        setState(() {
                          _markers.remove(_markers.last);
                          _points.removeLast();
                        });
                      }
                    }),
                _getFinishIconButton(),
              ],
            ),
          ),
  ),
    );
  }

  Future _record() async {
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) async {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (position != null){
        _addPos(LatLng(position.latitude, position.longitude));
      }

    });
  }

  void _stopRecord() {
    timer.cancel();
  }

  Icon _getPlayStopIcon() {
    if (!isRecording)
      return Icon(
        Icons.play_circle_filled,
        color: Colors.green,
      );
    return Icon(
      Icons.stop,
      color: Colors.red,
    );
  }

  void _addPos(LatLng position) {
    // if (isRecording) {
    setState(() {
      _markers.add(Marker(
          markerId:
              MarkerId("${_markers.length.toString()}-${position.toString()}"),
          position: position));
      _points.add(position);
    });
    // }
  }

  Icon _getDeleteIcon() {
    if (_markers.length > 0) return Icon(Icons.delete);
    return Icon(Icons.delete_forever);
  }

  Widget _getFinishIconButton() {
    if (_markers.length > 0)
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.checkCircle,
        ),
        iconSize: 45,
        color: Colors.blue,
        onPressed: () => _returnData(),
      );
    return SizedBox();
  }

  List<LatLng> _setMarkerToLatLngList() {
    List<LatLng> list = [];
    setState(() => _markers.forEach((marker) =>
        list.add(LatLng(marker.position.latitude, marker.position.longitude))));
    return list;
  }

  _returnData() {
    Navigator.pop(context, _markers);
  }
}
