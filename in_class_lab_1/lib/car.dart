import 'vehicle.dart';

class Car extends Vehicle {
  bool isElectric;

  Car(String brand, int year, this.isElectric) : super(brand, year);

  Car.tesla(int year) : isElectric = true, super('Tesla', year);

  @override
  void startEngine() {
    if (isElectric) {
      print('$brand ($year): Động cơ điện khởi động êm ái...');
    } else {
      print('$brand ($year): Động cơ xăng khởi động: Vroom vroom!');
    }
  }
}
