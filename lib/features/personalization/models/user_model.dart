import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cri_v3/utils/constants/enums.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';

class CUserModel {
  String id;
  String fullName, businessName;
  final String email;
  String countryCode;

  String phoneNo;
  String currencyCode;
  String profPic;
  String locationCoordinates;
  String userAddress;
  CAppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  CUserModel({
    required this.id,
    required this.fullName,
    required this.businessName,
    required this.email,
    required this.countryCode,
    required this.phoneNo,
    required this.currencyCode,
    required this.profPic,
    required this.locationCoordinates,
    required this.userAddress,
    this.role = CAppRole.user,
    this.createdAt,
    this.updatedAt,
  });

  /// -- helper functions --
  String get formattedDate => CFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => CFormatter.formatDate(updatedAt);

  // === static function to split fullName into 1st & last names ===
  static List<String> nameParts(fullName) => fullName.split(" ");

  // === static function to create an empty user model ===
  static CUserModel empty() => CUserModel(
    id: '',
    fullName: '',
    businessName: '',
    email: '',
    countryCode: '',
    phoneNo: '',
    currencyCode: '',
    profPic: '',
    locationCoordinates: '',
    userAddress: '',
  );

  // to make it readable to firebase
  Map<String, dynamic> toJson() {
    return {
      "FullName": fullName,
      "BusinessName": businessName,
      "Email": email,
      "CountryCode": countryCode,
      "PhoneNo": phoneNo,
      "CurrencyCode": currencyCode,
      "ProfPic": profPic,
      "LocationCoordinates": locationCoordinates,
      "UserAddress": userAddress,
      "Role": role.name.toString(),
      "CreatedAt": createdAt,
      "UpdatedAt": updatedAt,
    };
  }

  // === factory method to create a UserModel from a Firebase document snapshot ===
  factory CUserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    if (document.data() != null) {
      final data = document.data()!;
      return CUserModel(
        id: document.id,
        fullName: data["FullName"] ?? '',
        businessName: data["BusinessName"],
        email: data["Email"] ?? '',
        countryCode: data["CountryCode"] ?? '',
        phoneNo: data["PhoneNo"] ?? '',
        currencyCode: data["CurrencyCode"] ?? '',
        profPic: data["ProfPic"] ?? '',
        locationCoordinates: data['LocationCoordinates'] ?? '',
        userAddress: data['UserAddress'] ?? '',
        role: data.containsKey('Role')
            ? (data['Role'] ?? CAppRole.user) == CAppRole.admin.name.toString()
                  ? CAppRole.admin
                  : CAppRole.user
            : CAppRole.user,
        createdAt: data.containsKey('CreatedAt')
            ? data['CreatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
        updatedAt: data.containsKey('UpdatedAt')
            ? data['UpdatedAt']?.toDate() ?? DateTime.now()
            : DateTime.now(),
      );
    } else {
      return CUserModel.empty();
    }
  }
}
