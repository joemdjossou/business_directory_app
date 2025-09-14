import 'package:flutter_test/flutter_test.dart';
import 'package:business_directory_app/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    group('Email Validation', () {
      test('isValidEmail accepts valid email addresses', () {
        expect(Validators.isValidEmail('test@example.com'), isTrue);
        expect(Validators.isValidEmail('user.name@domain.co.uk'), isTrue);
        expect(Validators.isValidEmail('test+tag@example.org'), isTrue);
        expect(Validators.isValidEmail('123@example.com'), isTrue);
        expect(Validators.isValidEmail('test@sub.domain.com'), isTrue);
      });

      test('isValidEmail rejects invalid email addresses', () {
        expect(Validators.isValidEmail(''), isFalse);
        expect(Validators.isValidEmail('test'), isFalse);
        expect(Validators.isValidEmail('test@'), isFalse);
        expect(Validators.isValidEmail('@example.com'), isFalse);
        expect(Validators.isValidEmail('test@.com'), isFalse);
        expect(Validators.isValidEmail('test.example.com'), isFalse);
        expect(Validators.isValidEmail('test@example'), isFalse);
        expect(Validators.isValidEmail('test@example.'), isFalse);
      });
    });

    group('Phone Number Validation', () {
      test('isValidPhoneNumber accepts valid phone numbers', () {
        expect(Validators.isValidPhoneNumber('+1234567890'), isTrue);
        expect(Validators.isValidPhoneNumber('1234567890'), isTrue);
        expect(Validators.isValidPhoneNumber('+44 20 7123 4567'), isTrue);
        expect(Validators.isValidPhoneNumber('(123) 456-7890'), isTrue);
        expect(Validators.isValidPhoneNumber('123-456-7890'), isTrue);
        expect(Validators.isValidPhoneNumber('+1 (555) 123-4567'), isTrue);
      });

      test('isValidPhoneNumber rejects invalid phone numbers', () {
        expect(Validators.isValidPhoneNumber(''), isFalse);
        expect(Validators.isValidPhoneNumber('123'), isFalse);
        expect(Validators.isValidPhoneNumber('abc123'), isFalse);
        expect(
          Validators.isValidPhoneNumber('123456789'),
          isFalse,
        ); // Too short
        expect(
          Validators.isValidPhoneNumber('+123'),
          isFalse,
        ); // Too short with +
      });
    });

    group('Business Name Validation', () {
      test('isValidBusinessName accepts valid business names', () {
        expect(Validators.isValidBusinessName('Test Business'), isTrue);
        expect(Validators.isValidBusinessName('A&B Corp'), isTrue);
        expect(Validators.isValidBusinessName('123 Store'), isTrue);
        expect(Validators.isValidBusinessName('Business-Name'), isTrue);
        expect(
          Validators.isValidBusinessName('  Valid Business  '),
          isTrue,
        ); // Trimmed
      });

      test('isValidBusinessName rejects invalid business names', () {
        expect(Validators.isValidBusinessName(''), isFalse);
        expect(Validators.isValidBusinessName('A'), isFalse); // Too short
        expect(
          Validators.isValidBusinessName('  '),
          isFalse,
        ); // Only whitespace
        expect(
          Validators.isValidBusinessName('Business<script>'),
          isFalse,
        ); // XSS
        expect(
          Validators.isValidBusinessName('Business{test}'),
          isFalse,
        ); // Invalid chars
        expect(
          Validators.isValidBusinessName('Business>test'),
          isFalse,
        ); // Invalid chars

        // Test name too long (over 100 chars)
        final longName = 'A' * 101;
        expect(Validators.isValidBusinessName(longName), isFalse);
      });
    });

    group('Location Validation', () {
      test('isValidLocation accepts valid locations', () {
        expect(Validators.isValidLocation('New York'), isTrue);
        expect(Validators.isValidLocation('San Francisco, CA'), isTrue);
        expect(Validators.isValidLocation('123 Main St'), isTrue);
        expect(
          Validators.isValidLocation('  Valid Location  '),
          isTrue,
        ); // Trimmed
      });

      test('isValidLocation rejects invalid locations', () {
        expect(Validators.isValidLocation(''), isFalse);
        expect(Validators.isValidLocation('A'), isFalse); // Too short
        expect(Validators.isValidLocation('  '), isFalse); // Only whitespace

        // Test location too long (over 100 chars)
        final longLocation = 'A' * 101;
        expect(Validators.isValidLocation(longLocation), isFalse);
      });
    });

    group('Search Query Validation', () {
      test('isValidSearchQuery accepts valid search queries', () {
        expect(Validators.isValidSearchQuery('restaurant'), isTrue);
        expect(Validators.isValidSearchQuery('pizza place'), isTrue);
        expect(Validators.isValidSearchQuery('123'), isTrue);
        expect(
          Validators.isValidSearchQuery('  valid query  '),
          isTrue,
        ); // Trimmed
      });

      test('isValidSearchQuery rejects invalid search queries', () {
        expect(Validators.isValidSearchQuery(''), isFalse);
        expect(Validators.isValidSearchQuery('  '), isFalse); // Only whitespace
      });
    });

    group('Input Sanitization', () {
      test('sanitizeInput removes extra whitespace', () {
        expect(Validators.sanitizeInput('  test  '), equals('test'));
        expect(Validators.sanitizeInput('test   input'), equals('test input'));
        expect(
          Validators.sanitizeInput('  multiple   spaces  '),
          equals('multiple spaces'),
        );
        expect(Validators.sanitizeInput('\t\ntest\t\n'), equals('test'));
      });

      test('sanitizeInput handles empty and whitespace strings', () {
        expect(Validators.sanitizeInput(''), equals(''));
        expect(Validators.sanitizeInput('   '), equals(''));
        expect(Validators.sanitizeInput('\t\n'), equals(''));
      });
    });

    group('Phone Number Normalization', () {
      test('normalizePhoneNumber adds country code to local numbers', () {
        expect(
          Validators.normalizePhoneNumber('1234567890'),
          equals('+11234567890'),
        );
        expect(
          Validators.normalizePhoneNumber('555-123-4567'),
          equals('+15551234567'),
        );
        expect(
          Validators.normalizePhoneNumber('(555) 123-4567'),
          equals('+15551234567'),
        );
      });

      test('normalizePhoneNumber preserves international numbers', () {
        expect(
          Validators.normalizePhoneNumber('+44 20 7123 4567'),
          equals('+442071234567'),
        );
        expect(
          Validators.normalizePhoneNumber('+1-555-123-4567'),
          equals('+15551234567'),
        );
        expect(
          Validators.normalizePhoneNumber('+49 30 12345678'),
          equals('+493012345678'),
        );
      });

      test('normalizePhoneNumber removes formatting characters', () {
        expect(
          Validators.normalizePhoneNumber('(555) 123-4567'),
          equals('+15551234567'),
        );
        expect(
          Validators.normalizePhoneNumber('555.123.4567'),
          equals('+15551234567'),
        );
        expect(
          Validators.normalizePhoneNumber('555 123 4567'),
          equals('+15551234567'),
        );
      });
    });

    group('Business JSON Validation', () {
      test('isValidBusinessJson accepts valid JSON', () {
        final validJson = {
          'biz_name': 'Test Business',
          'bss_location': 'Test Location',
          'contct_no': '+1234567890',
        };

        expect(Validators.isValidBusinessJson(validJson), isTrue);
      });

      test('isValidBusinessJson rejects JSON with missing fields', () {
        final missingName = {
          'bss_location': 'Test Location',
          'contct_no': '+1234567890',
        };
        expect(Validators.isValidBusinessJson(missingName), isFalse);

        final missingLocation = {
          'biz_name': 'Test Business',
          'contct_no': '+1234567890',
        };
        expect(Validators.isValidBusinessJson(missingLocation), isFalse);

        final missingContact = {
          'biz_name': 'Test Business',
          'bss_location': 'Test Location',
        };
        expect(Validators.isValidBusinessJson(missingContact), isFalse);
      });

      test('isValidBusinessJson rejects JSON with null values', () {
        final nullName = {
          'biz_name': null,
          'bss_location': 'Test Location',
          'contct_no': '+1234567890',
        };
        expect(Validators.isValidBusinessJson(nullName), isFalse);

        final nullLocation = {
          'biz_name': 'Test Business',
          'bss_location': null,
          'contct_no': '+1234567890',
        };
        expect(Validators.isValidBusinessJson(nullLocation), isFalse);

        final nullContact = {
          'biz_name': 'Test Business',
          'bss_location': 'Test Location',
          'contct_no': null,
        };
        expect(Validators.isValidBusinessJson(nullContact), isFalse);
      });
    });
  });
}
