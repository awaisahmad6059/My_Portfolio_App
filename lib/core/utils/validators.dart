class Validators {
  Validators._();

  static bool isValidPhone(String phone) {
    return phone.isNotEmpty && RegExp(r'^\+?\d{6,15}$').hasMatch(phone);
  }

  static bool isValidEmail(String email) {
    return email.isNotEmpty &&
        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static bool isNotEmpty(String value) => value.trim().isNotEmpty;
}
