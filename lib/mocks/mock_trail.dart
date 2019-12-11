// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hiking_app/models/trail.dart';
// import 'package:hiking_app/models/vote.dart';
// import 'package:hiking_app/utils/marker_helper.dart';


// class MockTrail extends Trail {
//   static final String nauzetId = "v8QT3Pn3bLbLVgNIduS5GLDPNpW2";
//   static final List<Trail> mockTrailList = [
//     Trail(
//         trailName: "Casa a Médico",
//         userID: nauzetId,
//         userName: "Nauzet",
//         distanceInMeters: 2.0,
//         description: "una locura cuesta abajo.",
//         dificulty: 3,
//         likes: 25,
//         // markers: ([
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_1"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_2"),
//         //     draggable: false,
//         //     position: LatLng(28.107807,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_3"),
//         //     draggable: false,
//         //     position: LatLng(28.107854,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_4"),
//         //     draggable: false,
//         //     position: LatLng(28.108743,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_5"),
//         //     draggable: false,
//         //     position: LatLng(28.108677,-15.428825)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_6"),
//         //     draggable: false,
//         //     position: LatLng(28.108109,-15.427881)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_7"),
//         //     draggable: false,
//         //     position: LatLng(28.106435,-15.428061)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_8"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         // ]),
//         likedBy: [nauzetId],
//         votesList: [
//           Vote(userId: nauzetId, vote: 5).toJson(),
//         ]
//     ),
//     Trail(
//         trailName: "Circular de nosedonde",
//         userID: nauzetId,
//         userName: "Nauzet",
//         distanceInMeters: 2.0,
//         description: "una locura cuesta abajo.",
//         dificulty: 3,
//         likes: 25,
//         // markers: ([
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_1"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_2"),
//         //     draggable: false,
//         //     position: LatLng(28.107807,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_3"),
//         //     draggable: false,
//         //     position: LatLng(28.107854,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_4"),
//         //     draggable: false,
//         //     position: LatLng(28.108743,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_5"),
//         //     draggable: false,
//         //     position: LatLng(28.108677,-15.428825)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_6"),
//         //     draggable: false,
//         //     position: LatLng(28.108109,-15.427881)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_7"),
//         //     draggable: false,
//         //     position: LatLng(28.106435,-15.428061)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_8"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         // ]),
//         likedBy: [nauzetId],
//         votesList: [
//           Vote(userId: nauzetId, vote: 4).toJson(),
//         ]),
//     Trail(
//         trailName: "Paseo de Las Canteras",
//         distanceInMeters: 1.3,
//         userID: nauzetId,
//         userName: "Nauzet",
//         description: "Paseo de Las Canteras. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam vulputate massa convallis diam tristique bibendum. Fusce eget nulla a justo imperdiet gravida. Fusce quis erat at ante feugiat accumsan. Aenean interdum elit sed ornare venenatis. Duis bibendum in tortor vitae. ",
//         dificulty: 2,
//         likes: 40,
//         // markers: ([
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_1"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_2"),
//         //     draggable: false,
//         //     position: LatLng(28.107807,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_3"),
//         //     draggable: false,
//         //     position: LatLng(28.107854,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_4"),
//         //     draggable: false,
//         //     position: LatLng(28.108743,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_5"),
//         //     draggable: false,
//         //     position: LatLng(28.108677,-15.428825)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_6"),
//         //     draggable: false,
//         //     position: LatLng(28.108109,-15.427881)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_7"),
//         //     draggable: false,
//         //     position: LatLng(28.106435,-15.428061)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_8"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         // ]),
//         likedBy: [nauzetId],
//         votesList: [
//           Vote(userId: nauzetId, vote: 5).toJson(),
//         ]),
//     Trail(
//         trailName: "Parque de las rehoyas",
//         userID: "Francisco",
//         distanceInMeters: 2.4,
//         description: "Una vueltita al parque no hace daño",
//         dificulty: 1,
//         likes: 13,
//         // markers: ([
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_1"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_2"),
//         //     draggable: false,
//         //     position: LatLng(28.107807,-15.430005)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_3"),
//         //     draggable: false,
//         //     position: LatLng(28.107854,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_4"),
//         //     draggable: false,
//         //     position: LatLng(28.108743,-15.431227)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_5"),
//         //     draggable: false,
//         //     position: LatLng(28.108677,-15.428825)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_6"),
//         //     draggable: false,
//         //     position: LatLng(28.108109,-15.427881)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_7"),
//         //     draggable: false,
//         //     position: LatLng(28.106435,-15.428061)
//         //   )).toJson(),
//         //   MarkerHelper.toPosition(Marker(
//         //     markerId: MarkerId("parque_8"),
//         //     draggable: false,
//         //     position: LatLng(28.106766,-15.430005)
//         //   )).toJson(),
//         // ])
//         ),
//   ];

//   static Trail fetchFirst() {
//     return MockTrail.mockTrailList[0];
//   }

//   static List<Trail> fetchAll() {
//     return MockTrail.mockTrailList;
//   }
// }
