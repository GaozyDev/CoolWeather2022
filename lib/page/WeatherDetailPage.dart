import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bean/daily.dart';
import '../bean/focus_district_list_bean.dart';
import '../bean/hourly.dart';
import '../bean/minutely.dart';
import '../bean/realtime.dart';
import '../bean/weather_bean.dart';
import '../data/global.dart';
import '../data/unit_model.dart';
import '../utils/date_utils.dart';
import '../utils/image_utils.dart';
import '../utils/screen_utils.dart';
import '../utils/translation_utils.dart';
import '../utils/unit_convert_utils.dart';
import '../views/rainfall_line.dart';
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
      _queryWeather(district);
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
      district = District(cityCode, adCode, districtName, latitude, longitude,
          isLocation: true);

      widget.setLocation(district);
      _queryWeather(district);
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
    screenWidth = ScreenUtils.getScreenWidth(context);

    return weatherDetailLayout(context);
  }

  Widget weatherDetailLayout(BuildContext context) {
    if (weatherBean != null) {
      return Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color.fromARGB(255, 51, 181, 229))),
        child: RefreshIndicator(
          onRefresh: () => _queryWeather(district, force: true),
          child: Theme(
            data: Theme.of(context).copyWith(
                colorScheme:
                    ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
            child: ListView(
              children: [
                SizedBox(
                  height: widget.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _mainInfoLayout(),
                  ),
                ),
                _tempLineLayout(),
                _moreForecastLayout(),
                _dividerLayout(edgeInsets: const EdgeInsets.only(top: 20)),
                _hourlyForecastLayout(),
                _dividerLayout(),
                _moreInfLayout(),
                _dataFromLayout()
              ],
            ),
          ),
        ),
      );
    }
    return const Center();
  }

  /// 主要天气信息布局（当前气温，天气，提醒，以及未来6天天气）
  List<Widget> _mainInfoLayout() {
    List<Widget> list = [];
    list.add(_tempLayout());
    list.add(_weatherLayout());
    list.add(_tipsLayout());

    if (minutely == null) {
      return list;
    }

    // 如果未来两小时有雨，则显示降雨趋势图
    for (int i = 0; i < minutely!.precipitation_2h.length; i++) {
      if (minutely!.precipitation_2h.elementAt(i) > 0) {
        list.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: RainfallLine(
              ScreenUtils.getScreenWidth(context), minutely!.precipitation_2h),
        ));
        break;
      }
    }

    list.add(_forecastLayout());
    return list;
  }

  /// 当前气温
  Widget _tempLayout() {
    return Consumer<UnitModel>(
      builder: (context, unitModel, _) {
        double temperature = realtime?.temperature ?? 0;
        if (unitModel.temperature == TemperatureUnit.fahrenheit) {
          temperature = UnitConvertUtils.celsiusToFahrenheit(temperature);
        }
        return Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '${temperature.toStringAsFixed(0)}${temperatureUnitList.elementAt(unitModel.temperature.index).unitShow}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  /// 当前天气
  Widget _weatherLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            Translation.getWeatherDesc(
                realtime!.skycon, realtime!.precipitation.local.intensity),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          )
        ],
      ),
    );
  }

  /// 温馨提示
  Widget _tipsLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            result!.forecast_keypoint,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                decoration: TextDecoration.none),
          )
        ],
      ),
    );
  }

  /// 未来6天天气预报
  Widget _forecastLayout() {
    List<Widget> forecastRow = [];
    for (int i = 0; i < 6; i++) {
      Skycon skycon = daily!.skycon.elementAt(i);
      double intensity = daily!.precipitation.elementAt(i).max;
      DateTime dateTime = DateTime.parse(skycon.date);
      ImageIcon weatherIcon = _getWeatherIcon(skycon.value);

      forecastRow.add(SizedBox(
        width: screenWidth / 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _textLayout(MyDateUtils.getWhichDay(dateTime.weekday - 1)),
            _textLayout('${dateTime.month}' '月' '${dateTime.day}' '日'),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 2),
              child: weatherIcon,
            ),
            _textLayout(Translation.getWeatherDesc(skycon.value, intensity)),
          ],
        ),
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: forecastRow,
      ),
    );
  }

  Widget _textLayout(String content) {
    return Text(content,
        style: const TextStyle(color: Colors.white, fontSize: 13));
  }

  ImageIcon _getWeatherIcon(String weather) {
    return ImageIcon(
      AssetImage(ImageUtils.getWeatherIconUri(weather)),
      size: 22,
      color: Colors.white,
    );
  }

  /// 气温折线图
  Widget _tempLineLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: TempLine(screenWidth, dayTempList),
    );
  }

  /// 未来15天天气预报
  Widget _moreForecastLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Center(
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 25)),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            side: MaterialStateProperty.all(
                const BorderSide(color: Colors.white30)),
            overlayColor: MaterialStateProperty.all(Colors.white30),
            splashFactory: InkRipple.splashFactory,
          ),
          child: const Text(
            '15天天气预报',
            style: TextStyle(fontSize: 14, color: Colors.white54),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("more_day_forecast",
                arguments: weatherBean!.result.daily);
          },
        ),
      ),
    );
  }

  /// 小时预报
  Widget _hourlyForecastLayout() {
    // 使用ListView
    return SizedBox(
      height: 100,
      width: screenWidth,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 返回true，阻止滚动事件继续向上冒泡，避免和主界面的上下滑动产生冲突
          return true;
        },
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hourly!.skycon.length,
            itemBuilder: (BuildContext context, int position) {
              ImageIcon weatherIcon =
                  _getWeatherIcon(hourly!.skycon.elementAt(position).value);
              String desc;
              double temp = hourly!.temperature.elementAt(position).value;
              if (temp == sunriseTag) {
                desc = '日出';
              } else if (temp == sunsetTag) {
                desc = '日落';
              } else {
                desc = temp.toStringAsFixed(0) + '°';
              }

              return SizedBox(
                width: screenWidth / 6.5,
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    children: <Widget>[
                      Text(
                          MyDateUtils.getFormatTimeHHmm(
                              hourly!.skycon.elementAt(position).datetime),
                          style:
                              TextStyle(color: Colors.white54, fontSize: 14)),
                      Padding(
                        padding: EdgeInsets.only(top: 7, bottom: 7),
                        child: weatherIcon,
                      ),
                      Text(desc,
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 14)),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  /// 更多信息，空气质量，风向风速，紫外线等...
  Widget _moreInfLayout() {
    // todo 可以使用 GridView 替换
    return Consumer<UnitModel>(
      builder: (context, unitModel, _) {
        double temperature = realtime!.temperature;
        if (unitModel.temperature == TemperatureUnit.fahrenheit) {
          temperature = UnitConvertUtils.celsiusToFahrenheit(temperature);
        }

        double windSpeed = realtime!.wind.speed;
        String windSpeedDesc;
        // 如果风力单位是"级"，则单位显示在主内容上
        String windUnit = '';

        if (unitModel.wind == WindUnit.grade) {
          windSpeedDesc = UnitConvertUtils.kmhToGrade(windSpeed) +
              windUnitList.elementAt(unitModel.wind.index).unitEN;
        } else {
          if (unitModel.wind == WindUnit.m_s) {
            windSpeed = UnitConvertUtils.kmhToMs(windSpeed);
          } else if (unitModel.wind == WindUnit.ft_s) {
            windSpeed = UnitConvertUtils.kmhToFts(windSpeed);
          } else if (unitModel.wind == WindUnit.mph) {
            windSpeed = UnitConvertUtils.kmhToMph(windSpeed);
          } else if (unitModel.wind == WindUnit.kts) {
            windSpeed = UnitConvertUtils.kmhToKts(windSpeed);
          }
          windSpeedDesc = windSpeed.toStringAsFixed(1);
          windUnit = windUnitList.elementAt(unitModel.wind.index).unitEN;
        }

        double visibility = realtime!.visibility;
        if (unitModel.visibility == VisibilityUnit.mi) {
          visibility = UnitConvertUtils.kmToMi(visibility);
        }

        double pres = realtime!.pres;
        if (unitModel.airPressure == AirPressureUnit.hPa) {
          pres = UnitConvertUtils.paToHpa(pres);
        } else if (unitModel.airPressure == AirPressureUnit.mmHg) {
          pres = UnitConvertUtils.paToMmHg(pres);
        } else if (unitModel.airPressure == AirPressureUnit.inHg) {
          pres = UnitConvertUtils.paToInHg(pres);
        }

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: <Widget>[
                        getWidget(
                            '空气质量', Translation.getAqiDesc(realtime!.aqi), ''),
                        getWidget('PM2.5', realtime!.pm25.toString(), ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      children: <Widget>[
                        getWidget(
                            Translation.getWindDir(realtime!.wind.direction),
                            windSpeedDesc,
                            windUnit),
                        getWidget(
                            '体感温度',
                            temperature.toStringAsFixed(0) +
                                temperatureUnitList
                                    .elementAt(unitModel.temperature.index)
                                    .unitShow,
                            ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      children: <Widget>[
                        getWidget(
                            '湿度',
                            (realtime!.humidity * 100 + 0.5).toInt().toString(),
                            '%'),
                        getWidget(
                            '能见度',
                            visibility.toStringAsFixed(1),
                            visibilityUnitList
                                .elementAt(unitModel.visibility.index)
                                .unitEN),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      children: <Widget>[
                        getWidget('紫外线', realtime!.ultraviolet.desc, ''),
                        getWidget(
                            '气压',
                            pres.toStringAsFixed(0),
                            airPressureUnitList
                                .elementAt(unitModel.airPressure.index)
                                .unitEN),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget getWidget(String title, String value, String unit) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              )),
          Padding(
            padding: EdgeInsets.only(top: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(unit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 分割线
  Widget _dividerLayout({EdgeInsets edgeInsets = const EdgeInsets.all(0)}) {
    return Padding(
      padding: edgeInsets,
      child: const Divider(
        thickness: 1,
        color: Colors.white12,
      ),
    );
  }

  /// 数据来源声明
  Widget _dataFromLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              '天气数据来源于彩云天气网',
              style: TextStyle(color: Colors.white24, fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  /// 查询天气信息
  Future<void> _queryWeather(District district, {bool force = false}) async {
    WeatherBean? weatherBean;
    if (!force) {
      weatherBean = district.weatherBean;
      if (weatherBean != null &&
          MyDateUtils.currentTimeMillis() - weatherBean.server_time * 1000 >
              1000 * 60 * 15) {
        weatherBean = null;
      }
    }

    if (weatherBean == null) {
      double longitude = district.longitude;
      double latitude = district.latitude;
      String url = 'https://api.caiyunapp.com/v2/' +
          Global.caiYunKey +
          '/$longitude,$latitude/' +
          'weather.json?dailysteps=15&unit=metric:v1';
      if (kDebugMode) {
        print(url);
      }
      var httpClient = HttpClient();
      try {
        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();
        if (response.statusCode == HttpStatus.ok) {
          String json = await response.transform(utf8.decoder).join();
          Map<String, dynamic> map = jsonDecode(json);
          weatherBean = WeatherBean.fromJson(map);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(district.name, json);
        }
      } catch (ignore) {
        // ignore
      }
    }

    if (weatherBean == null) {
      return;
    }

    weatherBean = _processData(weatherBean);

    setState(() {
      this.weatherBean = weatherBean;
      this.district.weatherBean = weatherBean;
      result = weatherBean?.result;
      realtime = result?.realtime;
      minutely = result?.minutely;
      hourly = result?.hourly;
      daily = result?.daily;
      widget.setWeatherData(district, weatherBean);
    });
  }

  /// 提前对数据进行处理，避免卡顿
  WeatherBean _processData(WeatherBean weatherBean) {
    Hourly hourly = weatherBean.result.hourly;
    Daily daily = weatherBean.result.daily;

    // 小时天气（包含日出日落时间）
    List<StringValue> hourSkyconList = hourly.skycon;
    List<DoubleValue> hourTempList = hourly.temperature;

    // 当前小时天气最小最大时间
    DateTime minDateTime = DateTime.parse(hourly.skycon.elementAt(0).datetime);
    DateTime maxDateTime = DateTime.parse(
        hourly.skycon.elementAt(hourly.skycon.length - 1).datetime);

    // 如果日出日落时间点在上面的 minDateTime 和 maxDateTime 之间，
    // 则将日出日落时间点添加到小时天气时间点上
    daily.astro.forEach((day) {
      String sunriseString = day.date + ' ' + day.sunrise.time;
      DateTime sunrise = DateTime.parse(sunriseString);
      if (sunrise.compareTo(minDateTime) >= 0 &&
          sunrise.compareTo(maxDateTime) <= 0) {
        hourSkyconList.add(StringValue("SUNRISE", sunriseString));
        hourTempList.add(DoubleValue(sunriseTag, sunriseString));
      }

      String sunsetString = day.date + ' ' + day.sunset.time;
      DateTime sunset = DateTime.parse(sunsetString);
      if (sunset.compareTo(minDateTime) >= 0 &&
          sunset.compareTo(maxDateTime) <= 0) {
        hourSkyconList.add(StringValue("SUNSET", sunsetString));
        hourTempList.add(DoubleValue(sunsetTag, sunsetString));
      }
    });

    // 对小时天气按时间点进行排序
    hourSkyconList.sort((skycon1, skycon2) {
      return DateTime.parse(skycon1.datetime)
          .compareTo(DateTime.parse(skycon2.datetime));
    });
    hourTempList.sort((temp1, temp2) {
      return DateTime.parse(temp1.datetime)
          .compareTo(DateTime.parse(temp2.datetime));
    });

    // 6天天气
    var forecast = daily.temperature;
    dayTempList.clear();
    for (int i = 0; i < 6; i++) {
      dayTempList
          .add(Temp(forecast.elementAt(i).max, forecast.elementAt(i).min));
    }

    return weatherBean;
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
