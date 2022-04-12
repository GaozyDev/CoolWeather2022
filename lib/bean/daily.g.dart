// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      json['status'] as String,
      (json['comfort'] as List<dynamic>)
          .map((e) => Comfort.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['skycon_20h_32h'] as List<dynamic>)
          .map((e) => Skycon_20h_32h.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['temperature'] as List<dynamic>)
          .map((e) => Temperature.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['dswrf'] as List<dynamic>)
          .map((e) => Dswrf.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['cloudrate'] as List<dynamic>)
          .map((e) => Cloudrate.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['aqi'] as List<dynamic>)
          .map((e) => Aqi.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['skycon'] as List<dynamic>)
          .map((e) => Skycon.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['visibility'] as List<dynamic>)
          .map((e) => Visibility.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['humidity'] as List<dynamic>)
          .map((e) => Humidity.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['astro'] as List<dynamic>)
          .map((e) => Astro.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['coldRisk'] as List<dynamic>)
          .map((e) => ColdRisk.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['ultraviolet'] as List<dynamic>)
          .map((e) => Ultraviolet.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pm25'] as List<dynamic>)
          .map((e) => Pm25.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['dressing'] as List<dynamic>)
          .map((e) => Dressing.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['carWashing'] as List<dynamic>)
          .map((e) => CarWashing.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['precipitation'] as List<dynamic>)
          .map((e) => Precipitation.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['wind'] as List<dynamic>)
          .map((e) => Wind.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['skycon_08h_20h'] as List<dynamic>)
          .map((e) => Skycon_08h_20h.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'status': instance.status,
      'comfort': instance.comfort,
      'skycon_20h_32h': instance.skycon_20h_32h,
      'temperature': instance.temperature,
      'dswrf': instance.dswrf,
      'cloudrate': instance.cloudrate,
      'aqi': instance.aqi,
      'skycon': instance.skycon,
      'visibility': instance.visibility,
      'humidity': instance.humidity,
      'astro': instance.astro,
      'coldRisk': instance.coldRisk,
      'ultraviolet': instance.ultraviolet,
      'pm25': instance.pm25,
      'dressing': instance.dressing,
      'carWashing': instance.carWashing,
      'precipitation': instance.precipitation,
      'wind': instance.wind,
      'skycon_08h_20h': instance.skycon_08h_20h,
    };

Comfort _$ComfortFromJson(Map<String, dynamic> json) => Comfort(
      json['index'] as String,
      json['desc'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$ComfortToJson(Comfort instance) => <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
      'datetime': instance.datetime,
    };

Skycon_20h_32h _$Skycon_20h_32hFromJson(Map<String, dynamic> json) =>
    Skycon_20h_32h(
      json['date'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$Skycon_20h_32hToJson(Skycon_20h_32h instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$TemperatureToJson(Temperature instance) =>
    <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Dswrf _$DswrfFromJson(Map<String, dynamic> json) => Dswrf(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$DswrfToJson(Dswrf instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Cloudrate _$CloudrateFromJson(Map<String, dynamic> json) => Cloudrate(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$CloudrateToJson(Cloudrate instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Aqi _$AqiFromJson(Map<String, dynamic> json) => Aqi(
      json['date'] as String,
      json['max'] as int,
      (json['avg'] as num).toDouble(),
      json['min'] as int,
    );

Map<String, dynamic> _$AqiToJson(Aqi instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Skycon _$SkyconFromJson(Map<String, dynamic> json) => Skycon(
      json['date'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$SkyconToJson(Skycon instance) => <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };

Visibility _$VisibilityFromJson(Map<String, dynamic> json) => Visibility(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$VisibilityToJson(Visibility instance) =>
    <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Humidity _$HumidityFromJson(Map<String, dynamic> json) => Humidity(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$HumidityToJson(Humidity instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Astro _$AstroFromJson(Map<String, dynamic> json) => Astro(
      json['date'] as String,
      Sunset.fromJson(json['sunset'] as Map<String, dynamic>),
      Sunrise.fromJson(json['sunrise'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AstroToJson(Astro instance) => <String, dynamic>{
      'date': instance.date,
      'sunset': instance.sunset,
      'sunrise': instance.sunrise,
    };

Sunset _$SunsetFromJson(Map<String, dynamic> json) => Sunset(
      json['time'] as String,
    );

Map<String, dynamic> _$SunsetToJson(Sunset instance) => <String, dynamic>{
      'time': instance.time,
    };

Sunrise _$SunriseFromJson(Map<String, dynamic> json) => Sunrise(
      json['time'] as String,
    );

Map<String, dynamic> _$SunriseToJson(Sunrise instance) => <String, dynamic>{
      'time': instance.time,
    };

ColdRisk _$ColdRiskFromJson(Map<String, dynamic> json) => ColdRisk(
      json['index'] as String,
      json['desc'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$ColdRiskToJson(ColdRisk instance) => <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
      'datetime': instance.datetime,
    };

Ultraviolet _$UltravioletFromJson(Map<String, dynamic> json) => Ultraviolet(
      json['index'] as String,
      json['desc'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$UltravioletToJson(Ultraviolet instance) =>
    <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
      'datetime': instance.datetime,
    };

Pres _$PresFromJson(Map<String, dynamic> json) => Pres(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$PresToJson(Pres instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Pm25 _$Pm25FromJson(Map<String, dynamic> json) => Pm25(
      json['date'] as String,
      json['max'] as int,
      (json['avg'] as num).toDouble(),
      json['min'] as int,
    );

Map<String, dynamic> _$Pm25ToJson(Pm25 instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Dressing _$DressingFromJson(Map<String, dynamic> json) => Dressing(
      json['index'] as String,
      json['desc'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$DressingToJson(Dressing instance) => <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
      'datetime': instance.datetime,
    };

CarWashing _$CarWashingFromJson(Map<String, dynamic> json) => CarWashing(
      json['index'] as String,
      json['desc'] as String,
      json['datetime'] as String,
    );

Map<String, dynamic> _$CarWashingToJson(CarWashing instance) =>
    <String, dynamic>{
      'index': instance.index,
      'desc': instance.desc,
      'datetime': instance.datetime,
    };

Precipitation _$PrecipitationFromJson(Map<String, dynamic> json) =>
    Precipitation(
      json['date'] as String,
      (json['max'] as num).toDouble(),
      (json['avg'] as num).toDouble(),
      (json['min'] as num).toDouble(),
    );

Map<String, dynamic> _$PrecipitationToJson(Precipitation instance) =>
    <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

Wind _$WindFromJson(Map<String, dynamic> json) => Wind(
      json['date'] as String,
      WindValue.fromJson(json['max'] as Map<String, dynamic>),
      WindValue.fromJson(json['avg'] as Map<String, dynamic>),
      WindValue.fromJson(json['min'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WindToJson(Wind instance) => <String, dynamic>{
      'date': instance.date,
      'max': instance.max,
      'avg': instance.avg,
      'min': instance.min,
    };

WindValue _$WindValueFromJson(Map<String, dynamic> json) => WindValue(
      (json['direction'] as num).toDouble(),
      (json['speed'] as num).toDouble(),
    );

Map<String, dynamic> _$WindValueToJson(WindValue instance) => <String, dynamic>{
      'direction': instance.direction,
      'speed': instance.speed,
    };

Skycon_08h_20h _$Skycon_08h_20hFromJson(Map<String, dynamic> json) =>
    Skycon_08h_20h(
      json['date'] as String,
      json['value'] as String,
    );

Map<String, dynamic> _$Skycon_08h_20hToJson(Skycon_08h_20h instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };
