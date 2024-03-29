import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' show Client;
import 'package:savemycopy/src/api/backend.dart';

class FirebaseCalls {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserProfile userProfile;

  var authenticated = false;

  final Client client = Client();

  Future<UserProfile> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    user.uid == null ? authenticated = false : authenticated = true;

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    var userString ='''{
      "name": "${user.displayName}",
      "first_name": "${user.displayName}",
      "last_name": "${user.displayName}",
      "email": "${user.email}",
      "photoUrl": "${user.photoUrl}",
      "id": "${user.uid}"
    }''';

    userProfile = userProfileFromJson(userString);

    return userProfile;
//    return 'Succeeded: ${user.displayName}';
  }

  // Profile image: Small size photo
  Future<UserProfile> handleFacebookSignIn() async {
//  Future<String> handleFacebookSignIn() async {
    var result = await _facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        final token = result.accessToken.token;
        final graphResponse = await client.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        userProfile = userProfileFromJson(graphResponse.body);
        print(graphResponse.body);
        authenticated = true;
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Canceled By User');
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }

    _facebookLogin.currentAccessToken == null ? authenticated = false : authenticated = true;
    print(userProfile.name);

    return userProfile;
//    return 'Succeeded: ${facebookProfile.name}';
  }

  handleLogOut() => _googleSignIn.currentUser != null
      ? _googleSignIn.signOut
      : _facebookLogin.logOut;
}
