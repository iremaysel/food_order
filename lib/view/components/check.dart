import 'package:flutter/material.dart';
import 'package:food_order/view/home_page_view.dart';
import 'package:lottie/lottie.dart';

import 'color.dart';

class CheckCart extends StatelessWidget {
  const CheckCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(child: Lottie.network("https://assets7.lottiefiles.com/packages/lf20_47pyyfcf.json")),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text("Siparişiniz Alındı!", style: TextStyle(color: Colors.black54, fontSize: 30)),
            ),
            InkWell(
              onTap: (){Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePageView()));},
              child: Container(
                  width: 200 ,
                  height: 55,
                  decoration: BoxDecoration(
                      color: loginButtonColor,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Center(child: Text("Tamam", style: TextStyle(color: Colors.white, fontSize: 18),))
              ),
            ),
          ]
    ),
    );
  }
}
