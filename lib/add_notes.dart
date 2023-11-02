import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/dashboard.dart';
import 'package:flutter/material.dart';

class AddNotesScreen extends StatefulWidget {
  var notes;

  AddNotesScreen([this.notes]);

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController titleContoller = TextEditingController();
  TextEditingController noteContoller = TextEditingController();

  late CollectionReference reference;

  ref() async {
    reference = await firestore.collection(auth.currentUser!.uid.toString());
  }

  AddData() {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    reference.doc(id).set({
      'id': id,
      'title': titleContoller.text,
      'notes': noteContoller.text
    }).then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Dashboard();
        },
      ));
    }).onError((error, stackTrace) {
      print(error);
    });
  }

  variableinit() {
    if (widget.notes != null) {
      if (widget.notes['title'] != '') {
        titleContoller.text = widget.notes['title'];
      }
      noteContoller.text = widget.notes['notes'];
    }
  }

  updateData() {
    reference
        .doc(widget.notes['id'])
        .update({'title': titleContoller.text, 'notes': noteContoller.text});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref();
    variableinit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.notes != null) {
          updateData();
        } else {
          if (noteContoller.text != '') {
            AddData();
          }
        }
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Notes',),
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
                    controller: titleContoller,
                    decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.grey.shade500)),
                  ),
                  TextField(
                    controller: noteContoller,
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
