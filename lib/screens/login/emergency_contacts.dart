// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:userapp/base_client.dart';
import 'package:userapp/models/snackbar.dart';
import 'package:userapp/screens/home/home.dart';
import 'package:userapp/screens/login/invite_ice.dart';
import 'package:userapp/widgets/button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class EmergencyContactsScreen extends StatefulWidget {
  static const routeName = '/emergency-contacts';
  const EmergencyContactsScreen({super.key});
  static const relationshipEntries = [
    'Father',
    'Mother',
    'Sibling',
    'Grandparent',
    'Friend',
    'Neighbour'
  ];
  //TODO:Add 'Husband/Spouse' and 'Child' as entries too

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _contactsController = TextEditingController();
  final _relationshipController = TextEditingController();
  bool editOption = false;
  final _iceContacts = [];
  var _mobileNo = "";
  PermissionStatus _contactPermissionStatus = PermissionStatus.denied;
  Uint8List? _avatar;
  var auth = BaseClient().auth;

  void _requestContactsPermission() async {
    _contactPermissionStatus = await Permission.contacts.request();
    setState(() {});
    if (_contactPermissionStatus.isGranted) {
      return;
    } else if (_contactPermissionStatus.isDenied) {
      _requestContactsPermission();
    } else if (_contactPermissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void fetchContacts() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final c = await ContactsService.openDeviceContactPicker().catchError((_) {
      print('Contact Form Closed');
      return null;
    });
    if (c == null) {
      return;
    }
    if (c.phones!.isEmpty) {
      showSnackbarOnScreen(context, "Chosen contact has no number registered");
      _contactsController.clear();
      return;
    }
    if (BaseClient()
        .auth
        .currentUser!
        .phoneNumber!
        .contains(c.phones![0].value!)) {
      showSnackbarOnScreen(context, "You can't add yourself as an ICE Contact");
      return;
    }
    final re = RegExp(r'\s*\(*\)*-*');

    c.phones = c.phones!
        .map((e) {
          e.value = e.value!.split(re).join();
          e.value = e.value!.substring(e.value!.length - 10);
          return Item(label: e.label, value: e.value);
        })
        .toSet()
        .toList();

    _avatar = await ContactsService.getAvatar(c);

    if (c.phones!.length > 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (ctx) => AlertDialog(
                actions: [
                  Theme(
                    data: Theme.of(ctx).copyWith(
                        colorScheme:
                            ColorScheme.fromSeed(seedColor: Colors.red)),
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        textScaleFactor: 1.2,
                      ),
                    ),
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center,
                title: Text(
                  'Choose number for ${c.givenName}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                scrollable: true,
                content: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: c.phones!
                      .map((e) => GestureDetector(
                            onTap: () {
                              _contactsController.text = c.displayName!;
                              _mobileNo = e.value!;
                              Navigator.of(context).pop();
                            },
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    e.value!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                            )),
                          ))
                      .toList(),
                )),
              ));
    } else {
      _contactsController.text = c.displayName!;
      _mobileNo = c.phones![0].value!;
    }
  }

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _contactsController.dispose();
    _relationshipController.dispose();
  }

  Future<bool> save() async {
    List<Map<String, String>> l = [];
    for (var row in _iceContacts) {
      l.add({
        "name": row[0],
        "phoneNo": row[1],
        "relation": row[2],
      });
    }
    final body = json.encode({"data": l});

    final url =
        Uri.parse('${Constants.baseUrl}/user/add_multiple_ice_contacts/');
    String? authToken;
    try {
      authToken = await BaseClient().getAuthToken();
      var response = await http.post(
        url,
        headers: {
          'Authorization': authToken!,
          'Content-Type': 'application/json'
        },
        body: body,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        showSnackbarOnScreen(context, 'ICE Contacts registered successfully');
        return true;
      } else {
        showSnackbarOnScreen(context, 'There was an error');
        return false;
      }
    } on Exception catch (_) {
      showSnackbarOnScreen(context, 'Eroorrrrer');
      return false;
    }
  }

  Future<List?> getAlreadySavedContacts() async {
    String? authToken;
    List? l;
    try {
      authToken = await BaseClient().getAuthToken();
      var response = await http.get(
          Uri.parse("${Constants.baseUrl}/user/get_ice_contacts/"),
          headers: {
            'Authorization': authToken!,
          });
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        l = data['data'];
      } else {
        print("Not a status code of 200");
      }
    } catch (e) {
      print("Exception caught");
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 32);
    const smallgap = SizedBox(height: 16);
    final deviceWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      floatingActionButton: !_contactPermissionStatus.isGranted
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  editOption = !editOption;
                });
              },
              tooltip: editOption ? 'Done' : 'Edit',
              icon:
                  editOption ? const Icon(Icons.done) : const Icon(Icons.edit),
              label: editOption
                  ? const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  : const Text(
                      'Edit',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
      appBar: const CustomAppBar('ICE Contacts'),
      body: !_contactPermissionStatus.isGranted
          ? Center(
              child: GestureDetector(
                  onTap: () => showSnackbarOnScreen(
                      context, 'Add Contacts Permissions to enable the screen'),
                  child: const CircularProgressIndicator()))
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.061),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    gap,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          editOption = false;
                        });
                        fetchContacts();
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _contactsController,
                          decoration: const InputDecoration(
                            labelText: "Emergency Contacts",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    gap,
                    AbsorbPointer(
                      absorbing: editOption,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          AbsorbPointer(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: "Relationship",
                                border: OutlineInputBorder(),
                              ),
                              controller: _relationshipController,
                            ),
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              items: EmergencyContactsScreen.relationshipEntries
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                _relationshipController.text = value!;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    smallgap,
                    AbsorbPointer(
                      absorbing: editOption,
                      child: CustomFilledButton(
                          onPressed: () {
                            if (_contactsController.text.isEmpty ||
                                _relationshipController.text.isEmpty) {
                              showSnackbarOnScreen(
                                  context, 'Enter Complete Details');
                              return;
                            }
                            for (var row in _iceContacts) {
                              if (row[0] == _contactsController.text ||
                                  row[1] == _mobileNo) {
                                showSnackbarOnScreen(
                                    context, 'Please add unique contacts only');
                                _mobileNo = "";
                                _contactsController.clear();
                                _relationshipController.clear();
                                return;
                              }
                            }
                            _iceContacts.add([
                              _contactsController.text,
                              _mobileNo,
                              _relationshipController.text,
                              _avatar
                            ]);
                            setState(() {});
                            _mobileNo = "";
                            _contactsController.clear();
                            _relationshipController.clear();
                            _avatar = null;
                          },
                          child: const Text(
                            "Add",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                    smallgap,
                    if (_iceContacts.isNotEmpty)
                      Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.spaceAround,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: _iceContacts.map((e) {
                          Uint8List? a = e[3];
                          return Stack(
                            alignment: AlignmentDirectional.topEnd,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.indigo),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8))),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
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
                                  // dense: true,
                                  title: Text(e[0],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                    e[1],
                                    style:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  trailing: Text(
                                    e[2],
                                    textScaleFactor: 1.5,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  // contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              if (editOption)
                                Positioned(
                                  top: -8,
                                  height: 32,
                                  width: deviceWidth * 0.06,
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() => _iceContacts.remove(e));
                                    },
                                    child: Icon(
                                      Icons.remove_circle,
                                      color: Colors.red[800],
                                      size: 24,
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                    smallgap,
                    AbsorbPointer(
                      absorbing: editOption,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomOutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Back",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.indigoAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          CustomFilledButton(
                            onPressed: () async {
                              if (_iceContacts.length < 5) {
                                showSnackbarOnScreen(
                                    context, 'Please add atleast 5 contacts');
                                return;
                              }
                              List? l = await getAlreadySavedContacts();
                              try {
                                if (l != null) {
                                  for (var contact in l) {
                                    for (var row in _iceContacts) {
                                      if (row[1] == contact['phoneNo'] ||
                                          (row[0] == contact['name'] &&
                                              row[2] == contact['relation'])) {
                                        _iceContacts.remove(row);
                                        break;
                                      }
                                    }
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                              if (_iceContacts.isEmpty) {
                                showSnackbarOnScreen(
                                    context, 'No new contacts to invite');
                                Future.delayed(
                                    const Duration(seconds: 3),
                                    () => Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            Home.routeName, (route) => false));
                                return;
                              }
                              await save().then((value) {
                                if (value) {
                                  try {
                                    Navigator.of(context).pushNamed(
                                        InviteContacts.routeName,
                                        arguments: _iceContacts);
                                  } on Exception catch (e) {
                                    print(e);
                                  }
                                } else {
                                  print('Failure');
                                }
                              });
                            },
                            child: Text(
                              "Next",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    gap,
                    gap,
                  ],
                ),
              ),
            ),
    );
  }
}
