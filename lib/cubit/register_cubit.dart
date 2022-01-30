import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/repo/foods_dao_repo.dart';

class RegisterCubit extends Cubit<void>{
  RegisterCubit() : super(0);

  var krepo = FoodsDaoRepository();

  Future signUp(String email,String password, context) async {
    await krepo.signUp(email, password, context);
  }

}