import 'dart:convert';

class CustomJwtDecoder {
  /// Decodes a JWT token and returns the payload as Map<String, dynamic>.
  /// Throws [FormatException] if the token is invalid.
  static Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('JWT must have 3 parts');
    }

    try {
      final payload = _decodeBase64(parts[1]);
      return json.decode(payload);
    } catch (e) {
      throw const FormatException('Invalid JWT payload');
    }
  }

  /// Decodes the token safely. Returns null if an error occurs.
  static Map<String, dynamic>? tryDecode(String token) {
    try {
      return decode(token);
    } catch (_) {
      return null;
    }
  }

  /// Checks if the token is expired.
  static bool isExpired(String token) {
    final exp = _getTimeStampFromToken(token, 'exp');
    return DateTime.now().isAfter(exp);
  }

  /// Gets the expiration date from token.
  static DateTime getExpirationDate(String token) =>
      _getTimeStampFromToken(token, 'exp');

  /// Gets the issue date from token.
  static DateTime getIssuedAtDate(String token) =>
      _getTimeStampFromToken(token, 'iat');

  /// Gets the time passed since token was issued.
  static Duration getTokenAge(String token) =>
      DateTime.now().difference(getIssuedAtDate(token));

  /// Gets the time left before the token expires.
  static Duration getTimeUntilExpiry(String token) =>
      getExpirationDate(token).difference(DateTime.now());

  /// Helper: Base64 decode with proper padding.
  static String _decodeBase64(String str) {
    final normalized = base64.normalize(str);
    return utf8.decode(base64.decode(normalized));
  }

  /// Helper: Extracts and parses a timestamp from a claim.
  static DateTime _getTimeStampFromToken(String token, String claimKey) {
    final payload = decode(token);
    if (!payload.containsKey(claimKey)) {
      throw FormatException('Token does not contain "$claimKey"');
    }

    final seconds = payload[claimKey];
    if (seconds is! int) {
      throw FormatException('Claim "$claimKey" is not an integer');
    }

    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }
}
