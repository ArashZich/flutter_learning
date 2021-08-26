import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:weather/Model/CurrentCityData.dart';
import 'package:weather/Model/ForecastDaysModel.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var cityName = "Tehran";
  var lat;
  var lng;
  late StreamController<CurrentCityDataModel> streamCityData;
  late StreamController<List<ForecastDaysModel>> streamForecastDays;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    streamCityData = StreamController<CurrentCityDataModel>();
    streamForecastDays = StreamController<List<ForecastDaysModel>>();
    CallRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        elevation: 15,
        actions: <Widget>[
          PopupMenuButton<String>(itemBuilder: (BuildContext context) {
            return {'Profile', 'Setting', 'LogOut'}.map((String choise) {
              return PopupMenuItem(child: Text(choise), value: choise);
            }).toList();
          })
        ],
      ),
      body: StreamBuilder<CurrentCityDataModel>(
        stream: streamCityData.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CurrentCityDataModel? cityDataModel = snapshot.data;
            SendRequest7DaysForcast(lat, lng);

            final formatter = DateFormat.jm();
            var sunrise = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                    cityDataModel!.sunrise * 1000,
                    isUtc: true));
            var sunset = formatter.format(
                new DateTime.fromMillisecondsSinceEpoch(
                    cityDataModel.sunset * 1000,
                    isUtc: true));

            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/pic_bg.jpg'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      SendRequestCurrentWeather(
                                          textEditingController.text);
                                    });
                                  },
                                  child: Text('find')),
                            ),
                            Expanded(
                                child: TextField(
                              controller: textEditingController,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'Enter city'),
                              style: TextStyle(color: Colors.white),
                            ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Text(
                          cityDataModel.cityName,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          cityDataModel.description,
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: setIconForMain(cityDataModel),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(cityDataModel.temp.toString() + "\u00B0",
                            style:
                                TextStyle(color: Colors.white, fontSize: 60)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'max',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  cityDataModel.temp_max.toString() + "\u00B0",
                                  style: TextStyle(
                                      color: Colors.grey[200], fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                'min',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  cityDataModel.temp_min.toString() + "\u00B0",
                                  style: TextStyle(
                                      color: Colors.grey[200], fontSize: 20),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Container(
                          color: Colors.grey,
                          height: 1,
                          width: double.infinity,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: Center(
                          child: StreamBuilder<List<ForecastDaysModel>>(
                            stream: streamForecastDays.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<ForecastDaysModel>? forcastDays =
                                    snapshot.data;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 6,
                                    itemBuilder:
                                        (BuildContext context, int pos) {
                                      return listViewItems(
                                          forcastDays![pos + 1]);
                                    });
                              } else {
                                return Center(
                                    child: JumpingDotsProgressIndicator(
                                  color: Colors.black,
                                  fontSize: 60,
                                  dotSpacing: 2,
                                ));
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          color: Colors.grey,
                          height: 1,
                          width: double.infinity,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('wind speed',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                    cityDataModel.windSpeed.toString() + 'm/s',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 10,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text('sunrise',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(sunrise,
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 10,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text('sunset',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(sunset,
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 10,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              Text('humidity',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                    cityDataModel.humidity.toString() + '%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 10,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
                child: JumpingDotsProgressIndicator(
              color: Colors.black,
              fontSize: 60,
              dotSpacing: 2,
            ));
          }
        },
      ),
    );
  }

  Container listViewItems(ForecastDaysModel forcastDay) {
    return Container(
      height: 50,
      width: 60,
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              forcastDay.datetime,
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            Expanded(child: setIconForMain(forcastDay)),
            Text(
              forcastDay.temp.round().toString() + "\u00B0",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Image setIconForMain(model) {
    String description = model.description;

    if (description == "clear sky") {
      return Image(image: AssetImage('images/icons8-sun-96.png'));
    } else if (description == "few clouds") {
      return Image(image: AssetImage('images/icons8-partly-cloudy-day-80.png'));
    } else if (description.contains("clouds")) {
      return Image(image: AssetImage('images/icons8-clouds-80.png'));
    } else if (description.contains("thunderstorm")) {
      return Image(image: AssetImage('images/icons8-storm-80.png'));
    } else if (description.contains("drizzle")) {
      return Image(image: AssetImage('images/icons8-rain-cloud-80.png'));
    } else if (description.contains("rain")) {
      return Image(image: AssetImage('images/icons8-heavy-rain-80.png'));
    } else if (description.contains("snow")) {
      return Image(image: AssetImage('images/icons8-snow-80.png'));
    } else {
      return Image(image: AssetImage('images/icons8-windy-weather-80.png'));
    }
  }

  void SendRequestCurrentWeather(cityname, [BuildContext? context]) async {
    var apiKey = "31609c4f30af7d4dcd65ec3e82e04249";
    var city = cityname;
    var dataModel;

    try {
      var response = await Dio().get(
          "http://api.openweathermap.org/data/2.5/weather",
          queryParameters: {'q': city, 'appid': apiKey, 'units': 'metric'});

      print(response.data);
      print(response.statusCode);

      lat = response.data["coord"]["lat"];
      lng = response.data["coord"]["lon"];

      dataModel = CurrentCityDataModel(
          response.data["name"],
          response.data["coord"]["lon"],
          response.data["coord"]["lat"],
          response.data["weather"][0]["main"],
          response.data["weather"][0]["description"],
          response.data["main"]["temp"],
          response.data["main"]["temp_min"],
          response.data["main"]["temp_max"],
          response.data["main"]["pressure"],
          response.data["main"]["humidity"],
          response.data["wind"]["speed"],
          response.data["dt"],
          response.data["sys"]["country"],
          response.data["sys"]["sunrise"],
          response.data["sys"]["sunset"]);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text("City Not Found")));
    }
    streamCityData.add(dataModel);
  }

  void SendRequest7DaysForcast(lat, lon) async {
    List<ForecastDaysModel> list = [];
    var apiKey = '31609c4f30af7d4dcd65ec3e82e04249';

    try {
      var response = await Dio().get(
          "https://api.openweathermap.org/data/2.5/onecall",
          queryParameters: {
            'lat': lat,
            'lon': lon,
            'exclude': 'minutely,hourly',
            'appid': apiKey,
            'units': 'metric'
          });

      final formatter = DateFormat.MMMd();

      for (int i = 0; i < 8; i++) {
        var model = response.data['daily'][i];

        //change dt to our dateFormat ---Jun 23--- for Example
        var dt = formatter.format(new DateTime.fromMillisecondsSinceEpoch(
            model['dt'] * 1000,
            isUtc: true));
        // print(dt + " : " +model['weather'][0]['description']);

        ForecastDaysModel forecastDaysModel = new ForecastDaysModel(
            dt,
            model['temp']['day'],
            model['weather'][0]['main'],
            model['weather'][0]['description']);
        list.add(forecastDaysModel);
      }
      streamForecastDays.add(list);
    } on DioError catch (e) {
      print(e.response!.statusCode);
      print(e.message);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("there is an")));
    }
  }

  void CallRequests() {
    SendRequestCurrentWeather(cityName);
  }
}
