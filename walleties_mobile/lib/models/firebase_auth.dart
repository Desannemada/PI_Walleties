import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:walleties_mobile/models/main_view_model.dart';
import 'package:walleties_mobile/pages/login_screen.dart';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      if (user != null) {
        List<String> aux = [
          user.displayName == null ? "Username" : user.displayName,
          user.email != null ? user.email : "usuario@walleties.com",
          user.uid != null ? user.uid : "No ID",
          user.photoUrl != null
              ? user.photoUrl
                  .replaceAll("s96-c/photo.jpg", "photo.jpg")
                  .replaceAll("=s96-c", "")
              : "assets/profileImage.jpg"
        ];
        print("\nUserInfo: " + aux.toString() + "\n");
        return "Ok";
      } else {
        return "Error";
      }
    } catch (e) {
      print("Erro SignInWithEmail: " + e.toString());
      return e.message;
    }
  }

  Future<String> signup(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      List<String> aux = [
        user.displayName == null ? "Username" : user.displayName,
        user.email != null ? user.email : "usuario@walleties.com",
        user.uid != null ? user.uid : "No ID",
        user.photoUrl != null
            ? user.photoUrl
                .replaceAll("s96-c/photo.jpg", "photo.jpg")
                .replaceAll("=s96-c", "")
            : "assets/profileImage.jpg"
      ];
      // MainViewModel().updateUserInfo(aux);
      print("\nSigning up sucessfull: $email and $password\n");
      return "Ok";
    } catch (e) {
      print("\nSigning up unsucessfull\n");
      return e.toString();
    }
  }

  Future<String> loginWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (account == null) {
        return "Error";
      }
      AuthResult res = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(
          idToken: (await account.authentication).idToken,
          accessToken: (await account.authentication).accessToken,
        ),
      );
      if (res.user == null) {
        return "Error";
      } else {
        List<String> aux = [
          res.user.displayName == null ? "Username" : res.user.displayName,
          res.user.email != null ? res.user.email : "usuario@walleties.com",
          res.user.uid != null ? res.user.uid : "No ID",
          res.user.photoUrl != null
              ? res.user.photoUrl
                  .replaceAll("s96-c/photo.jpg", "photo.jpg")
                  .replaceAll("=s96-c", "")
              : "assets/profileImage.jpg"
        ];
        // MainViewModel().updateUserInfo(aux);
        return "Ok";
      }
    } catch (e) {
      print("\nErro LoginWithGoogle: " + e.toString() + "\n");
      return e.message;
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      MainViewModel().updateisConfigDown(false);
      MainViewModel().changeAtualLoginWidget(LoginScreenMenu());
    } catch (e) {
      print("\nErro Exit: " + e.toString() + "\n");
    }
  }
}
