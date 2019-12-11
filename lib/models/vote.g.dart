// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote(userId: json['userId'] as String, vote: json['vote'] as int);
}

Map<String, dynamic> _$VoteToJson(Vote instance) =>
    <String, dynamic>{'userId': instance.userId, 'vote': instance.vote};
