import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/entity/foods.dart';
import 'package:food_order/repo/foods_dao_repo.dart';

class HomePageCubit extends Cubit<List<Foods>> {
  HomePageCubit() : super(<Foods>[]);

  var krepo = FoodsDaoRepository();

  Future<void> uploadFoods() async {
    var foodList = await krepo.getAllFoods();
    emit(foodList);
    print("Yemekler yüklendi");
  }
}
