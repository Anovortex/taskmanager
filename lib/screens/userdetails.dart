import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskmanager/screens/reset_password.dart';
import 'package:taskmanager/screens/signin_screen.dart';
import 'package:taskmanager/utils/color_utils.dart';

class UserDetails {
  final String fullName;
  final String email;
  final String phoneNumber;

  UserDetails({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
  });
}

class UserDetailsForm extends StatefulWidget {
  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _auth = FirebaseAuth.instance;

  late TextEditingController _fullNameController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneNumberController = TextEditingController();

    // Retrieve current user's details from Firestore
    _fetchUserDetails();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Method to fetch user details from Firestore
  void _fetchUserDetails() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('userdetails')
            .doc(currentUser.uid)
            .get();

        // Update the text controllers with the existing user details
        if (userData.exists) {
          setState(() {
            _fullNameController.text = userData.get('fullName');
            _phoneNumberController.text = userData.get('phoneNumber');
          });
        }
      } catch (error) {
        print('Failed to fetch user details: $error');
      }
    }
  }

  void _saveUserDetails() async {
    // Validate user input
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Get the current user
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      // Handle scenario where current user is null (user not signed in)
      return;
    }

    // Save user details to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('userdetails')
          .doc(currentUser.uid)
          .set({
        'fullName': _fullNameController.text,
        'email': currentUser.email,
        'phoneNumber': _phoneNumberController.text,
      });

      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User details saved successfully.'),
        ),
      );
    } catch (error) {
      print('Failed to save user details: $error');
    }
  }

  // Method to handle user logout
  void _logout() async {
    try {
      await _auth.signOut();
      // Navigate to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (error) {
      print('Failed to log out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        backgroundColor: hexStringToColor(
            "627254"), // Set the background color to transparent
        elevation: 0, // Remove the shadow
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("627254"),
              hexStringToColor("76885B"),
              hexStringToColor("DDDDDD"),
              hexStringToColor("EEEEEE"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Email: ${_auth?.currentUser?.email ?? "SEx"}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _saveUserDetails,
                  child: Text('Save'),
                ),
                SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
