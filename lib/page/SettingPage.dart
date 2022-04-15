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
