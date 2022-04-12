// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minutely.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minutely _$MinutelyFromJson(Map<String, dynamic> json) => Minutely(
      json['status'] as String,
      json['description'] as String,
      (json['probability'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      json['datasource'] as String,
      (json['precipitation_2h'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      (json['precipitation'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$MinutelyToJson(Minutely instance) => <String, dynamic>{
      'status': instance.status,
      'description': instance.description,
      'probability': instance.probability,
      'datasource': instance.datasource,
      'precipitation_2h': instance.precipitation_2h,
      'precipitation': instance.precipitation,
    };
