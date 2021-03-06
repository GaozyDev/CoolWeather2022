import 'package:cool_weather_2022/data/unit_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/constant.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {
  bool isNotifyOpen = false;

  @override
  void initState() {
    super.initState();
    _initDate();
  }

  void _initDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isNotify = prefs.getBool(Constant.spNotifyOpen) ?? false;
    setState(() {
      isNotifyOpen = isNotify;
    });
  }

  @override
  Widget build(BuildContext context) {
    var unitModel = context.watch<UnitModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('设置'),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _unitRowWidget(
                '温度单位',
                temperatureUnitList.elementAt(unitModel.temperature.index),
                temperatureUnitList,
                // todo 传方法不太好，最好传个 sp 的 key，以下相同
                unitModel.setTemperatureUnit),
          ),
          _unitRowWidget('风力单位', windUnitList.elementAt(unitModel.wind.index),
              windUnitList, unitModel.setWindUnit),
          _unitRowWidget(
              '降水量',
              rainfallUnitList.elementAt(unitModel.rainfall.index),
              rainfallUnitList,
              unitModel.setRainfallUnit),
          _unitRowWidget(
            '能见度',
            visibilityUnitList.elementAt(unitModel.visibility.index),
            visibilityUnitList,
            unitModel.setVisibilityUnit,
          ),
          _unitRowWidget(
            '气压',
            airPressureUnitList.elementAt(unitModel.airPressure.index),
            airPressureUnitList,
            unitModel.setAirPressureUnit,
          ),
          _warnRowWidget(),
          _dividerLayout(),
          _aboutRowWidget(),
          _dividerLayout()
        ],
      ),
    );
  }

  Widget _unitRowWidget(
      String content, Unit unit, List<Unit> unitList, Function setUnit) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: const TextStyle(fontSize: 17),
                ),
                Text(
                  unit.toString(),
                  style: const TextStyle(fontSize: 12.5, color: Colors.grey),
                )
              ],
            ),
          ),
          _dividerLayout()
        ],
      ),
      onTap: () {
        selectUnit(content, unitList, setUnit);
      },
    );
  }

  Widget _warnRowWidget() {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '天气预警',
                  style: TextStyle(fontSize: 17),
                ),
                Text('当出现特殊天气时通知提醒',
                    style: TextStyle(fontSize: 12.5, color: Colors.grey))
              ],
            ),
          ),
          Switch(
              value: isNotifyOpen,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  isNotifyOpen = value;
                  _updateSpData(Constant.spNotifyOpen, isNotifyOpen);
                });
              })
        ],
      ),
      onTap: () {
        setState(() {
          isNotifyOpen = !isNotifyOpen;
          _updateSpData(Constant.spNotifyOpen, isNotifyOpen);
        });
      },
    );
  }

  _updateSpData(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Widget _aboutRowWidget() {
    return InkWell(
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Text(
          '关于',
          style: TextStyle(fontSize: 17),
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed('about');
      },
    );
  }

  Widget _dividerLayout() {
    return Container(
      width: double.infinity,
      height: 0.5,
      color: Colors.grey[300],
    );
  }

  selectUnit(String title, List<Unit> unitList, Function setUnit) async {
    int position = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
            children: getDialogOptionList(unitList),
          );
        });

    setUnit(position);
  }

  List<Widget> getDialogOptionList(List<Unit> unitList) {
    List<Widget> widgetList = [];
    for (int i = 0; i < unitList.length; i++) {
      widgetList.add(SimpleDialogOption(
        onPressed: () {
          Navigator.pop(context, i);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            unitList.elementAt(i).toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ));
    }

    return widgetList;
  }
}
