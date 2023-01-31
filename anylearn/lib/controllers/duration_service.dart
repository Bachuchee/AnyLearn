Duration parseDuration(String s) {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  int micros = 0;
  List<String> parts = s.split(':');
  if (parts.length == 3) {
    hours = int.parse(parts[0]);
    minutes = int.parse(parts[1]);
    seconds = int.parse(parts[2].split('.')[0]);
  }
  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    microseconds: micros,
  );
}
