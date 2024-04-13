// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:userapp/base_client.dart';
import 'package:userapp/models/snackbar.dart';
import 'package:userapp/screens/login/emergency_contacts.dart';
import 'package:userapp/widgets/button.dart';

import '../../constants.dart';
import '../../widgets/text_icon.dart';

import 'package:http/http.dart' as http;

class FormInputTextField extends StatelessWidget {
  final String labelText;
  TextEditingController? textController;
  final String? Function(String?)? validator;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatter;
  int? maxLines;
  bool enabled;
  FormInputTextField({
    super.key,
    required this.labelText,
    required this.textController,
    required this.validator,
    this.keyboardType,
    this.inputFormatter,
    this.maxLines,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      controller: textController,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatter,
      maxLines: maxLines,
      textInputAction: TextInputAction.done,
      enabled: enabled,
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreen2State();
}

class _SignUpScreen2State extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  bool _isPermanentAddressSameAsTemporary = false;

  final _currentUser = BaseClient().auth.currentUser!;

  //Controllers
  late final _controllers = {
    "name": TextEditingController(text: _currentUser.displayName),
    "bloodGroup": TextEditingController(),
    'dob': TextEditingController(),
    'phone': TextEditingController(
        text: _currentUser.phoneNumber!
            .substring(_currentUser.phoneNumber!.length - 10)),
    'altPhone': TextEditingController(),
    'tempAddress': TextEditingController(),
    'permAddress': TextEditingController(),
    'occupation': TextEditingController(),
    'travel': TextEditingController(),
  };

  void _showBloodGroupPicker() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: const TextIcon(["A", "B", "AB", "O"]),
          );
        }).then((value) {
      setState(() {
        if (value != null) {
          _controllers['bloodGroup']!.text = value;
        }
      });
    });
  }

  void _showDOBPicker(DateTime? selectedDate) {
    showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now())
        .then((value) {
      setState(() {
        if (value != null) {
          _controllers['dob']!.text = DateFormat('dd/MM/yyyy').format(value);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    //TODO: Exception happening here
    for (var k in _controllers.values) {
      k.dispose();
    }
  }

  Future<bool> save() async {
    final dob = DateFormat('yyyy-MM-dd')
        .format(DateFormat('dd/MM/yyyy').parse(_controllers['dob']!.text));
    final url = Uri.parse("${Constants.baseUrl}/signup");
    print('url = $url');
    String? authToken;
    String? fcmToken;
    try {
      fcmToken = await BaseClient().getFCMToken();
      final body = json.encode({
        "name": _controllers['name']!.text,
        "bloodgroup": _controllers['bloodGroup']!.text,
        "dateofbirth": dob,
        "phoneNo": _controllers['phone']!.text,
        "altphoneNo": _controllers['altPhone']!.text,
        "tempAddress": _controllers['tempAddress']!.text,
        "permAddress": _controllers['permAddress']!.text,
        "occupation": _controllers['occupation']!.text,
        "travel": _controllers['travel']!.text,
        "registrationToken": fcmToken,
      });
      print(body);
      authToken = await BaseClient().getAuthToken();
      if (authToken == null) {
        return false;
      }
      var response = await http.post(
        url,
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print(response.body);
      if (response.statusCode == 201) {
        showSnackbarOnScreen(context, 'Sign Up Details Added');
        return true;
      } else if (response.statusCode == 403) {
        showSnackbarOnScreen(context, 'User Already Exists');
      } else if (response.statusCode == 500) {
        showSnackbarOnScreen(context, 'Internal Server Error');
      }
    } on Exception catch (e) {
      print(e);
      showSnackbarOnScreen(context, 'Error');
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    final deviceWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar('Sign Up'),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.061),
            child: Form(
                key: _form,
                child: Column(
                  children: [
                    gap,
                    FormInputTextField(
                        labelText: "Name",
                        textController: _controllers['name'],
                        enabled: false,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Enter your name';
                          }
                          return null;
                        }),
                    gap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: deviceWidth * 0.4,
                            child: GestureDetector(
                                onTap: () => _showBloodGroupPicker(),
                                child: AbsorbPointer(
                                    child: FormInputTextField(
                                        labelText: 'Blood Group',
                                        textController:
                                            _controllers['bloodGroup'],
                                        validator: (value) {
                                          if (value! == "") {
                                            return 'Choose Blood Group';
                                          }
                                          return null;
                                        })))),
                        SizedBox(
                            width: deviceWidth * 0.4,
                            child: GestureDetector(
                                onTap: () => _showDOBPicker(
                                    _controllers['dob']!.text == ""
                                        ? DateTime.now()
                                        : DateFormat('dd/MM/yyyy')
                                            .parse(_controllers['dob']!.text)),
                                child: AbsorbPointer(
                                    child: FormInputTextField(
                                        labelText: 'D.O.B',
                                        textController: _controllers['dob'],
                                        validator: (value) {
                                          if (_controllers['dob']!.text == '') {
                                            return 'Enter DOB';
                                          }
                                          return null;
                                        })))),
                      ],
                    ),
                    gap,
                    FormInputTextField(
                        labelText: 'Phone No',
                        textController: _controllers['phone'],
                        keyboardType: TextInputType.phone,
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        enabled: false,
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Enter Valid Mobile Number';
                          }
                          return null;
                        }),
                    gap,
                    FormInputTextField(
                        labelText: 'Alternate Phone Number',
                        textController: _controllers['altPhone'],
                        keyboardType: TextInputType.phone,
                        inputFormatter: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value == "") {
                            return 'Enter mobile number';
                          }
                          if (value.length != 10) {
                            return 'Enter Valid Mobile Number';
                          }
                          //TODO: Do we need 2 different phone numbers? If yes, should we authorize both of them?
                          return null;
                        }),
                    gap,
                    FormInputTextField(
                      labelText: 'Temporary Address',
                      textController: _controllers['tempAddress'],
                      maxLines: 2,
                      validator: (value) {
                        if (value == null) {
                          return 'Enter temporary address';
                        }
                        if (value.length < 15) {
                          return 'Enter Complete Address';
                        }
                        return null;
                      },
                    ),
                    gap,
                    CheckboxListTile(
                      value: _isPermanentAddressSameAsTemporary,
                      onChanged: (newValue) {
                        if (newValue == null) {
                          return;
                        } else if (newValue) {
                          _isPermanentAddressSameAsTemporary = true;
                          _controllers['permAddress'] =
                              _controllers['tempAddress']!;
                        } else {
                          _isPermanentAddressSameAsTemporary = false;
                          _controllers['permAddress'] =
                              TextEditingController.fromValue(
                                  _controllers['tempAddress']!.value);
                        }

                        setState(() {});
                      },
                      title: const Text(
                          "Permanent Address the same as your Temporary Address?"),
                    ),
                    gap,
                    FormInputTextField(
                        labelText: 'Permanent Address',
                        textController: _controllers['permAddress'],
                        maxLines: 2,
                        validator: (value) {
                          if (value == null) {
                            return 'Enter temporary address';
                          }
                          if (value.length < 15) {
                            return 'Enter Complete Address';
                          }
                          return null;
                        }),
                    gap,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: deviceWidth * 0.4,
                            child: FormInputTextField(
                                labelText: 'Occupation',
                                textController: _controllers['occupation'],
                                validator: (value) {
                                  if (value == null || value.length < 3) {
                                    return 'Enter occupation';
                                  }
                                  return null;
                                })),
                        SizedBox(
                            width: deviceWidth * 0.4,
                            child: FormInputTextField(
                                labelText: 'Travel',
                                textController: _controllers['travel'],
                                validator: (value) {
                                  if (value == null || value.length < 3) {
                                    return 'Enter method of travel';
                                  }
                                  return null;
                                })),
                      ],
                    ),
                    gap,
                    CustomFilledButton(
                      onPressed: () {
                        if (_form.currentState!.validate()) {
                          save().then((value) {
                            if (value) {
                              print('Save successful');
                              Navigator.of(context).pushReplacementNamed(
                                  EmergencyContactsScreen.routeName);
                            }
                          });
                        }
                      },
                      child: const Text("Next"),
                    ),
                    gap,
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
