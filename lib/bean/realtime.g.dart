// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Realtime _$RealtimeFromJson(Map<String, dynamic> json) => Realtime(
      json['status'] as String,
      (json['o3'] as num).toDouble(),
      (json['co'] as num).toDouble(),
      (json['temperature'] as num).toDouble(),
      (json['pm10'] as num).toDouble(),
      json['skycon'] as String,
      (json['cloudrate'] as num).toDouble(),
      Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
      (json['dswrf'] as num).toDouble(),
      (json['visibility'] as num).toDouble(),
      (json['humidity'] as num).toDouble(),
      (json['so2'] as num).toDouble(),
      Ultraviolet.fromJson(json['ultraviolet'] as Map<String, dynamic>),
      (json['pres'] as num).toDouble(),
      json['aqi'] as int,
      json['pm25'] as int,
      (json['no2'] as num).toDouble(),
      (json['apparent_temperature'] as num).toDouble(),
      Comfort.fromJson(json['comfort'] as Map<String, dynamic>),
      Wind.fromJson(json['wind'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RealtimeToJson(Realtime instance) => <String, dynamic>{
      'status': instance.status,
      'o3': instance.o3,
      'co': instance.co,
      'temperature': instance.temperature,
      'pm10': instance.pm10,
      'skycon': instance.skycon,
      'cloudrate': instance.cloudrate,
      'precipitation': instance.precipitation,
      'dswrf': instance.dswrf,
      'visibility': instance.visibility,
      'humidity': instance.humidity,
      'so2': instance.so2,
      'ultraviolet': instance.ultraviolet,
      'pres': instance.pres,
      'aqi': instance.aqi,
      'pm25': instance.pm25,
      'no2': instance.no2,
      'apparent_temperature': instance.apparent_temperature,
      'comfort': instance.comfort,
      'wind': instance.wind,
    };

Precipitation _$PrecipitationFromJson(Map<String, dynamic> json) =>
    Precipitation(
      Nearest.fromJson(json['nearest'] as Map<String, dynamic>),
      Local.fromJson(json['local'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrecipitationToJson(Precipitation instance) =>
    <String, dynamic>{
      'nearest': instance.nearest,
      'local': instance.local,
    };

Nearest _$NearestFromJson(Map<String, dynamic> json) => Nearest(
      json['status'] as String,
      (json['distance'] as num).toDouble(),
      (json['intensity'] as num).toDouble(),
    );

Map<String, dynamic> _$NearestToJson(Nearest instance) => <String, dynamic>{
      'status': instance.status,
      'distance': instance.distance,
      'intensity': instance.intensity,
    };

Local _$LocalFromJson(Map<String, dynamic> json) => Local(
      json['status'] as String,
      (json['intensity'] as num).toDouble(),
      json['datasource'] as String,
    );

Map<String, dynamic> _$LocalToJson(Local instance) => <String, dynamic>{
      'status': instance.status,
      'intensity': instance.intensity,
      'datasource': instance.datasource,
    };

Ultraviolet _$UltravioletFromJson(Map<String, dynamic> json) => Ultraviolet(
      (json['index'] as num).toDouble(),
      json['desc'] as String,
    );

Map<String, dynamic> _$UltravioletToJson(Ultraviolet instance) =>
    <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
    };

Comfort _$ComfortFromJson(Map<String, dynamic> json) => Comfort(
      json['index'] as int,
      json['desc'] as String,
    );

Map<String, dynamic> _$ComfortToJson(Comfort instance) => <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      (json['direction'] as num).toDouble(),
      (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'direction': instance.direction,
      'speed': instance.speed,
    };
