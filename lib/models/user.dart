import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.uid,
    required this.name,
    required this.sport,
    required this.job,
    required this.description,
    required this.avatar,
    required this.achivement,
    required this.about,
  });

  final String uid;
  final String name;
  final String sport;
  final String job;
  final String description;
  final String avatar;
  final String achivement;
  final String about;

  @override
  List<Object?> get props => [
        uid,
        name,
        sport,
        job,
        description,
        avatar,
        achivement,
        about,
      ];
}
