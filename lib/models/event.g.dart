// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      eventName: json['eventName'] as String,
      description: json['description'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      trailName: json['trailName'] as String,
      creatorID: json['creatorID'] as String,
      creatorName: json['creatorName'] as String,
      participantsList: (json['participantsList'] as List)
          ?.map((e) => e as String)
          ?.toList());
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'eventName': instance.eventName,
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'trailName': instance.trailName,
      'creatorID': instance.creatorID,
      'creatorName': instance.creatorName,
      'participantsList': instance.participantsList
    };
