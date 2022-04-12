import 'package:json_annotation/json_annotation.dart';

import 'weather_bean.dart';

part 'focus_district_list_bean.g.dart';

@JsonSerializable()
class FocusDistrictListBean {
  List<District> districtList;

  FocusDistrictListBean(this.districtList);

  factory FocusDistrictListBean.fromJson(Map<String, dynamic> json) =>
      _$FocusDistrictListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$FocusDistrictListBeanToJson(this);
}

@JsonSerializable()
class District {
  String cityCode;
  String adCode;
  String name;
  String addressDesc;
  double latitude;
  double longitude;
  bool isLocation;
  String level;

  WeatherBean? weatherBean;
  double scrollProgress;

  District(this.cityCode, this.adCode, this.name, this.latitude, this.longitude,
      {this.addressDesc = "",
      this.isLocation = false,
      this.weatherBean,
      this.scrollProgress = 0,
      this.level = ''});

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);

  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

/// 区域信息 + 天气信息
class DistrictWeather {
  District district;
  WeatherBean weatherBean;

  DistrictWeather(this.district, this.weatherBean);
}
