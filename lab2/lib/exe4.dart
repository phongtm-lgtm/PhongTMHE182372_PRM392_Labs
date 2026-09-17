class Car {
  String brand;

  Car(this.brand);

  Car.defaultCar() : brand = 'Toyota';

  void displayInfo() {
    print('Car brand: $brand');
  }
}

// ElectricCar inherits from Car
class ElectricCar extends Car {
  int batteryCapacity;

  ElectricCar(String brand, this.batteryCapacity) : super(brand);

  // Override parent method
  @override
  void displayInfo() {
    print('Electric car brand: $brand');
    print('Battery capacity: $batteryCapacity kWh');
  }
}

void exe4() {
  // Create normal Car
  Car car1 = Car('Honda');
  car1.displayInfo();

  // Use named constructor
  Car car2 = Car.defaultCar();
  car2.displayInfo();

  // Create ElectricCar
  ElectricCar electricCar = ElectricCar('Tesla', 75);
  electricCar.displayInfo();
}
