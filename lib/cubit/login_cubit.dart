import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/repo/foods_dao_repo.dart';

class LoginCubit extends Cubit<void> {
  LoginCubit() : super(0);

  var krepo = FoodsDaoRepository();

  Future login(String email,String password,context) async {
    await krepo.login(email, password, context);
  }

}
