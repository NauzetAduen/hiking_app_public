import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';
@JsonSerializable()
class Event{
  String eventName;
  String description;
  DateTime date;
  String trailName;
  String creatorID;
  String creatorName;
  List<String> participantsList;

  Event({this.eventName,this.description, this.date,this.trailName, this.creatorID,this.creatorName, this.participantsList});

  Event.blank() :
  eventName = "",
  description = "",
  date = DateTime.now(),
  creatorID = "",
  creatorName = "",
  participantsList = [];


   factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
   Map<String, dynamic> toJson() => _$EventToJson(this);

}