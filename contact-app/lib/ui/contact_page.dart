import 'dart:io';

import 'package:flutter/material.dart';
import 'package:contact_app/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _workController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
      _workController.text = _editedContact.work;
      _addressController.text = _editedContact.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(_editedContact.name ?? "New Contact"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: CircleAvatar(
                  radius: 70.0,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.image != null
                                ? FileImage(File(_editedContact.image))
                                : AssetImage("images/person.jpg"))),
                  ),
                ),
                onTap: () {
                  //PART TO CHANGE IMAGE
                  ImagePicker.pickImage(source: ImageSource.gallery)
                      .then((file) {
                    if (file == null) {
                      return;
                    } else {
                      setState(() {
                        _editedContact.image = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  hintText: 'Full Name',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  hintText: 'Phone',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  hintText: 'Work',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.work = text;
                },
                controller: _workController,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                  hintText: 'Address',
                  hintStyle: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.address = text;
                },
                controller: _addressController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard data?"),
              content: Text("You lost every data"),
              actions: <Widget>[
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
