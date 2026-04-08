/// Validation utilities for form fields and data validation
class ValidationUtils {
  /// Validates email format
  /// Checks for: text@domain.extension
  /// Returns true if valid, false otherwise
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
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

  /// Validates phone number format
  /// Expects 10 digits for Indian phone numbers
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    
    // Remove any spaces
    String cleanPhone = phone.replaceAll(' ', '');
    
    // Check if it's 10 digits
    return cleanPhone.length == 10 && int.tryParse(cleanPhone) != null;
  }

  /// Validates password strength
  /// Minimum 6 characters
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validates pincode (6 digits for India)
  static bool isValidPincode(String pincode) {
    if (pincode.isEmpty) return false;
    return pincode.length == 6 && int.tryParse(pincode) != null;
  }

  /// Validates farm area (must be positive number)
  static bool isValidFarmArea(String area) {
    if (area.isEmpty) return false;
    double? value = double.tryParse(area);
    return value != null && value > 0;
  }

  /// Validates that two passwords match
  static bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  /// Generic text field validator - non-empty
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
}
