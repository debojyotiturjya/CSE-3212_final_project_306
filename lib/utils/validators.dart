class Validators {
  static final RegExp _name = RegExp(r'^[a-zA-Z .]+$');
  static final RegExp _studentId = RegExp(r'^\d{16}$'); // basic: digits only
  static final RegExp _phone = RegExp(
    r'^(?:\+?88)?01[3-9]\d{8}$',
  ); // Bangladesh
  static final RegExp _email = RegExp(r'^[\w.-]+@[\w-]+\.[\w.]+$');
  // 8+ chars, at least one digit, lowercase, uppercase and ANY symbol, no spaces.
  static final RegExp _password = RegExp(
    r'^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9\s])\S{8,}$',
  );
  static final RegExp _genre = RegExp(r'^[A-Za-z][A-Za-z ,/&-]*$');
  static final RegExp _year = RegExp(r'^(18|19|20)\d{2}$');
  static final RegExp _url = RegExp(
    r'^https?://\S+\.\S+$',
    caseSensitive: false,
  );

  // ---------- login / register ----------
  static String? name(String? value, String label) {
    if (value == null || value.trim().isEmpty) return "Enter $label";
    if (!_name.hasMatch(value.trim())) return "$label can only have letters";
    return null;
  }

  static String? studentId(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter your ID";
    if (!_studentId.hasMatch(value.trim())) return "ID must be 16 digits";
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter phone number";
    if (!_phone.hasMatch(value.trim())) return "Enter a valid BD phone number";
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter email";
    if (!_email.hasMatch(value.trim())) return "Enter a valid email";
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return "Enter password";
    if (!_password.hasMatch(value)) {
      return "Min 8 chars: upper, lower, digit and a symbol";
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return "Enter confirm password";
    if (value != original) return "Passwords do not match";
    return null;
  }

  // ---------- movies ----------
  static String? title(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter the title";
    if (value.trim().length > 80) return "Title is too long (max 80)";
    return null;
  }

  static String? genre(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter the genre";
    if (!_genre.hasMatch(value.trim())) return "Genre can only have letters";
    return null;
  }

  static String? releaseYear(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter the release year";
    if (!_year.hasMatch(value.trim())) return "Enter a year like 1999 or 2024";
    return null;
  }

  static String? producer(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter the producer";
    return null;
  }

  static String? posterUrl(String? value) {
    if (value == null || value.trim().isEmpty) return "Paste a poster link";
    if (!_url.hasMatch(value.trim()))
      return "Link must start with http:// or https://";
    return null;
  }

  static String? synopsis(String? value) {
    if (value == null || value.trim().isEmpty) return "Enter a short synopsis";
    if (value.trim().length < 10) return "Write at least 10 characters";
    return null;
  }

  // ---------- reviews ----------
  static String? review(String? value) {
    if (value == null || value.trim().isEmpty) return "Write something first";
    if (value.trim().length > 200) return "Max 300 characters";
    return null;
  }
}
