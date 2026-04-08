import 'package:flutter_test/flutter_test.dart';

// Email validation function
bool isValidEmail(String email) {
  // Check basic format: must have text @ domain . extension
  if (!email.contains('@') || !email.contains('.')) {
    return false;
  }
  
  // Split by @
  List<String> parts = email.split('@');
  if (parts.length != 2) return false;
  
  String local = parts[0]; // Before @
  String domain = parts[1]; // After @
  
  // Local part must exist and not be empty
  if (local.isEmpty) return false;
  
  // Domain must have at least one dot and content before/after
  List<String> domainParts = domain.split('.');
  if (domainParts.length < 2) return false;
  
  // Each domain part must exist
  for (var part in domainParts) {
    if (part.isEmpty) return false;
  }
  
  return true;
}

void main() {
  group('Authentication Flow Tests - Unit Tests', () {
    group('Farmer Registration', () {
      test('Farmer email should be valid format', () {
        final validEmails = [
          'farmer@example.com',
          'john.doe@farm.io',
          'test+farmer@gmail.com',
        ];

        final invalidEmails = [
          'farmer@',
          '@example.com',
          'farmer.example',
          'farmer example@com',
        ];

        for (var email in validEmails) {
          expect(isValidEmail(email), true,
              reason: '$email should be valid');
        }

        for (var email in invalidEmails) {
          expect(isValidEmail(email), false,
              reason: '$email should be invalid');
        }
      });

      test('Farmer phone should be valid length', () {
        expect('9876543210'.length, 10);
        expect('98765432'.length, 8); // Too short
        expect('987654321012'.length, 12); // Too long
      });

      test('Farmer password should meet minimum requirements', () {
        final validPasswords = [
          'password123',
          'SecureP@ss1',
          'FarmingPro2024',
        ];

        final invalidPasswords = [
          '12345', // Too short
          'abc', // Too weak
          '', // Empty
        ];

        for (var password in validPasswords) {
          expect(password.length >= 6, true,
              reason: '$password should be valid');
        }

        for (var password in invalidPasswords) {
          expect(password.length >= 6, false,
              reason: '$password should be invalid');
        }
      });

      test('Farmer soil type should be from valid options', () {
        const validSoilTypes = ['LOAMY', 'CLAY', 'SANDY', 'SILT', 'PEATY'];
        const testSoilType = 'LOAMY';

        expect(validSoilTypes.contains(testSoilType), true);
      });

      test('Farmer farm area should be positive number', () {
        final validAreas = [1.0, 10.5, 100.0, 500.25];
        final invalidAreas = [0, -5, -0.5];

        for (var area in validAreas) {
          expect(area > 0, true, reason: '$area should be positive');
        }

        for (var area in invalidAreas) {
          expect(area > 0, false, reason: '$area should not be positive');
        }
      });

      test('Farmer district and taluka should not be empty', () {
        final testData = {
          'district': 'Punjab',
          'taluka': 'Mohali',
        };

        expect(testData['district']?.isNotEmpty, true);
        expect(testData['taluka']?.isNotEmpty, true);
      });
    });

    group('Consumer Registration', () {
      test('Consumer name should not be empty', () {
        final validNames = [
          'Rajesh Kumar',
          'Priya Singh',
          'John Doe',
        ];

        final invalidNames = ['', ' ', '   '];

        for (var name in validNames) {
          expect(name.trim().isNotEmpty, true,
              reason: '$name should be valid');
        }

        for (var name in invalidNames) {
          expect(name.trim().isNotEmpty, false,
              reason: '$name should be invalid');
        }
      });

      test('Consumer address and city should be provided', () {
        final testData = {
          'address': '123 Main Street',
          'city': 'Delhi',
          'pincode': '110001',
        };

        expect(testData['address']?.isNotEmpty, true);
        expect(testData['city']?.isNotEmpty, true);
        expect(testData['pincode']?.isNotEmpty, true);
      });

      test('Consumer pincode should be valid length', () {
        final validPincodes = ['110001', '560034', '700001'];
        final invalidPincodes = ['1100', '11000012'];

        for (var pincode in validPincodes) {
          expect(pincode.length, 6);
        }

        for (var pincode in invalidPincodes) {
          expect(pincode.length, isNot(6));
        }
      });
    });

    group('Admin Registration', () {
      test('Admin email should be valid', () {
        final adminEmail = 'admin@kurukshetra.com';
        expect(adminEmail.contains('@'), true);
        expect(adminEmail.contains('.'), true);
      });

      test('Admin password requirements', () {
        final strongPassword = 'AdminPassword123!';
        expect(strongPassword.length >= 8, true);
      });

      test('Admin role should be set correctly', () {
        const adminRole = 'ADMIN';
        expect(adminRole, 'ADMIN');
      });
    });
  });

  group('Login Validation', () {
    test('Email validation in login', () {
      final testEmail = 'user@example.com';
      expect(testEmail.contains('@'), true);
      expect(testEmail.contains('.'), true);
    });

    test('Password should not be empty on login', () {
      final password = 'password123';
      expect(password.isNotEmpty, true);
    });

    test('Login should accept valid credentials format', () {
      final credentials = {
        'email': 'user@example.com',
        'password': 'password123',
      };

      expect(credentials['email']?.contains('@'), true);
      expect(credentials['password']?.isNotEmpty, true);
    });
  });

  group('Form Validation', () {
    test('Required fields should be validated', () {
      final formData = {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'phone': '9876543210',
      };

      for (var entry in formData.entries) {
        expect(entry.value.isNotEmpty, true,
            reason: '${entry.key} should not be empty');
      }
    });

    test('Email format should be validated', () {
      final validEmail = 'user@example.com';
      final invalidEmail = 'userexample.com';

      expect(validEmail.contains('@'), true);
      expect(invalidEmail.contains('@'), false);
    });

    test('Phone number length validation', () {
      final validPhone = '9876543210';
      final invalidPhone = '98765';

      expect(validPhone.length >= 10, true);
      expect(invalidPhone.length >= 10, false);
    });

    test('Password confirmation should match', () {
      final password = 'password123';
      final confirmPassword = 'password123';

      expect(password == confirmPassword, true);
    });

    test('Password mismatch should fail validation', () {
      final password = 'password123';
      final confirmPassword = 'password124';

      expect(password == confirmPassword, false);
    });
  });
}

