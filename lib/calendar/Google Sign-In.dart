import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      CalendarApi.calendarScope,
    ],
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Sign-in error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<AuthClient?> getAuthenticatedClient() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      print('Failed to get Google account');
      return null;
    }
    final authHeaders = await account.authHeaders;
    return authenticatedClient(
        http.Client(),
        AccessCredentials(
          AccessToken('Bearer', authHeaders['Authorization']!.substring(7),
              DateTime.now().add(Duration(hours: 1))),
          null,
          [CalendarApi.calendarScope],
        ));
  }
}
