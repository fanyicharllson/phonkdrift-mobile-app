class ErrorHelper {
  ErrorHelper._();

  static String fromException(Object e, {ErrorContext ctx = ErrorContext.general}) {
    final raw = e.toString().toLowerCase();

    // ── Network layer ──────────────────────────────────────────────────────
    if (raw.contains('unavailable') || raw.contains('connection refused') ||
        raw.contains('network')) {
      return 'No connection to server. Check your internet and try again.';
    }
    if (raw.contains('deadline exceeded') || raw.contains('timeout')) {
      return 'Request timed out. Server is taking too long — try again.';
    }

    // ── Auth-specific ──────────────────────────────────────────────────────
    if (ctx == ErrorContext.login) {
      if (raw.contains('invalid') || raw.contains('not found') ||
          raw.contains('unauthenticated') || raw.contains('incorrect')) {
        return 'Incorrect email or password. Please check and try again.';
      }
      if (raw.contains('not verified') || raw.contains('unverified')) {
        return 'Your account is not verified yet. Check your email for the code.';
      }
    }

    if (ctx == ErrorContext.register) {
      if (raw.contains('already exists') || raw.contains('duplicate') ||
          raw.contains('unique')) {
        return 'An account with this email already exists. Try logging in.';
      }
      if (raw.contains('username')) {
        return 'This username is already taken. Choose another.';
      }
    }

    if (ctx == ErrorContext.verify) {
      if (raw.contains('invalid') || raw.contains('incorrect') ||
          raw.contains('wrong')) {
        return 'Incorrect code. Double-check the email we sent you.';
      }
      if (raw.contains('expired')) {
        return 'This code has expired. Request a new one below.';
      }
    }

    if (ctx == ErrorContext.resetPassword) {
      if (raw.contains('expired')) {
        return 'Your reset code has expired. Request a new one.';
      }
      if (raw.contains('invalid') || raw.contains('incorrect')) {
        return 'Incorrect reset code. Check your email and try again.';
      }
      if (raw.contains('at least 6') || raw.contains('password must')) {
        return 'Password must be at least 6 characters long.';
      }
    }

    // ── Surface actual gRPC message if readable ────────────────────────────
    final msgMatch = RegExp(r'message: (.+?)(?:\n|$)').firstMatch(e.toString());
    if (msgMatch != null) {
      final msg = msgMatch.group(1)!.trim();
      if (msg.isNotEmpty && !msg.contains('rpc error')) return msg;
    }

    return 'Something went wrong. Please try again.';
  }
}

enum ErrorContext { general, login, register, verify, resetPassword }
