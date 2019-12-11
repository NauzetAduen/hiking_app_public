import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hiking_app/models/trail.dart';

import 'detailed_views/detailed_trail.dart';

class MapTrailPage extends StatefulWidget {
  @override
  _MapTrailPageState createState() => _MapTrailPageState();
}

class _MapTrailPageState extends State<MapTrailPage> {
  Set<Marker> markers = Set();
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("trails").snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          _createMarkers(snapshot.data.documents);
          return Container(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: _currentMapType,
                  initialCameraPosition:
                      CameraPosition(target: LatLng(0, 0), zoom: 5),
                  markers: markers,
                  polylines: Set.from(
                    [],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: CircleBorder(),
                          onPressed: _changeMapType,
                          child: Icon(FontAwesomeIcons.mapPin),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void _createMarkers(List<DocumentSnapshot> documents) async {
    markers.clear();
    documents.forEach((doc) {
      Trail trail = Trail.fromJsonWithMap(doc.data);
      // setState(() {
      markers.add(Marker(
          markerId: MarkerId("id${doc.documentID}"),
          position: LatLng(
              trail.markers['0']['latitude'], trail.markers['0']['longitude']),
          infoWindow: InfoWindow(
            title: trail.trailName,
            onTap: () {
              setState(() {
                 _navigateTotrail(doc.documentID);
              });
            })));
      // });
    });
  }
  void _navigateTotrail(String documentID){
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => DetailedTrail(documentID)));
  }

  void _changeMapType() {
    if (_currentMapType == MapType.normal)
      _currentMapType = MapType.hybrid;
    else if (_currentMapType == MapType.hybrid)
      _currentMapType = MapType.satellite;
    else if (_currentMapType == MapType.satellite)
      _currentMapType = MapType.terrain;
    else if (_currentMapType == MapType.terrain)
      _currentMapType = MapType.normal;
    setState(() => null);
  }
}
