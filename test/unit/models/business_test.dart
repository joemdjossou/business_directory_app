import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/data/models/business.dart';

void main() {
  group('Business Model Tests', () {
    late Map<String, dynamic> validBusinessJson;
    late Business testBusiness;

    setUp(() {
      validBusinessJson = {
        'biz_name': 'Test Business',
        'bss_location': 'Test Location',
        'contct_no': '+1234567890',
      };

      testBusiness = const Business(
        id: 'test_business_test_location',
        name: 'Test Business',
        location: 'Test Location',
        contactNumber: '+1234567890',
      );
    });

    test('fromJson creates Business from valid JSON', () {
      final business = Business.fromJson(validBusinessJson);

      expect(business.name, equals('Test Business'));
      expect(business.location, equals('Test Location'));
      expect(business.contactNumber, equals('+1234567890'));
      expect(business.id, equals('test_business_test_location'));
    });

    test('fromJson throws ValidationException for null name', () {
      validBusinessJson['biz_name'] = null;

      expect(
        () => Business.fromJson(validBusinessJson),
        throwsA(isA<ValidationException>()),
      );
    });

    test('fromJson throws ValidationException for empty location', () {
      validBusinessJson['bss_location'] = '';

      expect(
        () => Business.fromJson(validBusinessJson),
        throwsA(isA<ValidationException>()),
      );
    });

    test('fromJson throws ValidationException for null contact', () {
      validBusinessJson['contct_no'] = null;

      expect(
        () => Business.fromJson(validBusinessJson),
        throwsA(isA<ValidationException>()),
      );
    });

    test('toJson returns correct JSON representation', () {
      final json = testBusiness.toJson();

      expect(json['id'], equals('test_business_test_location'));
      expect(json['name'], equals('Test Business'));
      expect(json['location'], equals('Test Location'));
      expect(json['contactNumber'], equals('+1234567890'));
    });

    test('isValidPhoneNumber validates correct phone numbers', () {
      expect(Business.isValidPhoneNumber('+1234567890'), isTrue);
      expect(Business.isValidPhoneNumber('123-456-7890'), isTrue);
      expect(Business.isValidPhoneNumber('(123) 456-7890'), isTrue);
      expect(Business.isValidPhoneNumber('1234567890'), isTrue);
    });

    test('isValidPhoneNumber rejects invalid phone numbers', () {
      expect(Business.isValidPhoneNumber('123'), isFalse);
      expect(Business.isValidPhoneNumber('abc'), isFalse);
      expect(Business.isValidPhoneNumber(''), isFalse);
      expect(Business.isValidPhoneNumber('123456789'), isFalse);
    });

    test('isValidBusinessName validates correct business names', () {
      expect(Business.isValidBusinessName('Test Business'), isTrue);
      expect(Business.isValidBusinessName('A'), isFalse);
      expect(Business.isValidBusinessName(''), isFalse);
      expect(Business.isValidBusinessName('  '), isFalse);
    });

    test('isValidLocation validates correct locations', () {
      expect(Business.isValidLocation('Test Location'), isTrue);
      expect(Business.isValidLocation('A'), isFalse);
      expect(Business.isValidLocation(''), isFalse);
      expect(Business.isValidLocation('  '), isFalse);
    });

    test('equality operator works correctly', () {
      final business1 = Business.fromJson(validBusinessJson);
      final business2 = Business.fromJson(validBusinessJson);

      expect(business1, equals(business2));
      expect(business1.hashCode, equals(business2.hashCode));
    });

    test('inequality operator works correctly', () {
      final business1 = Business.fromJson(validBusinessJson);
      
      validBusinessJson['biz_name'] = 'Different Business';
      final business2 = Business.fromJson(validBusinessJson);

      expect(business1, isNot(equals(business2)));
      expect(business1.hashCode, isNot(equals(business2.hashCode)));
    });

    test('toString returns correct string representation', () {
      final string = testBusiness.toString();

      expect(string, contains('Test Business'));
      expect(string, contains('Test Location'));
      expect(string, contains('+1234567890'));
      expect(string, contains('test_business_test_location'));
    });

    test('_generateId creates consistent IDs', () {
      final id1 = Business.fromJson(validBusinessJson).id;
      final id2 = Business.fromJson(validBusinessJson).id;

      expect(id1, equals(id2));
      expect(id1, equals('test_business_test_location'));
    });

    test('_generateId handles special characters in names', () {
      validBusinessJson['biz_name'] = 'Test & Co.';
      validBusinessJson['bss_location'] = 'New York';
      
      final business = Business.fromJson(validBusinessJson);
      expect(business.id, equals('test_&_co._new_york'));
    });

    test('_validateAndNormalize trims whitespace', () {
      validBusinessJson['biz_name'] = '  Test Business  ';
      
      final business = Business.fromJson(validBusinessJson);
      expect(business.name, equals('Test Business'));
    });
  });

  group('ValidationException Tests', () {
    test('ValidationException has correct message', () {
      const exception = ValidationException('Test error');
      
      expect(exception.message, equals('Test error'));
      expect(exception.toString(), equals('ValidationException: Test error'));
    });
  });
}
