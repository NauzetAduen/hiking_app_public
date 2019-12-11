// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trail _$TrailFromJson(Map<String, dynamic> json) {
  return Trail(
      trailName: json['trailName'] as String,
      userID: json['userID'] as String,
      userName: json['userName'] as String,
      distanceInMeters: (json['distanceInMeters'] as num)?.toDouble(),
      description: json['description'] as String,
      dificulty: json['dificulty'] as int,
      likes: json['likes'] as int,
      markers: json['markers'] as Map<String, dynamic>,
      votesList: (json['votesList'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList(),
      likedBy: (json['likedBy'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$TrailToJson(Trail instance) => <String, dynamic>{
      'trailName': instance.trailName,
      'userID': instance.userID,
      'userName': instance.userName,
      'distanceInMeters': instance.distanceInMeters,
      'description': instance.description,
      'dificulty': instance.dificulty,
      'likes': instance.likes,
      'markers': instance.markers,
      'votesList': instance.votesList,
      'likedBy': instance.likedBy
    };
