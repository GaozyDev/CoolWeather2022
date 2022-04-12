// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherBean _$WeatherBeanFromJson(Map<String, dynamic> json) => WeatherBean(
      json['status'] as String,
      json['lang'] as String,
      json['server_time'] as int,
      json['api_status'] as String,
      json['tzshift'] as int,
      json['api_version'] as String,
      json['unit'] as String,
      Result.fromJson(json['result'] as Map<String, dynamic>),
      (json['location'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$WeatherBeanToJson(WeatherBean instance) =>
    <String, dynamic>{
      'status': instance.status,
      'lang': instance.lang,
      'server_time': instance.server_time,
      'api_status': instance.api_status,
      'tzshift': instance.tzshift,
      'api_version': instance.api_version,
      'unit': instance.unit,
      'result': instance.result,
      'location': instance.location,
    };

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      json['forecast_keypoint'] as String,
      json['primary'] as int,
      Realtime.fromJson(json['realtime'] as Map<String, dynamic>),
      Minutely.fromJson(json['minutely'] as Map<String, dynamic>),
      Hourly.fromJson(json['hourly'] as Map<String, dynamic>),
      Daily.fromJson(json['daily'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'forecast_keypoint': instance.forecast_keypoint,
      'primary': instance.primary,
      'realtime': instance.realtime,
      'minutely': instance.minutely,
      'hourly': instance.hourly,
      'daily': instance.daily,
    };
