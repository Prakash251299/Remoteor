import 'package:bloc/bloc.dart';
import 'package:remoteor/constants.dart';
import 'package:remoteor/controller/firebase/fetch_users.dart';
import 'package:remoteor/modal/user_info.dart';
// import 'package:linkify/model/home/first_page_categories.dart';
// import 'package:linkify/controller/home/front_page_data/recommendations.dart';
// import '../../../controller/variables/loading_enum.dart';


part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initial());

  Future<void> fetchData() async {
    try {
      emit(state.copyWith(
        status: LoadPage.loading
      ));

      emit(state.copyWith(
        users: await fetchUsers(),
        status: LoadPage.loaded,
      ));
    } catch (e) {
      print(e.toString());
      print("Error happened at homecubit getalbums function");
      emit(state.copyWith(status: LoadPage.error));
    }
  }
}