class User {
  late String? name;
  String? bloodGroup;
  DateTime? birthday;
  String? phone;
  String? phone2;
  String? tempAddress;
  String? permAddress;
  String? occupation;
  String? travel;
  List<dynamic>? iceContacts;

  User({
    this.name,
    this.bloodGroup,
    this.birthday,
    this.occupation,
    this.permAddress,
    this.tempAddress,
    this.phone,
    this.phone2,
    this.travel,
    this.iceContacts,
  });
}

void updatePage1(User currentUser, Map<String, dynamic> newValues) {
  final updateMap = {
    'name': () => currentUser.name = newValues['name'],
    'bloodGroup': () => currentUser.bloodGroup = newValues['bloodGroup'],
    'birthday': () => currentUser.birthday = newValues['birthday'],
    'occupation': () => currentUser.occupation = newValues['occupation'],
    'permAddress': () => currentUser.permAddress = newValues['permAddress'],
    'tempAddress': () => currentUser.tempAddress = newValues['tempAddress'],
    'phone': () => currentUser.phone = newValues['phone'],
    'phone2': () => currentUser.phone2 = newValues['phone2'],
    'travel': () => currentUser.travel = newValues['travel'],
    'iceContacts': () => currentUser.iceContacts = newValues['iceContacts'],
  };
  for (String v in newValues.keys) {
    updateMap[v]!();
  }
}
