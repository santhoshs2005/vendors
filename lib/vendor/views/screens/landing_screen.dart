import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vendor_app_only/vendor/models/vendor_user_models.dart';
import 'package:vendor_app_only/vendor/views/auth/vendor_register_screen.dart';
import 'package:vendor_app_only/vendor/views/screens/main_vendor_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final CollectionReference _vendorsStream =
        FirebaseFirestore.instance.collection('vendors');

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          if (!snapshot.data!.exists) {
            return VendorRegisterScreen();
          }

          // Convert Firestore document data to VendorUserModel
          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          if (vendorUserModel.approved == true) {
            return MainVendorScreen();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    vendorUserModel.storeImage ?? toString(),
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  vendorUserModel.bussinessName ?? toString(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Your Application has been sent to Farmer admin\nAdmin will get back to you soon',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: Text('Sign out'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
