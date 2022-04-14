class UnitConvertUtils {
  /// 摄氏度 转 华氏度
  static double celsiusToFahrenheit(double celsius) {
    return celsius * 1.8 + 32;
  }

  /// 千米/小时 转 风力等级
  static String kmhToGrade(double speed) {
    String windSpeedDesc = '';
    if (speed < 1) {
      windSpeedDesc = '0';
    } else if (1 <= speed && speed < 6) {
      windSpeedDesc = '1';
    } else if (6 <= speed && speed < 12) {
      windSpeedDesc = '2';
    } else if (12 <= speed && speed < 20) {
      windSpeedDesc = '3';
    } else if (20 <= speed && speed < 29) {
      windSpeedDesc = '4';
    } else if (29 <= speed && speed < 39) {
      windSpeedDesc = '5';
    } else if (39 <= speed && speed < 50) {
      windSpeedDesc = '6';
    } else if (50 <= speed && speed < 62) {
      windSpeedDesc = '7';
    } else if (62 <= speed && speed < 75) {
      windSpeedDesc = '8';
    } else if (75 <= speed && speed < 89) {
      windSpeedDesc = '9';
    } else if (89 <= speed && speed < 103) {
      windSpeedDesc = '10';
    } else if (103 <= speed && speed < 118) {
      windSpeedDesc = '11';
    } else if (118 <= speed && speed < 134) {
      windSpeedDesc = '12';
    } else if (134 <= speed && speed < 150) {
      windSpeedDesc = '13';
    } else if (150 <= speed && speed < 167) {
      windSpeedDesc = '14';
    } else if (167 <= speed && speed < 184) {
      windSpeedDesc = '15';
    } else if (184 <= speed && speed < 203) {
      windSpeedDesc = '16';
    } else if (203 <= speed && speed < 221) {
      windSpeedDesc = '17';
    } else if (221 <= speed) {
      windSpeedDesc = '17+';
    }
    return windSpeedDesc;
  }

  /// 千米/小时 转 米/秒
  static double kmhToMs(double speed) {
    return speed * 1000 / 60 / 60;
  }

  /// 千米/小时 转 英尺/秒
  static double kmhToFts(double speed) {
    return speed * 3280.8399 / 60 / 60;
  }

  /// 千米/小时 转 英里/小时
  static double kmhToMph(double speed) {
    return speed * 0.621371192;
  }

  /// 千米/小时 转 海里/小时
  static double kmhToKts(double speed) {
    return speed * 0.539956803;
  }

  /// 千米 转 英里
  static double kmToMi(double distance) {
    return distance * 0.621371192;
  }

  /// 帕 转 百帕
  static double paToHpa(double pres) {
    return pres / 100;
  }

  /// 帕 转 毫米汞柱
  static double paToMmHg(double pres) {
    return pres / 133.28;
  }

  /// 帕 转 英寸汞柱
  static double paToInHg(double pres) {
    return pres / 133.28 * 0.0393700787;
  }
}
