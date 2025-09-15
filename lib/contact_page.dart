import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> _contacts = [];
  bool _permissionGranted = false;
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _askPermission();
  }

  Future<void> _askPermission() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
      });
      await _fetchContacts();
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> _fetchContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        List<Contact> contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: false,
        );
        debugPrint('------------------Contact_List_Begin----------------');
        for(var contact in contacts){
          debugPrint(contact.toString());
        }
        debugPrint('------------------Contact_List_End----------------');
        setState(() {
          _contacts = contacts;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching contacts: $e')),
      );
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    setState(() {
      _isLoading = false;
    });
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
      SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }
    return _contacts.where((contact) {
      final name = contact.displayName.toLowerCase();
      final phones = contact.phones.map((phone) => phone.number).join(' ');
      return name.contains(_searchQuery.toLowerCase()) ||
          phones.contains(_searchQuery);
    }).toList();
  }

  void _onContactSelected(Contact contact) {
    Navigator.pop(context, contact);
  }

  Widget _buildContactList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (!_permissionGranted) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Permission required to access contacts'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _askPermission,
              child: Text('Grant Permission'),
            ),
          ],
        ),
      );
    }

    if (_filteredContacts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(_searchQuery.isEmpty
                ? 'No contacts found'
                : 'No contacts matching "$_searchQuery"'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return ListTile(
          leading: contact.photo != null
              ? CircleAvatar(
            backgroundImage: MemoryImage(contact.photo!),
            radius: 20,
          )
              : CircleAvatar(
            child: Text(
              contact.displayName.isNotEmpty
                  ? contact.displayName[0].toUpperCase()
                  : '?',
            ),
            radius: 20,
          ),
          title: Text(
            contact.displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: contact.phones.isNotEmpty
              ? Text(contact.phones.first.number)
              : Text('No phone number'),
          onTap: () => _onContactSelected(contact),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _buildContactList(),
          ),
        ],
      ),
    );
  }
}