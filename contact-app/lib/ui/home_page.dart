import 'dart:io';

import 'package:contact_app/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:contact_app/helpers/contact_helper.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(5),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: contacts[index].image != null
                              ? FileImage(File(contacts[index].image))
                              : AssetImage("images/person.jpg"))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    // Text(
                    //   contacts[index].email ?? "",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // Text(
                    //   contacts[index].phone ?? "",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          "Dial",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    //TODO: Add a link to open messaging app
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          "Message",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    //TODO: Add a link to open email app
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          "Email",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          "Edit",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextButton(
                        child: Text(
                          "Delete",
                          style:
                              TextStyle(color: Colors.deepOrange, fontSize: 18),
                        ),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }
}
