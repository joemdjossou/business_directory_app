import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/data/models/service.dart';

void main() {
  group('Service Model Tests', () {
    late Map<String, dynamic> validServiceJson;
    late Service testService;

    setUp(() {
      validServiceJson = {
        'id': 'service-1',
        'name': 'Test Service',
        'description': 'Test service description',
        'category': 'Testing',
        'price': 99.99,
      };

      testService = const Service(
        id: 'service-1',
        name: 'Test Service',
        description: 'Test service description',
        category: 'Testing',
        price: 99.99,
      );
    });

    test('fromJson creates Service from valid JSON', () {
      final service = Service.fromJson(validServiceJson);

      expect(service.id, equals('service-1'));
      expect(service.name, equals('Test Service'));
      expect(service.description, equals('Test service description'));
      expect(service.category, equals('Testing'));
      expect(service.price, equals(99.99));
    });

    test('fromJson handles null price', () {
      validServiceJson['price'] = null;

      final service = Service.fromJson(validServiceJson);
      expect(service.price, isNull);
    });

    test('fromJson handles missing fields with empty strings', () {
      final minimalJson = <String, dynamic>{};

      final service = Service.fromJson(minimalJson);
      expect(service.id, equals(''));
      expect(service.name, equals(''));
      expect(service.description, equals(''));
      expect(service.category, equals(''));
      expect(service.price, isNull);
    });

    test('fromJson converts price to double', () {
      validServiceJson['price'] = 50; // int

      final service = Service.fromJson(validServiceJson);
      expect(service.price, equals(50.0));
    });

    test('toJson returns correct JSON representation', () {
      final json = testService.toJson();

      expect(json['id'], equals('service-1'));
      expect(json['name'], equals('Test Service'));
      expect(json['description'], equals('Test service description'));
      expect(json['category'], equals('Testing'));
      expect(json['price'], equals(99.99));
    });

    test('toJson handles null price', () {
      const serviceWithoutPrice = Service(
        id: 'service-2',
        name: 'Free Service',
        description: 'Free service',
        category: 'Free',
      );

      final json = serviceWithoutPrice.toJson();
      expect(json['price'], isNull);
    });

    test('equality operator works correctly', () {
      final service1 = Service.fromJson(validServiceJson);
      final service2 = Service.fromJson(validServiceJson);

      expect(service1, equals(service2));
      expect(service1.hashCode, equals(service2.hashCode));
    });

    test('inequality operator works correctly', () {
      final service1 = Service.fromJson(validServiceJson);

      validServiceJson['name'] = 'Different Service';
      final service2 = Service.fromJson(validServiceJson);

      expect(service1, isNot(equals(service2)));
      expect(service1.hashCode, isNot(equals(service2.hashCode)));
    });

    test('toString returns correct string representation', () {
      final string = testService.toString();

      expect(string, contains('service-1'));
      expect(string, contains('Test Service'));
      expect(string, contains('Test service description'));
      expect(string, contains('Testing'));
      expect(string, contains('99.99'));
    });

    test('services with different prices are not equal', () {
      final service1 = Service.fromJson(validServiceJson);

      validServiceJson['price'] = 149.99;
      final service2 = Service.fromJson(validServiceJson);

      expect(service1, isNot(equals(service2)));
    });

    test('services with null vs non-null prices are not equal', () {
      final service1 = Service.fromJson(validServiceJson);

      validServiceJson['price'] = null;
      final service2 = Service.fromJson(validServiceJson);

      expect(service1, isNot(equals(service2)));
    });

    test('equality works with null prices', () {
      validServiceJson['price'] = null;
      final service1 = Service.fromJson(validServiceJson);
      final service2 = Service.fromJson(validServiceJson);

      expect(service1, equals(service2));
      expect(service1.hashCode, equals(service2.hashCode));
    });
  });
}
