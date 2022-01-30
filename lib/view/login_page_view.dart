import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/entity/user.dart';
import 'package:food_order/view/components/color.dart';
import 'package:food_order/view/home_page_view.dart';
import 'package:food_order/view/registration_view.dart';

class LoginPageView extends StatefulWidget {
  @override
  _LoginPageViewState createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();
  //var username = TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;

  // Hata mesajını görüntülemek için
  String? errorMessage;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double screenHeight = screen.size.height;   //683
    final double screenWidth = screen.size.width;     //411

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value){
        RegExp regex = new RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
        if(value!.isEmpty){
          return ("Lütfen mail adresi girin!");
        }
        // reg expression for email validation
        if(!regex.hasMatch(value)){
          return ("Lütfen geçerli bir mail adresi girin");
        }
        return null;
      },
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: loginButtonColor,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: loginButtonColor,
            width: 2.0
          ),
        ),
      ),
    );
    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Bu alan boş bırakılamaz");
        }
        if (!regex.hasMatch(value)) {
          return ("Geçerli bir parola girin!(En az 6 karakter)");
        }
      },
      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: loginButtonColor,

      decoration: InputDecoration(

          prefixIcon: Icon(Icons.vpn_key,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Şifre",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: loginButtonColor,
                width: 2.0
              )
          ),
      ),
    );

    final loginButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: loginButtonColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: screenWidth,
        onPressed: (){
          Cart.kullanici_adi = loggedInUser.userName ?? "";
          signIn(emailController.text, passwordController.text);
        },
        child: Text("Giriş Yap", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight/4,
                      child: Image.asset("assets/login.png", fit: BoxFit.contain,),
                    ),
                    SizedBox(height: screenHeight/15.18),        //45
                    emailField,
                    SizedBox(height: screenHeight/27.32),        //25
                    passwordField,
                    SizedBox(height: screenHeight/19.51),        //35
                    loginButton,
                    SizedBox(height: screenHeight/45.53),        //15
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hesabın yok mu?"),
                        GestureDetector(
                          onTap: (){ 
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationView()));
                          },
                          child: Text(
                            " Kayıt ol",
                            style: TextStyle(
                                color: loginButtonColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePageView())),
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Mail adresiniz hatalı görünüyor.";
            break;
          case "wrong-password":
            errorMessage = "Şifre yanlış";
            break;
          case "user-not-found":
            errorMessage = "Bu e-postaya sahip kullanıcı mevcut değil.";
            break;
          case "user-disabled":
            errorMessage = "Bu e-postaya sahip kullanıcı devre dışı bırakıldı.";
            break;
          case "too-many-requests":
            errorMessage = "Çok fazla istek yapıldı.";
            break;
          case "operation-not-allowed":
            errorMessage = "E-posta ve Parola ile oturum açma etkin değil";
            break;
          default:
            errorMessage = "Tanımsız bir Hata oluştu.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
