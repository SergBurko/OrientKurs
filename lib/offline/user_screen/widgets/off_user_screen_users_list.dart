import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/settings.dart';

class OffUserScreenUsersList extends StatefulWidget {
  const OffUserScreenUsersList({Key? key}) : super(key: key);

  @override
  _OffUserScreenUsersListState createState() => _OffUserScreenUsersListState();
}

class _OffUserScreenUsersListState extends State<OffUserScreenUsersList> {
  @override
  void initState() {
    super.initState();
    // loadUserList();
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return Container(
      decoration: const BoxDecoration(
            gradient:  LinearGradient(colors: [
          Color.fromARGB(255, 210, 222, 227),
          Color.fromARGB(255, 210, 222, 227)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Scaffold(
        
        appBar: AppBar(
          
          title: const Text('Nutzer', style: TextStyle(fontStyle: FontStyle.italic),),
        ),
        body: Container(
          
          child: Builder(builder: (context) {
            // return const Text ("");
            if (settings.users.isNotEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  itemCount: settings.users.length,
                  itemBuilder: (context, index) {
                    final quizUser = settings.users[index];
                    return ListTile(
                      title: Text(quizUser.quizUsername),
                      onTap: () {
                        settings.setDefaultUserName(quizUser.quizUsername);
                      },
                    );
                  },
                ),
              );
            } else {
              return const Text("No Users");
            }
          }),
        ),
      ),
    );
  }

  //   return SizedBox(
  //     height: 100,
  //     width: 100,
  //     child: Column(
  //       children: [
  //         if (users != null )
  //           for (var user in users!)
  //             Text(
  //                 user.quizUsername) // Приклад відображення списку користувачів
  //         else
  //         const Text("")
  //           // const CircularProgressIndicator(), // Відображення крутильного індикатора під час завантаження
  //       ],
  //     ),
  //   );
  // }
}
