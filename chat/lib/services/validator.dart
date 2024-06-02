class UsernameValidator {
  settings(String username, String email) {
    if (validate(username) != null) {
      return validate(username);
    } else if (validateEmail(email) != null) {
      return validateEmail(email);
    } else {
      return null;
    }
  }

  validator(String username, String password, String password2) {
    if (validate(username) != null) {
      return validate(username);
    } else if (validatePassword(password, password2) != null) {
      return validatePassword(password, password2);
    } else {
      return null;
    }
  }

  static String? validate(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    } else if (username.length < 3) {
      return 'Username must be at least 3 characters long';
    } else if (username.length > 20) {
      return 'Username must be less than 20 characters long';
    } else if (!RegExp(r'^[a-z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain lowercase letters, numbers, and underscores';
    } else {
      return null;
    }
  }

  static String? validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (emailRegex.hasMatch(email)) {
      return null;
    } else {
      return "$email is not a valid email address.";
    }
  }

  static String? validatePassword(String? password, String? password2) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password2 == null || password2.isEmpty) {
      return 'Password is required';
    }
    if (password != password2) {
      return 'Passwords are not the same';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (password.length > 20) {
      return 'Password must be less than 20 characters long';
    }
    if (!RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
    }
    return null;
  }
}
