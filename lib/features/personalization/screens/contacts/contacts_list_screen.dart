import 'package:azlistview/azlistview.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  @override
  void initState() {
    super.initState();
    //_loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    return Obx(
      () {
        List<String> alphabet = List.generate(
          26,
          (i) => String.fromCharCode(65 + i),
        );
        return Scaffold(
          appBar: AppBar(title: Text("Contacts")),
          body: contactsController.groupedContacts.isEmpty
              ? Center(child: CircularProgressIndicator())
              : AzListView(
                  data: [], // The index bar letters
                  itemCount: alphabet.length,
                  itemBuilder: (context, index) {
                    String letter = alphabet[index];
                    List<CContactsModel> list =
                        contactsController.groupedContacts[letter] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section Header
                        Container(
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(8),
                          child: Text(
                            letter,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Contact List for this letter
                        ...list.map(
                          (contact) => ListTile(
                            leading: CircleAvatar(
                              child: Text(contact.contactName[0]),
                            ),
                            title: Text(contact.contactName),
                            subtitle: contact.contactPhone.isNotEmpty
                                ? Text(contact.contactPhone)
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}
