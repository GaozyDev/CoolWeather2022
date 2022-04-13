import 'dart:convert';

import 'package:cool_weather_2022/utils/date_utils.dart';
import 'package:cool_weather_2022/utils/screen_utils.dart';
import 'package:cool_weather_2022/views/weather/base_weather_state.dart';
import 'package:cool_weather_2022/views/weather/empty_bg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'WeatherDetailPage.dart';
import '../bean/focus_district_list_bean.dart';
import '../bean/weather_bean.dart';
import '../data/constant.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// 关注城市列表
  List<District> districtList = [];

  /// PageView 当前页码
  int currentPage = 0;

  /// 当前显示的城市
  District? district;

  /// 当前显示的天气
  WeatherBean? weatherBean;

  final PageController _pageController = PageController();

  String updateTime = '努力加载中';

  /// 屏幕高度
  double? screenHeight;

  /// 系统状态栏高度
  double? statsHeight;

  /// title 栏高度
  double titleHeight = 70;

  /// 是否需要定位
  bool needLocation = true;

  /// 用于局部刷新天气动画
  final GlobalKey<BaseAnimState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _initPageController();
    _initData();
  }

  /// 初始化 PageView Controller
  _initPageController() {
    _pageController.addListener(() {
      int page = (_pageController.page! + 0.5).toInt();
      if (currentPage != page) {
        updatePageNum(page);
      }
    });
  }

  /// 更新当前页码
  /// page 页码
  updatePageNum(int page) {
    setState(() {
      currentPage = page;
      district = districtList.elementAt(page);
    });
    if (district != null) {
      if (district!.weatherBean != null) {
        updateWeatherState(district!.weatherBean!);
      }
      changeAnimAlpha(district!.scrollProgress);
    }
  }

  /// 更新当前界面显示的天气信息
  updateWeatherState(WeatherBean weatherBean) {
    setState(() {
      this.weatherBean = weatherBean;
      updateTime = MyDateUtils.getTimeDesc(weatherBean.server_time) + '更新';
    });
  }

  /// 修改天气动画透明度
  void changeAnimAlpha(double scrollProgress) {
    double progress = 1.0 - scrollProgress / 0.3;
    double alpha = progress >= 0 ? progress : 0;
    if (_globalKey.currentState != null) {
      _globalKey.currentState?.setMaskAlpha(alpha);
    }
  }

  /// 初始化数据
  _initData() async {
    districtList.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Constant.spFocusDistrictData)) {
      districtList = queryDistrictList(prefs);
      if (currentPage == 0) {
        setState(() {
          district = districtList.elementAt(0);
        });
      }
    } else {
      District district = District("", "", '未知', -1, -1, isLocation: true);
      setState(() {
        districtList.add(district);
        this.district = district;
      });
      FocusDistrictListBean focusDistrictListBean =
          FocusDistrictListBean(districtList);
      prefs.setString(
          Constant.spFocusDistrictData, json.encode(focusDistrictListBean));
    }
  }

  /// 查询已关注城市列表及缓存的城市天气数据
  List<District> queryDistrictList(SharedPreferences prefs) {
    List<District> districtList = [];
    String focusDistrictListJson =
        prefs.getString(Constant.spFocusDistrictData)!;
    FocusDistrictListBean focusDistrictListBean =
        FocusDistrictListBean.fromJson(json.decode(focusDistrictListJson));
    districtList.addAll(focusDistrictListBean.districtList);
    for (var district in districtList) {
      String? weatherJson = prefs.getString(district.name);
      if (!isEmpty(weatherJson)) {
        Map<String, dynamic> map = jsonDecode(weatherJson!);
        WeatherBean weatherBean = WeatherBean.fromJson(map);
        district.weatherBean = weatherBean;
      }
    }
    return districtList;
  }

  /// PageView 子页面通知主界面当前天气数据
  setWeatherData(District district, WeatherBean weatherBean) {
    // 当回调的城市信息和 PageView 当前页的城市是同一个，则直接更新天气数据
    // 否则从 _pageController 事件回调中获取天气数据
    if (district == this.district) {
      updateWeatherState(weatherBean);
    }
  }

  /// PageView 子页面回调方法
  setLocation(District district) {
    needLocation = false;
    List<District> list = [];
    list.add(district);
    districtList.replaceRange(0, 1, list);

    if (currentPage == 0) {
      setState(() {
        this.district = district;
      });
    }

    Future<SharedPreferences> future = SharedPreferences.getInstance();
    future.then((prefs) {
      prefs.setString(Constant.spFocusDistrictData,
          json.encode(FocusDistrictListBean(districtList)));
    });
  }

  /// 跳转关注城市列表页
  _focusDistrictList() {
    Navigator.of(context).pushNamed("focus_district_list").then((value) async {
      List<int> params = value as List<int>;
      int status = params[0];
      int page = params[1];
      if (status != 0) {
        await _initData();
        // 删除 && 直接返回
        if (status == -2 && page == -1) {
          // todo 直接返回到第一页，不太友好
          _pageController.jumpToPage(0);
          return;
        }
      }

      if (page != -1) {
        _pageController.jumpToPage(page);
        // PageController 有时不回调，只好手动触发 (ˉ▽ˉ；)...
        updatePageNum(page);
      }
    });
  }

  /// 将天气信息生成卡片分享
  void _share() async {
    if (district != null &&
        district!.latitude != -1 &&
        district!.longitude != -1 &&
        weatherBean != null) {
      String districtName = district!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = ScreenUtils.getScreenHeight(context);
    statsHeight = ScreenUtils.getSysStatsHeight(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: _createLayout(),
      ),
    );
  }

  Widget _createLayout() {
    List<Widget> layoutList = [];

    Widget weatherDetailWidget = Padding(
      padding: EdgeInsets.only(top: statsHeight! + titleHeight),
      child: PageView.builder(
        controller: _pageController,
        itemCount: districtList.length,
        itemBuilder: (BuildContext context, int position) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              double scrollProgress = notification.metrics.pixels /
                  notification.metrics.maxScrollExtent;
              changeAnimAlpha(scrollProgress);
              district?.scrollProgress = scrollProgress;
              return true;
            },
            child: WeatherDetailPage(
                districtList.elementAt(position),
                setLocation,
                setWeatherData,
                screenHeight! -
                    // ListView 内部自动加了一个 paddingTop，此 paddingTop 的值为 statsHeight
                    statsHeight! * 2 -
                    titleHeight,
                needLocation),
          );
        },
      ),
    );

    layoutList.add(_createWeatherAnimWidget());
    layoutList.add(weatherDetailWidget);
    layoutList.add(_createTitleWidget());

    Widget mainLayout = Stack(
      children: layoutList,
    );

    return mainLayout;
  }

  /// 根据天气类型获取天气动画
  Widget _createWeatherAnimWidget() {
    Widget animWidget;
    // if (weatherBean == null) {
    animWidget = EmptyBg();
    // } else {
    //   switch (weatherBean.result.realtime.skycon) {
    //     case 'CLEAR_DAY':
    //       animWidget = SunnyAnim(key: _globalKey);
    //       break;
    //     case 'CLEAR_NIGHT':
    //       animWidget = SunnyNightAnim(key: _globalKey);
    //       break;
    //     case 'PARTLY_CLOUDY_DAY':
    //       animWidget = CloudyAnim(key: _globalKey);
    //       break;
    //     case 'PARTLY_CLOUDY_NIGHT':
    //       animWidget = CloudyNightAnim(key: _globalKey);
    //       break;
    //     case 'CLOUDY':
    //       if (DateUtils.isDay(weatherBean)) {
    //         animWidget = OvercastAnim(key: _globalKey);
    //       } else {
    //         animWidget = OvercastNightAnim(key: _globalKey);
    //       }
    //       break;
    //     case 'RAIN':
    //       animWidget = RainAnim(
    //           weatherBean != null ? DateUtils.isDay(weatherBean) : true,
    //           key: _globalKey);
    //       break;
    //     case 'SNOW':
    //       if (weatherBean != null) {
    //         animWidget = DateUtils.isDay(weatherBean)
    //             ? SnowAnim(key: _globalKey)
    //             : SnowNightAnim(key: _globalKey);
    //       }
    //       break;
    //     case 'HAZE':
    //       animWidget = HazeAnim(
    //           weatherBean != null ? DateUtils.isDay(weatherBean) : true,
    //           key: _globalKey);
    //       break;
    //     default:
    //       animWidget = EmptyBg();
    //   }
    // }

    return animWidget;
  }

  /// 顶部标题栏
  Widget _createTitleWidget() {
    return Padding(
      padding: EdgeInsets.only(top: statsHeight ?? 0),
      child: SizedBox(
        height: titleHeight,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_titleContentLayout(), _titleMenuIconLayout()],
        ),
      ),
    );
  }

  /// 标题栏布局
  Widget _titleContentLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        currentPage == 0
            ? const Padding(
                padding: EdgeInsets.only(left: 22),
                child: ImageIcon(
                  AssetImage("images/ic_location.png"),
                  size: 22,
                  color: Colors.white60,
                ),
              )
            : const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                district != null ? district!.name : '正在定位',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
              Text(
                updateTime,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  decoration: TextDecoration.none,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 标题栏右侧菜单布局
  Widget _titleMenuIconLayout() {
    List<Widget> menuList = [];
//    if(weatherBean.result.realtime.) {
//    menuList.add(IconButton(
//      icon: ImageIcon(
//        AssetImage("images/ic_warning.png"),
//        size: 20,
//        color: Colors.white,
//      ),
//      onPressed: _warning,
//    ));
//    }
    menuList.add(IconButton(
      icon: const ImageIcon(
        AssetImage("images/ic_building.png"),
        size: 20,
        color: Colors.white,
      ),
      onPressed: _focusDistrictList,
    ));
    menuList.add(PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (position) {
        if (position == 0) {
          _share();
        } else if (position == 1) {
          Navigator.of(context).pushNamed("setting");
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem>[
          const PopupMenuItem(
            value: 0,
            child: Text("分享"),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text("设置"),
          )
        ];
      },
    ));
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: menuList,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
