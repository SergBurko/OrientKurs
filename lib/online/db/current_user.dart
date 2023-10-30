import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CurrentUser {
  String id = "";
  String email = "";
  String name = "";
  bool isMaster = false;
  final DatabaseReference _reference = FirebaseDatabase.instance.ref();

  CurrentUser();

  CurrentUser.byFireBaseUserCredential(UserCredential userCredential,
      {isMaster = false}) {
    id = userCredential.user?.uid != null ? userCredential.user!.uid : "";
    email =
        userCredential.user?.email != null ? userCredential.user!.email! : "";
    name = userCredential.user?.displayName != null
        ? userCredential.user!.displayName!
        : "";
    if (isMaster) {
      this.isMaster = isMaster;
    }
  }

  CurrentUser.byFireBaseUser(User? user, {isMaster = false}) {
    if (user != null) {
      id = user.uid;
      email = user.email != null ? user.email! : "";
      name = user.displayName != null ? user.displayName! : "";
      if (isMaster) {
        this.isMaster = isMaster;
      }
    }
  }

  void writeUserData(String userId, String name, String email) {
    // final reference = FirebaseDatabase.instance.ref();
    _reference.child('cusers').child(userId).set({
      'name': name,
      'email': email,
      // Другие дополнительные данные, которые вы хотите сохранить
    });
  }

  Future<String> readUserData(String userId) async {
    late String str = "";
    try {
      DatabaseEvent ref = await _reference.child('cusers').child(userId).once();
      var data = ref.snapshot.value as Map<dynamic, dynamic>;
      if (data != null) {
        str = data['email'];
        print('Email from str: $str');
        // var currentUser = CurrentUser.fromMap(data);
        // print('Name: ${data['name']}');
        // print('Email: ${data['email']}');
        // Другие дополнительные данные
      } else {
        print('Данные не найдены');
      }
    } catch (e) {
      print(e);
    }
    return str;
  }
}
