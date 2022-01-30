import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/repo/foods_dao_repo.dart';

class CartCubit extends Cubit<List<Cart>> {
  CartCubit() : super(<Cart>[]);

  var krepo = FoodsDaoRepository();

  Future<void> foodCartDelete(int sepet_yemek_id, String kullanici_adi) async {
    try{
      await krepo.cartdeletefood(sepet_yemek_id, kullanici_adi);
    }
    catch(e){
      print("hata");
    }
    await getAllCart(kullanici_adi);
  }

  Future<void> getAllCart(String kullanici_adi) async {
    print("Sepettteki yemekler listelendi");
    try{
      var listCart = await krepo.getallcart(kullanici_adi);
      emit(listCart!);
    }
    catch(e){
      print("Sepet Boş");
      emit([]);
    }
  }

  Future<void> cartDeleteFood(int sepet_yemek_id, String kullanici_adi) async {
    await krepo.cartdeletefood(sepet_yemek_id, kullanici_adi);
    await getAllCart(kullanici_adi);
  }


}
