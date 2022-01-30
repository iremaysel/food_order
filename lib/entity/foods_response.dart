import 'package:food_order/entity/foods.dart';

class FoodsResponse {
  List<Foods> listFood;
  int success;

  FoodsResponse({required this.listFood, required this.success});

  factory FoodsResponse.fromJson(Map<String, dynamic> json){
    var jsonArray = json["yemekler"] as List;
    List<Foods> listFood = jsonArray.map((e) => Foods.fromJson(e)).toList();
    return FoodsResponse(listFood: listFood, success: json["success"] as int);
  }
}