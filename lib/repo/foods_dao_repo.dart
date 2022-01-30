import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/entity/cart_response.dart';
import 'package:food_order/entity/foods.dart';
import 'package:food_order/entity/foods_response.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_order/view/login_page_view.dart';
import 'package:http/http.dart' as http;


class FoodsDaoRepository {
  List<Foods> parseFoodsResponse(String foodResponse) {
    return FoodsResponse.fromJson(json.decode(foodResponse)).listFood;
  }

  List<Cart> parseCartResponse(String cartresponse) {
    return CartResponse.fromJson(json.decode(cartresponse)).listCart;
  }

  Future<void> logout(BuildContext context) async {
    var refUsers = FirebaseDatabase.instance;
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPageView()));
  }

  Future<List<Foods>> getAllFoods() async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php");
    var foodResponse = await http.get(url);
    //print("ürünler getirildi : ${foodResponse.body}");
    print(foodResponse.body);
    return parseFoodsResponse(foodResponse.body);
  }

  Future<void> addToCart(String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet, String kullanici_adi) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");
    var data = {
      "yemek_adi": yemek_adi,
      "yemek_resim_adi": yemek_resim_adi,
      "yemek_fiyat": yemek_fiyat.toString(),
      "yemek_siparis_adet": yemek_siparis_adet.toString(),
      "kullanici_adi": kullanici_adi
    };
    var response = await http.post(url, body: data);
    print("Sepete ekle: ${response.body}");
  }

  Future<List<Cart>?> getallcart(String kullanici_adi) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php");
    var data = {"kullanici_adi": kullanici_adi};
    List empty = [];
    var response = await http.post(url, body: data);
    print("sepetteki ürünler getirildi : ${response.body}");
    return parseCartResponse(response.body);
    //if (response.statusCode != 200) return null;

  }

  Future<void> cartdeletefood(int sepet_yemek_id, String kullanici_adi) async {
    var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php");
    var data = {"sepet_yemek_id": sepet_yemek_id.toString(),"kullanici_adi": kullanici_adi};
    var response = await http.post(url, body: data);
    print("yemek sil: ${response.body}");
  }

  Future signUp(String email,String password, context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      var snackBar = SnackBar(content: Text(e.message!),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future login(String email,String password,context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e){
      var snackBar = SnackBar(content: Text(e.message!),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}