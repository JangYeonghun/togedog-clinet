class UserAccount {
  UserAccount._init();
  static final UserAccount _instance = UserAccount._init();
  factory UserAccount() => _instance;

  int? _uuid;
  String? _email;
  String? _name;
  String? _platform;
  String? _phoneNumber;

  int? getUUID() => _uuid;
  void setUUID(int? uuid) => _uuid = uuid;

  String? getEmail() => _email;
  void setEmail(String? email) => _email = email;

  String? getName() => _name;
  void setName(String? name) => _name = name;

  String? getPlatform() => _platform;
  void setPlatform(String? platform) => _platform = platform;

  String? getPhoneNumber() => _phoneNumber;
  void setPhoneNumber(String? phoneNumber) => _phoneNumber = phoneNumber;

  void set({required Map<String, dynamic> map}) {
    _uuid = map['uuid'];
    _email = map['email'];
    _name = map['name'];
    _platform = map['platform'];
    _phoneNumber = map['phoneNumber'];
  }
}