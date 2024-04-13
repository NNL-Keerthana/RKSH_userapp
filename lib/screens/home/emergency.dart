import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:userapp/base_client.dart';
import 'package:userapp/constants.dart';
import 'package:userapp/models/snackbar.dart';

import '../../gmaps/search_bar.dart';
import '../../widgets/button.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _injuredPatients = TextEditingController(text: "1");
  String? _chosenEmergency;
  late String victimStatus;
  final hospitalname = TextEditingController();
  List emergencies = ["Accident", "Neonatal", "Pregnancy"];

  final MaterialStateProperty<Icon?> autoSelectHospitalIcon =
      MaterialStateProperty.resolveWith(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  bool autoSelectHospital = true;
  bool reportDisabled = true;

  @override
  void dispose() {
    _injuredPatients.dispose();
    hospitalname.dispose();
    super.dispose();
  }

  Future<String?> reportEmergency() async {
    final url = Uri.parse('${Constants.baseUrl}/user/create_trip_request/');
    String? authToken;
    try {
      authToken = await BaseClient().getAuthToken();
      var response = await http.post(
        url,
        headers: {
          'Authorization': authToken!,
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 16);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.061),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: const Color.fromRGBO(96, 124, 199, 1),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).width * 0.3,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageIcon(
                          AssetImage("assets/body-scan.png"),
                          color: Colors.white,
                        ),
                        Text(
                          "Scan",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                Card(
                  color: const Color.fromRGBO(96, 124, 199, 1),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).width * 0.3,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contact_emergency,
                            color: Colors.white,
                          ),
                          Text(
                            "Patient ID",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
            gap,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "No. of people injured",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: const Color.fromRGBO(158, 165, 173, 1)),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            int val = int.parse(_injuredPatients.text) - 1;
                            if (val <= 0) {
                              _injuredPatients.value =
                                  const TextEditingValue(text: '1');
                            } else {
                              _injuredPatients.value =
                                  TextEditingValue(text: val.toString());
                            }
                          },
                          child: const Icon(
                            Icons.remove_circle,
                            color: Colors.indigoAccent,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.08,
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _injuredPatients,
                              style: Theme.of(context).textTheme.headlineSmall!,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            int val = int.parse(_injuredPatients.text) + 1;
                            if (val > 6) {
                              _injuredPatients.value =
                                  const TextEditingValue(text: '6');
                            } else {
                              _injuredPatients.value =
                                  TextEditingValue(text: val.toString());
                            }
                          },
                          child: const Icon(Icons.add_circle,
                              color: Colors.indigoAccent),
                        ),
                      ],
                    )
                  ],
                ),
                const Text(
                  "Hospital",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                    // color: Theme.of(context).primaryColor,
                  ),
                ),
                AbsorbPointer(
                  absorbing: autoSelectHospital,
                  child: const PlaceSearchBar(),
                ),
                gap,
                const Text(
                  "Nature of Emergency",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                DropdownButton2(
                  value: _chosenEmergency,
                  isExpanded: true,
                  hint: const Text("Choose one"),
                  items: emergencies
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _chosenEmergency = value;
                      reportDisabled = false;
                    });
                  },
                ),
              ],
            ),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: autoSelectHospital,
                  thumbIcon: autoSelectHospitalIcon,
                  onChanged: (bool value) {
                    setState(() {
                      autoSelectHospital = value;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  "Auto Select Hospital?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            gap,
            SizedBox(
              width: double.infinity,
              child: Center(
                child: CustomFilledButton(
                  onPressed: reportDisabled
                      ? null
                      : () async {
                          reportEmergency().then((value) {
                            if (value != null) {
                              showSnackbarOnScreen(context,
                                  'Notifications sent to your ICE Contacts\n$value');
                            } else {
                              showSnackbarOnScreen(context,
                                  'Notifications could not be sent to your ICE Contacts');
                            }
                          });
                        },
                  child: Text(
                    "Report",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
