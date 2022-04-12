// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hourly _$HourlyFromJson(Map<String, dynamic> json) => Hourly(
      json['status'] as String,
      json['description'] as String,
      (json['skycon'] as List<dynamic>)
          .map((e) => StringValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['cloudrate'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['aqi'] as List<dynamic>)
          .map((e) => IntValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['dswrf'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['visibility'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['humidity'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pres'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pm25'] as List<dynamic>)
          .map((e) => IntValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['precipitation'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['wind'] as List<dynamic>)
          .map((e) => Wind.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['temperature'] as List<dynamic>)
          .map((e) => DoubleValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
      'status': instance.status,
      'description': instance.description,
      'skycon': instance.skycon,
      'cloudrate': instance.cloudrate,
      'aqi': instance.aqi,
      'dswrf': instance.dswrf,
      'visibility': instance.visibility,
      'humidity': instance.humidity,
      'pres': instance.pres,
      'pm25': instance.pm25,
      'precipitation': instance.precipitation,
      'wind': instance.wind,
      'temperature': instance.temperature,
    };

StringValue _$StringValueFromJson(Map<String, dynamic> json) => StringValue(
      json['value'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$StringValueToJson(StringValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'datetime': instance.datetime,
    };

IntValue _$IntValueFromJson(Map<String, dynamic> json) => IntValue(
      json['value'] as int,
      json['datetime'] as String,
    );

Map<String, dynamic> _$IntValueToJson(IntValue instance) => <String, dynamic>{
      'value': instance.value,
      'datetime': instance.datetime,
    };

DoubleValue _$DoubleValueFromJson(Map<String, dynamic> json) => DoubleValue(
      (json['value'] as num).toDouble(),
      json['datetime'] as String,
    );

Map<String, dynamic> _$DoubleValueToJson(DoubleValue instance) =>
    <String, dynamic>{
      'value': instance.value,
      'datetime': instance.datetime,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      (json['direction'] as num).toDouble(),
      (json['speed'] as num).toDouble(),
      json['datetime'] as String,
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'direction': instance.direction,
      'speed': instance.speed,
      'datetime': instance.datetime,
    };
