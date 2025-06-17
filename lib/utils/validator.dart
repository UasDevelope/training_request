class AppValidators {
  // Required Field
  static String? validateRequired(
    String? value, {
    String fieldName = "This field",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  // Email Validation
  static String? emailValidate(String? value, {String fieldName = "Email"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,5}$");

    if (!emailRegex.hasMatch(value.trim())) {
      return "Please enter a valid $fieldName";
    }

    return null;
  }

  // Password Validation
  static String? passwordValidate(
    String? value, {
    String fieldName = "Password",
    int minLength = 6,
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    if (value.trim().length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }

    return null;
  }

  // Phone Number Validation
  static String? phoneValidate(
    String? value, {
    String fieldName = "Phone number",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    final phoneRegex = RegExp(r'^\+?\d{7,15}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return "Please enter a valid $fieldName";
    }

    return null;
  }

  // Confirm Password Validation
  static String? confirmPasswordValidate(
    String? value,
    String? original, {
    String fieldName = "Confirm password",
  }) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }

    if (value != original) {
      return "$fieldName does not match";
    }

    return null;
  }
}
