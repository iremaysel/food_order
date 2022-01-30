import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_order/cubit/cart_cubit.dart';
import 'package:food_order/cubit/food_detail_cubit.dart';
import 'package:food_order/cubit/home_page_cubit.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/entity/foods.dart';
import 'package:food_order/entity/user.dart';
import 'package:food_order/view/cart_view.dart';
import 'package:food_order/view/components/color.dart';
import 'package:food_order/view/food_detail_view.dart';
import 'package:food_order/view/login_page_view.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomePageCubit>().uploadFoods();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    print("isim : ${Cart.kullanici_adi.toString()}");
  }
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double screenHeight = screen.size.height;
    final double screenWidth = screen.size.width;
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: screenHeight/2.9,
          flexibleSpace: Column(
            children: [
              SizedBox(height: screenHeight/15),
              //searchBar
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: screenWidth/20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //SearchFood(),
                    //SearchFood(),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: textColorSearch.withOpacity(0.1),
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
                    Text("Food Order", style: TextStyle(color: loginButtonColor, fontSize: 28, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => LoginPageView()));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: textColorSearch.withOpacity(0.1),
                        ),
                        child: Center(
                          child: Icon(Icons.logout, color: loginButtonColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight/100),
              // hoşgeldin
              Container(
                // height: 90,
                width: double.infinity,
                margin: EdgeInsets.all(screenWidth/20),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth/20,
                  vertical: screenHeight/25,
                ),
                decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFF4F5873),
                        textColor
                      ],
                    )
                ),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                        text: "Merhaba ${Cart.kullanici_adi.toString()},\n\n",
                        style: TextStyle(
                          fontSize: screenWidth/20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: "Bugün ne yemek istersin?"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<HomePageCubit, List<Foods>>(
            builder: (context,foodList){
              if(foodList.isNotEmpty){
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 5),
                  itemCount: foodList.length,
                  itemBuilder: (context,indeks){
                    var food = foodList[indeks];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetailView(food: food)))
                            .then((_) => { context.read<HomePageCubit>().uploadFoods()} );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(-3,4),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                  width: screenWidth,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: textColorSearch.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),

                                  ),
                                  child: Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${food.yemek_resim_adi}")
                              ),
                              Container(
                                height: 55,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${food.yemek_adi}", style: TextStyle(color: Colors.black54, fontSize: 20),),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text("${food.yemek_fiyat} ₺", style: TextStyle(color: loginButtonColor, fontSize: 18) ),
                                            Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: Center(
                                                  child: IconButton(
                                                      onPressed: (){
                                                        context.read<FoodDetailCubit>().addtocart(food.yemek_adi, food.yemek_resim_adi, int.parse(food.yemek_fiyat), 1, Cart.kullanici_adi.toString()).then((_) =>
                                                        {
                                                          context.read<CartCubit>().getAllCart(Cart.kullanici_adi.toString())
                                                        });
                                                      },
                                                      icon: Icon(Icons.add_circle_outline_sharp, color: Colors.black54, )
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              else {
                return Center();
              }
            }
        ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPageView()));
  }
}
