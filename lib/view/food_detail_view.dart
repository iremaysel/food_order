import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:food_order/cubit/cart_cubit.dart';
import 'package:food_order/cubit/food_detail_cubit.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/entity/foods.dart';
import 'package:food_order/view/cart_view.dart';
import 'package:food_order/view/components/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailView extends StatefulWidget {
  Foods food;
  FoodDetailView({required this.food});

  @override
  _FoodDetailViewState createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  var foodName = TextEditingController();
  var foodImage = TextEditingController();
  var foodPrice = TextEditingController();
  int _counter = 1;

  void _increaseCart() {
    setState(() {
      _counter++;
    });
  }

  void _decreaseCart() {
    setState(() {
      if(_counter > 1){
        _counter--;
      }
      else{
        _counter = 1;
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var food = widget.food;
    foodName.text = food.yemek_adi;
    foodImage.text = food.yemek_resim_adi;
    foodPrice.text = food.yemek_fiyat;
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double screenHeight = screen.size.height;
    final double screenWidth = screen.size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight*0.60,
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: NetworkImage("http://kasimadalan.pe.hu/yemekler/resimler/${foodImage.text}"),
                fit: BoxFit.none
              )
            ),
          ),
          Positioned(
            left: 30,
            top: 30 + screen.padding.top,
            child: ClipOval(
              child: Container(
                height: 42,
                width: 41,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(0, 4),
                        blurRadius: 8
                    )
                  ],
                ),
                child: Center(
                  child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { Navigator.pop(context);},),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight* 0.5,
              width: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0,-4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, top: 20.0),
                        child: Text("${foodName.text}", style: Theme.of(context).textTheme.headline4),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight/(40), right: screenWidth/80),
                        //padding: EdgeInsets.only(top: screenHeight/(20)),
                        decoration: BoxDecoration(
                          color: textColorSearch.withOpacity(0.1),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CartView()));
                              },
                              icon: Icon(Icons.shopping_cart_outlined, color: loginButtonColor, )
                          ),
                        ),
                      ),
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0,top: 4.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          //Text("Açıklama", style: Theme.of(context).textTheme.headline6),
                          Text("   Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation...", maxLines: 3, style: TextStyle(color: Colors.black38),)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){_decreaseCart();},
                            child: Container(
                              height: 49,
                              width: 49,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: textColorSearch.withOpacity(0.1),
                                //borderRadius: BorderRadius.circular(10)
                              ),
                              child: Center(
                                child: Icon(Icons.remove, color: loginButtonColor),
                              ),
                            ),
                          ),
                          Container(
                              width: 60,
                              height: 49,
                              child: Center(child: Text("${_counter}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),))),
                          InkWell(
                            onTap: (){_increaseCart();},
                            child: Container(
                              height: 49,
                              width: 49,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: textColorSearch.withOpacity(0.4),
                              ),
                              child: Center(
                                child: Icon(Icons.add, color: loginButtonColor),
                              ),
                            ),
                          ),
                        ],
                    ),
                  ),

                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.07),
                          offset: Offset(0,-3),
                          blurRadius: 12
                        )
                      ]
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment : CrossAxisAlignment.start,
                              children: [
                                Text("Toplam", style: TextStyle(fontSize: 16),),
                                Text("${_counter.toInt() * int.parse(foodPrice.text)} ₺",style: Theme.of(context).textTheme.headline5)
                              ],
                            ),
                        ),
                        SizedBox(
                          height: screenWidth/7,
                          width: screenWidth/2,
                          child: Material(
                            elevation: 3,
                            borderRadius: BorderRadius.circular(30),
                            color: loginButtonColor,
                            child: MaterialButton(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              minWidth: screenWidth,
                              onPressed: (){
                                context.read<FoodDetailCubit>().addtocart(foodName.text, foodImage.text, int.parse(foodPrice.text), _counter, Cart.kullanici_adi.toString()).then((_) =>
                                {
                                  context.read<CartCubit>().getAllCart(Cart.kullanici_adi.toString())
                                });
                              },
                              child: Text("Sepete Ekle", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
