import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:get/get.dart';
import 'package:clima/services/weather.dart';

// ignore: must_be_immutable
class LocationScreen extends StatefulWidget {
  LocationScreen({Key? key}) : super(key: key);

  var arg = Get.arguments;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temperature = 1;
  late String weatherIcon = '';
  late String cityName = '';
  late String weatherMessage = '';
  late String newCity = '';

  @override
  void initState() {
    super.initState();
    updateUI(widget.arg);
  }

  void updateUI(
    dynamic weatherData,
  ) {
    setState(
      () {
        if (weatherData == null) {
          temperature = 0;
          weatherIcon = 'Error';
          weatherMessage = 'Unable to get weather data';
          cityName = '';
          return;
        } else {
          double temp = weatherData['main']['temp'];
          temperature = temp.toInt();
          var condition = weatherData['weather'][0]['id'];
          weatherIcon = weather.getWeatherIcon(condition);
          weatherMessage = weather.getMessage(temperature);
          cityName = weatherData['name'];
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CityScreen();
                          },
                        ),
                      );
                      if (typedName != null) {
                        var weatherData =
                            await weather.getCityWeather(typedName);
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(Icons.location_city,
                        size: 50.0, color: Colors.white),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Text(
                      temperature.toString(),
                      style: kTempTextStyle,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      'Message: $weatherMessage',
                      textAlign: TextAlign.center,
                      style: kMessageTextStyle,
                    ),
                    Text(
                      'Location:  $cityName',
                      textAlign: TextAlign.center,
                      style: kMessageTextStyle,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
