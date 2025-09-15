import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'contact_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Contact? _selectedContact;
  final TextEditingController _contactController = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          height: screenHeight * 0.7,
          child: _buildFormWidget(context),
        );
      },
    );
  }

  Widget _buildFormWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _contactController,
            readOnly: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.contacts),
                onPressed: () async {
                  final selectedContact = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ContactPage()),
                  );

                  if (selectedContact != null && selectedContact is Contact) {
                    setState(() {
                      _selectedContact = selectedContact;
                      _contactController.text = selectedContact.displayName;

                      // If you want to show phone number too
                      if (selectedContact.phones.isNotEmpty) {
                        _contactController.text +=
                        " (${selectedContact.phones.first.number})";
                      }
                    });

                    // Close the contact page and return to bottom sheet
                    Navigator.of(context).pop();
                    _showBottomSheet(context); // Reopen bottom sheet
                  }
                },
              ),
              filled: true,
              fillColor: Colors.green.shade100,
              hintText: 'Select Contact',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Selection Demo'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showBottomSheet(context),
          child: Text('Show Contact Form'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }
}