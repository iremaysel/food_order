import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/repo/foods_dao_repo.dart';

class FoodDetailCubit extends Cubit<void> {
  FoodDetailCubit() : super(0);

  var krepo = FoodsDaoRepository();

  Future<void> addtocart(String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet, String kullanici_adi) async {
    await krepo.addToCart(yemek_adi, yemek_resim_adi, yemek_fiyat, yemek_siparis_adet, kullanici_adi);
    print("Sepete ürün eklendi ${yemek_adi}");
  }
}
