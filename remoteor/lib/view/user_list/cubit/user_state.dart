part of 'user_cubit.dart';

// import 'package:linkify/widgets/uis/models/album_model.dart';
// import 'package:linkify/widgets/uis/models/loading_enum.dart';
// import 'package:linkify/widgets/uis/models/song_model.dart';

class UserState {
  final LoadPage status;
  final List<MyUserInfo> users;
  UserState({
    required this.status,
    required this.users,
  });
  factory UserState.initial() {
    return UserState(
      status: LoadPage.initial,
      users: [],
    );
  }

  UserState copyWith({
    LoadPage? status,
    List<MyUserInfo>?users
  }) {
    return UserState(
      status: status ?? this.status,
      users: users ?? this.users,
    );
  }
}