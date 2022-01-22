import 'package:cs_467_arcore/satellite.dart';

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}

void main() {
  final Satellite iss = Satellite(25544);
  List<double> issPosition = iss.getCurrentPosition(25544);

  //print(issPosition[0].toString() + "-" + issPosition[1].toString());
}
