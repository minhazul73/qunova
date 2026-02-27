import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  static const String name = 'contacts';

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
     Future.delayed(const Duration(seconds: 2), () {
      EasyLoading.dismiss();
    });
    return const Scaffold(
      body: Center(
        child: Text('Contacts (placeholder)'),
      ),
    );
  }
}
