class Validator {
  static bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool validateOTP(String userOtp, String realOtp) {
    if (userOtp == realOtp) {
      return true;
    } else {
      return false;
    }
  }

  static bool validatePassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(password);
  }
}
