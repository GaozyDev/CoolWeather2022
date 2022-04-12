
import 'package:flutter/cupertino.dart';

import 'bean/focus_district_list_bean.dart';

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

class _WeatherDetailPageState extends State<WeatherDetailPage> with AutomaticKeepAliveClientMixin {

  District district;

  _WeatherDetailPageState(this.district);

  @override
  void initState() {
    super.initState();
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
  bool get wantKeepAlive => true;
}