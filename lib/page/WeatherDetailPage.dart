import 'dart:async';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bean/daily.dart';
import '../bean/focus_district_list_bean.dart';
import '../bean/hourly.dart';
import '../bean/minutely.dart';
import '../bean/realtime.dart';
import '../bean/weather_bean.dart';
import '../views/temp_line.dart';

/// 天气详情信息 Tab 页
class WeatherDetailPage extends StatefulWidget {
  final District district;

  /// 通过此方法可通知主界面天气数据
  final Function setWeatherData;

  /// 通过此方法可通知主界面定位数据
  final Function setLocation;

  final double height;

  final bool needLocation;

  const WeatherDetailPage(this.district, this.setLocation, this.setWeatherData,
      this.height, this.needLocation);

  @override
  State<StatefulWidget> createState() {
    return _WeatherDetailPageState(district);
  }
}

class _WeatherDetailPageState extends State<WeatherDetailPage>
    with AutomaticKeepAliveClientMixin {
  /// 日出日落标记
  final double sunriseTag = -1001;
  final double sunsetTag = 1001;

  double screenWidth = 0;

  District district;

  WeatherBean? weatherBean;

  Result? result;

  /// 实时天气数据
  Realtime? realtime;

  /// 分钟天气数据
  Minutely? minutely;

  /// 小时天气数据
  Hourly? hourly;

  /// 每日天气数据
  Daily? daily;

  /// 气温折线图使用
  List<Temp> dayTempList = [];

  AMapFlutterLocation? _locationPlugin;

  StreamSubscription<Map<String, Object>>? _locationListener;

  _WeatherDetailPageState(this.district);

  @override
  void initState() {
    super.initState();

    // 是当前定位区域且需要定位一次
    if (district.isLocation && widget.needLocation) {
      _checkPermission();
    } else {
      // _queryWeather(district);
    }
  }

  /// 检查APP是否具有定位权限
  void _checkPermission() async {
    // 检查位置服务是否打开
    if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
      // 检查定位权限是否授权
      PermissionStatus permissionStatus = await Permission.location.request();
      if (permissionStatus.isDenied) {
        // 申请定位权限
        Map<Permission, PermissionStatus> statuses = await [
          Permission.location,
        ].request();
        permissionStatus =
            statuses[Permission.location] ?? PermissionStatus.denied;
      }

      if (permissionStatus == PermissionStatus.granted) {
        _initLocation();
      } else {
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "为了更好的为您提供本地天气服务，请给予定位权限，然后重启APP",
        );
        await openAppSettings();
      }
    } else {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_LONG,
        msg: "为了更好的为您提供本地天气服务，请打开位置服务，然后重启APP",
      );
    }
  }

  /// 获取定位信息
  _initLocation() {
    AMapFlutterLocation.updatePrivacyShow(true, true);
    AMapFlutterLocation.updatePrivacyAgree(true);
    AMapFlutterLocation.setApiKey(
        "2711cbe26c75b312eb9bc3921cb5ffd0", "iOS Key");

    _locationPlugin = AMapFlutterLocation();
    _locationListener = _locationPlugin!
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      String cityCode = result["cityCode"] as String;
      String adCode = result["adCode"] as String;
      String districtName = result["district"] as String;
      double latitude = result["latitude"] as double;
      double longitude = result["longitude"] as double;
      district = District(cityCode, adCode,
          districtName, latitude, longitude,
          isLocation: true);

      widget.setLocation(district);
      // _queryWeather(district);
    });

    AMapLocationOption locationOption = AMapLocationOption();
    locationOption.onceLocation = true;
    locationOption.needAddress = true;
    locationOption.geoLanguage = GeoLanguage.DEFAULT;
    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;
    _locationPlugin!.setLocationOption(locationOption);
    _locationPlugin!.startLocation();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return weatherDetailLayout(context);
  }

  Widget weatherDetailLayout(BuildContext context) {
    return Text(district.name);
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener?.cancel();
    _locationPlugin?.destroy();
  }

  @override
  bool get wantKeepAlive => true;
}
