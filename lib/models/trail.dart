
import 'package:hiking_app/utils/marker_helper.dart';
import 'package:json_annotation/json_annotation.dart';


 part 'trail.g.dart';

@JsonSerializable()
class Trail {
  String trailName;
  String userID;
  String userName;
  double distanceInMeters;
  String description;
  int dificulty; //Enum
  int likes;
  Map<String, dynamic> markers;
  List<Map<String, dynamic>> votesList;
  List<String> likedBy;

  Trail(
      {
        this.trailName,
      this.userID,
      this.userName,
      this.distanceInMeters,
      this.description,
      this.dificulty,
      this.likes,
      this.markers,
      this.votesList,
      this.likedBy
      });

  Trail.blank()
      : trailName = "",
        userID = "",
        userName = "",
        distanceInMeters = 0.0,
        description = "",
        dificulty = 1,
        likes = 0,
        markers = {},
        votesList = [],
        likedBy = [];


  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);
  Map<String, dynamic> toJson() => _$TrailToJson(this);

  factory Trail.fromJsonWithMap(Map<String, dynamic> json){
      _jsonToListMap(json['votesList']);
      return Trail(
      trailName: json['trailName'] as String,
      userID: json['userID'] as String,
      userName: json['userName'] as String,
      distanceInMeters: (json['distanceInMeters'] as num)?.toDouble(),
      description: json['description'] as String,
      dificulty: json['dificulty'] as int,
      likes: json['likes'] as int,
      markers: MarkerHelper.mapToMap(json['markers']),
      votesList:_jsonToListMap(json['votesList']),
      likedBy: (json['likedBy'] as List)?.map((e) => e as String)?.toList());
  }

  //OBJETIVE = List<Map<String, dynamic>> votesList;
  static List<Map<String, dynamic>> _jsonToListMap(json){
    List x = json as List;

    return x.map((ele){
      Map<String,dynamic> votemap = new Map<String,dynamic>();
      votemap['userId'] = ele['userId'];
      votemap['vote'] = ele['vote'];
      return votemap;
    }).toList();
  }

}
