import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/realtime%20databse/notes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CreateNotes extends StatefulWidget {
  var l;

  CreateNotes([this.l]);

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  DatabaseReference reference =
      FirebaseDatabase.instance.ref(FirebaseAuth.instance.currentUser!.uid);
  TextEditingController titleController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  InsertData() async {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    await reference.child(id).set({
      'id': id,
      'title': titleController.text,
      'notes': notesController.text
    }).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Notes(),
          ),
          (route) => false);
    });
  }

  UpdateData() async {
    await reference
        .child(widget.l['id'])
        .update({'title': titleController.text, 'notes': notesController.text});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.l != null) {
      titleController.text = widget.l['title'];
      notesController.text = widget.l['notes'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (notesController.text != '') {
          if (widget.l != null) {
            UpdateData();
          } else {
            InsertData();
          }
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Add Notes',
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey.shade500)),
                  ),
                  TextField(
                    controller: notesController,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Notes',
                        border: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.grey.shade500)),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
