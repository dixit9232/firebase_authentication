
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';
import 'create_notes.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  DatabaseReference reference =
      FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signOut()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: reference.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: snapshot.data!.snapshot.children.length,
                itemBuilder: (context, index) {
                  Map map = snapshot.data!.snapshot.value as dynamic;
                  List l = map.values.toList();
                  String title = l[index]['title'];
                  String notes = l[index]['notes'];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateNotes(l[index]),
                            ),
                            (route) => true);
                      },
                      title: Text(title),
                      subtitle: Text(
                        notes,
                        maxLines: 2,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            reference.child(l[index]['id']).remove();
                          },
                          icon: Icon(Icons.delete)),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return CreateNotes();
              },
            ), (route) => true);
          },
          child: Icon(Icons.add)),
    );
  }
}
