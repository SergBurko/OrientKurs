import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OnQuizUser {
  final String id;
  String name = "";
  String email = "";

  OnQuizUser(this.id, this.name, {this.email = ""});

  OnQuizUser.empty(this.id);

  Future<OnQuizUser> readLastFromDB() async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await firestoreInstance.collection('user').doc(id).get();

      //   QuerySnapshot querySnapshot = await firestoreInstance
      // .collection('user')
      // .doc(id)
      // .get()
      // .then((value) =>
      //     _fillByDBValue(value as Map<String, dynamic>, value.id));

      if (docSnapshot.exists) {
        _fillByDBValue(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        addThisToDB();
      }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return this;
    }
  }

  addThisToDB() async {
    if (id.isNotEmpty) {
      final firestoreInstance = FirebaseFirestore.instance;

      try {
        // Если нет документов, создайте новый
        await firestoreInstance
            .collection('user')
            .doc(id)
            .set({'name': name, 'email': email});
        // print('OnQuiz успешно записан.');
      } catch (e) {
        print(e);
      }
    }
    // return this;
  }


  byFirebaseAuthUser(User? user, {isMaster = false}) {
    if (user != null) {
      email = user.email != null ? user.email! : "";
      name = user.displayName != null ? user.displayName! : "";
    }
    return this;
  }

  _fillByDBValue(Map<String, dynamic> value, String id) {
    id = id;
    name = value["name"] ?? "";
    email = value["email"] ?? "";
    return;
  }
}
