import 'car.dart';

void main() {
  final gasolineCar = Car('Toyota', 2022, false);
  gasolineCar.startEngine();

  final electricCar = Car.tesla(2024);
  electricCar.startEngine();
}
