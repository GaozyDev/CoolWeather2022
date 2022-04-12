// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'focus_district_list_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FocusDistrictListBean _$FocusDistrictListBeanFromJson(
        Map<String, dynamic> json) =>
    FocusDistrictListBean(
      (json['districtList'] as List<dynamic>)
          .map((e) => District.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FocusDistrictListBeanToJson(
        FocusDistrictListBean instance) =>
    <String, dynamic>{
      'districtList': instance.districtList,
    };

District _$DistrictFromJson(Map<String, dynamic> json) => District(
      json['cityCode'] as String,
      json['adCode'] as String,
      json['name'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
      addressDesc: json['addressDesc'] as String? ?? "",
      isLocation: json['isLocation'] as bool? ?? false,
      weatherBean: json['weatherBean'] == null
          ? null
          : WeatherBean.fromJson(json['weatherBean'] as Map<String, dynamic>),
      scrollProgress: (json['scrollProgress'] as num?)?.toDouble() ?? 0,
      level: json['level'] as String? ?? '',
    );

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'cityCode': instance.cityCode,
      'adCode': instance.adCode,
      'name': instance.name,
      'addressDesc': instance.addressDesc,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isLocation': instance.isLocation,
      'level': instance.level,
      'weatherBean': instance.weatherBean,
      'scrollProgress': instance.scrollProgress,
    };
