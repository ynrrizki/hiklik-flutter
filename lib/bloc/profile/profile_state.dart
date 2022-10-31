part of 'profile_bloc.dart';

enum ProfileStatus { initial, success, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profiles = const <User>[],
    this.hasReachedMax = false,
  });

  final ProfileStatus status;
  final List<User> profiles;
  final bool hasReachedMax;

  ProfileState copyWith({
    ProfileStatus? status,
    List<User>? profiles,
    bool? hasReachedMax,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${profiles.length} }''';
  }

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}
