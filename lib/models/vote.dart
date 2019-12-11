import 'package:json_annotation/json_annotation.dart';

 part 'vote.g.dart';

@JsonSerializable()
class Vote{
  String userId;
  int vote;

  Vote({this.userId,this.vote});

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  Map<String, dynamic> toJson()=> _$VoteToJson(this);

  factory Vote.fromJsonMap(Map<String, dynamic> json){
    return Vote(
      userId: json['userId'],
      vote: json['vote'] 
    );
  }

}