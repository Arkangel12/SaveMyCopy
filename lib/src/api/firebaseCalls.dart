import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' show Client;
import 'package:savemycopy/src/api/backend.dart';

class FirebaseCalls {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Client client = Client();

  Future<String> handleGoogleSignIn() async {
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

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print(user.displayName);

    return 'Succeeded: ${user.displayName}';
  }

  // Profile image: Small size photo https://graph.facebook.com/{facebookId}/picture?type=small
  Future<FacebookProfile> handleFacebookSignIn() async {
    print('Entre a facebook login');
    FacebookProfile facebookProfile;
    final FacebookLogin _facebookLogin = FacebookLogin();
    var result = await _facebookLogin
        .loginWithPublishPermissions(['email', 'public_profile']);

    //    final FacebookAuthProvider facebookUser = FacebookAuthProvider();

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        final token = result.accessToken.token;
        final graphResponse = await client.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        facebookProfile = facebookProfileFromJson(graphResponse.body);
        break;
      case FacebookLoginStatus.cancelledByUser:
//        _showCancelledMessage();
        print('Canceled By User');
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }

    print(facebookProfile.name);

    return facebookProfile;
  }

  handleGoogleLogOut() => _googleSignIn.signOut;
}
