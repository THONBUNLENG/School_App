import 'package:flutter/cupertino.dart';

class UserModel {
  final String name;
  final String enName;
  final String studentId;
  final bool campusAccess;

  const UserModel({
    required this.name,
    required this.enName,
    required this.studentId,
    required this.campusAccess,
  });
}

const currentUser = UserModel(
  name: '李伟',
  enName: 'Li Wei',
  studentId: '211001007',
  campusAccess: true,
);
class ServiceItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ServiceItem(this.title, this.icon, this.color, this.onTap);
}
