import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:userapp/base_client.dart';
import 'package:userapp/constants.dart';
import 'package:userapp/screens/home/home.dart';
import 'package:userapp/widgets/button.dart';

class InviteContacts extends StatelessWidget {
  static const routeName = '/invite';
  const InviteContacts({super.key});

  @override
  Widget build(BuildContext context) {
    var contacts = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: const CustomAppBar('Invite Contacts'),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.03),
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            if (contacts.isEmpty) const Text("No new contacts to add"),
            if (contacts.isNotEmpty)
              ...contacts.map((e) {
                Uint8List? a = e[3];
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.indigo),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  margin: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: MediaQuery.sizeOf(context).width * 0.03),
                  child: ListTile(
                    leading: !(a == null)
                        ? CircleAvatar(
                            foregroundImage: MemoryImage(a),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person_2_rounded,
                            ),
                          ),
                    dense: true,
                    title: Text(e[0],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      e[1],
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: FilledButton.tonalIcon(
                      onPressed: () async {
                        // Share.share(
                        //     'Invite People to start using RKSH Impact User App');
                        var s =
                            "Hi ${e[0]}\nI invite you to use RKSH User App and save lives!!";
                        var url = Uri.http('wa.me', "/${e[1]}", {"text": s});
                        print(url);
                        await BaseClient().launchBrowserWithUrl(url);
                      },
                      label: const Icon(Icons.open_in_new),
                      icon: const Text(
                        "Invite",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    // contentPadding: EdgeInsets.zero,
                  ),
                );
              }).toList(),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Home.routeName, (route) => false);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: Colors.blue),
                    )),
                CustomFilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          Home.routeName, (route) => false);
                    },
                    child: const Text('Done'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
