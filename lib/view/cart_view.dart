import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/cubit/cart_cubit.dart';
import 'package:food_order/cubit/food_detail_cubit.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/view/components/check.dart';
import 'package:food_order/view/components/color.dart';
import 'package:lottie/lottie.dart';

class CartView extends StatefulWidget {
  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {

  static var totalCount;
  static var totalFoodPrice = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<CartCubit>().getAllCart(Cart.kullanici_adi.toString());
    totalCount;
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double screenHeight = screen.size.height;
    final double screenWidth = screen.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title : Text("Sepetim", style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding:
        EdgeInsets.symmetric(horizontal: screenWidth/20),
        child: BlocBuilder<CartCubit, List<Cart>>(
            builder: (context, foodList) {
              totalCount = 0;

              var countName = 0;
              if (foodList.isNotEmpty) {
                //print(foodList[0].yemek_adi);
                for(var i in foodList){
                    totalFoodPrice = int.parse(i.yemek_siparis_adet) * int.parse(i.yemek_fiyat);
                    totalCount += totalFoodPrice;
                    var price = 0;
                    for(var j in foodList) {
                      if(i.yemek_adi.length.toString() == j.yemek_adi.length.toString()){
                        countName += 1;
                        if(countName > 1){
                          price += int.parse(j.yemek_siparis_adet);
                          print(j.yemek_adi.toString());
                          print(price);
                          //context.read<CartCubit>().cartDeleteFood(int.parse(i.sepet_yemek_id), Cart.kullanici_adi.toString());
                          //context.read<FoodDetailCubit>().addtocart(i.yemek_adi, i.yemek_resim_adi, int.parse(i.yemek_fiyat), price, Cart.kullanici_adi.toString());
                          //context.read<CartCubit>().cartupdate(i.yemek_adi, i.yemek_resim_adi, int.parse(i.yemek_fiyat), price, Cart.kullanici_adi.toString(), int.parse(i.sepet_yemek_id));
                        }
                      }
                    }
                }
                return ListView.builder(
                  itemCount: foodList.length,
                  itemBuilder: (context, index) =>
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          key: UniqueKey(),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              totalCount -= int.parse(foodList[index].yemek_fiyat) * int.parse(foodList[index].yemek_siparis_adet);
                              context.read<CartCubit>().cartDeleteFood(
                                  int.parse(foodList[index].sepet_yemek_id),
                                  Cart.kullanici_adi.toString());
                            });
                          },
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Spacer(),
                                Icon(Icons.delete_outline)
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 88,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: Container(
                                    //padding: EdgeInsets.all(screenWidth/10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F6F9),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${foodList[index].yemek_resim_adi}"),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${foodList[index].yemek_adi}",
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 10),
                                  Text.rich(
                                    TextSpan(
                                      text: "${foodList[index].yemek_fiyat} ₺",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, color: loginButtonColor),
                                      children: [
                                        TextSpan(
                                            text: " x${foodList[index].yemek_siparis_adet}",
                                            style: Theme.of(context).textTheme.bodyText1),
                                      ],
                                    ),
                                  ),

                                ],

                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                        Text("${foodList[index].yemek_adi} silinsin mi?"),
                                        action: SnackBarAction(
                                          label: "Evet",
                                          onPressed: () {
                                              context
                                                  .read<CartCubit>()
                                                  .cartDeleteFood(
                                                  int.parse(foodList[index].sepet_yemek_id),
                                                  Cart.kullanici_adi.toString());
                                              setState(() {
                                                totalCount -= int.parse(foodList[index].yemek_fiyat) * int.parse(foodList[index].yemek_siparis_adet);
                                              });
                                            }
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.delete_outline, color: Colors.black54,)),
                            ],
                          ),
                        ),
                      ),
                );
              }
              else{
                return SizedBox(child: Center(child: Lottie.network("https://assets10.lottiefiles.com/packages/lf20_peztuj79.json", height: 100,width: 100, repeat: false),));
              }
            }),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight/(15),
          horizontal: screenHeight/(30),
        ),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(Icons.receipt_long_outlined , color: loginButtonColor)),
                  Spacer(),
                  Text("3D secure ile ödeme"),
                  const SizedBox(width: 10),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.black12,
                  )
                ],
              ),
              SizedBox(height: screenHeight/(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Toplam:\n",
                      style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 16),
                      children: [

                        TextSpan(
                          text: "${totalCount} ₺",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CheckCart()));},
                    child: Container(
                        width: screenWidth/2 ,
                        height: 55,
                        decoration: BoxDecoration(
                            color: loginButtonColor,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Center(child: Text("Sipariş Ver", style: TextStyle(color: Colors.white, fontSize: 18),))
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
