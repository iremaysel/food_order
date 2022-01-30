import 'package:food_order/entity/cart.dart';

class CartResponse {
  List<Cart> listCart;
  int success;

  CartResponse({required this.listCart, required this.success});

  factory CartResponse.fromJson(Map<String, dynamic> json){

    var jsonArray = (json["sepet_yemekler"] ?? []) as List;
    List<Cart> listCart = jsonArray.map((e) => Cart.fromJson(e)).toList();
    return CartResponse(listCart: listCart, success: json["success"] as int);
  }
}