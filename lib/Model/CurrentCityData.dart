class CurrentCityDataModel {
  String _cityName;
  var _lng;
  var _lat;
  String _main;
  String _description;
  var _temp;
  var _temp_max;
  var _temp_min;
  var _pressure;
  var _humidity;
  var _windSpeed;
  var _dataTime;
  String _country;
  var _sunrise;
  var _sunset;

  CurrentCityDataModel(
      this._cityName,
      this._lng,
      this._lat,
      this._main,
      this._description,
      this._temp,
      this._temp_max,
      this._temp_min,
      this._pressure,
      this._humidity,
      this._windSpeed,
      this._dataTime,
      this._country,
      this._sunrise,
      this._sunset);

  get sunset => _sunset;

  set sunset(value) {
    _sunset = value;
  }

  get sunrise => _sunrise;

  set sunrise(value) {
    _sunrise = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  get dataTime => _dataTime;

  set dataTime(value) {
    _dataTime = value;
  }

  get windSpeed => _windSpeed;

  set windSpeed(value) {
    _windSpeed = value;
  }

  get humidity => _humidity;

  set humidity(value) {
    _humidity = value;
  }

  get pressure => _pressure;

  set pressure(value) {
    _pressure = value;
  }

  get temp_min => _temp_min;

  set temp_min(value) {
    _temp_min = value;
  }

  get temp_max => _temp_max;

  set temp_max(value) {
    _temp_max = value;
  }

  get temp => _temp;

  set temp(value) {
    _temp = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get main => _main;

  set main(String value) {
    _main = value;
  }

  get lat => _lat;

  set lat(value) {
    _lat = value;
  }

  get lng => _lng;

  set lng(value) {
    _lng = value;
  }

  String get cityName => _cityName;

  set cityName(String value) {
    _cityName = value;
  }
}
