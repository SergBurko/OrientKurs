import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:second_quiz/online/db/current_user.dart';

class AuthServices extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  late GoogleSignInAccount? _googleSignInAccount;
  CurrentUser currentUser = CurrentUser();

  isAutorized () async {
    return  await GoogleSignIn(scopes: ['email']).isSignedIn();
  }

  setCurrentUserByFirebaseUser (User? user){

    currentUser = CurrentUser.byFireBaseUserCredential(signInWithGoogle());
    notifyListeners(); 
  }

  signInWithGoogle () async {
    try {
    
    _googleSignInAccount =  await _googleSignIn.signIn();

    GoogleSignInAuthentication? googleAuth = await  _googleSignInAccount?.authentication;

    AuthCredential authCredentials =  GoogleAuthProvider.credential(accessToken: googleAuth?.accessToken, idToken:  googleAuth?.idToken);

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(authCredentials);

    // return userCredential;
    } catch (e) {
      print("ERROR: $e"); 
    }
  }

  signInAsAnonymous() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  }

  clearCurrentUser (){
    currentUser = CurrentUser();
    notifyListeners();
  }

  signOutFromGoogle () async {
     try {
      // _googleSignInAccount = await _googleSignIn.signOut();
      await _googleSignInAccount!.clearAuthCache();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();

    } catch (error) {
      print('Error: $error');
    }
  }

}