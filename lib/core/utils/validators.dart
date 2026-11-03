abstract class Validators {
  static String? required(String? v, [String field = 'This field']) =>
      (v == null || v.trim().isEmpty) ? '$field is required' : null;

  static String? email(String? v) {
    final r = required(v, 'Email');
    if (r != null) return r;
    final ok = RegExp(r'^[\w.\-+]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(v!.trim());
    return ok ? null : 'Enter a valid email address';
  }

  static String? phone(String? v) {
    final r = required(v, 'Phone');
    if (r != null) return r;
    final digits = v!.replaceAll(RegExp(r'\D'), '');
    return (digits.length >= 7 && digits.length <= 15) ? null : 'Enter a valid phone number';
  }

  static String? age(String? v) {
    final r = required(v, 'Age');
    if (r != null) return r;
    final n = int.tryParse(v!.trim());
    if (n == null) return 'Age must be a number';
    return (n < 18 || n > 70) ? 'Age must be between 18 and 70' : null;
  }

  static String? password(String? v) {
    final r = required(v, 'Password');
    if (r != null) return r;
    return v!.length < 6 ? 'Password must be at least 6 characters' : null;
  }

  static String? name(String? v, String field) {
    final r = required(v, field);
    if (r != null) return r;
    return v!.trim().length < 2 ? '$field is too short' : null;
  }
}
