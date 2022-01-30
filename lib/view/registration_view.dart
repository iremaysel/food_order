import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_order/entity/cart.dart';
import 'package:food_order/entity/user.dart';
import 'package:food_order/view/components/color.dart';
import 'package:food_order/view/home_page_view.dart';
import 'package:food_order/view/login_page_view.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final _formKey = GlobalKey<FormState>();
  // controller
  final TextEditingController userNameEditingController = new TextEditingController();
  final TextEditingController emailEditingController = new TextEditingController();
  final TextEditingController passwordEditingController = new TextEditingController();
  final TextEditingController confirmPasswordEdittingController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameEditingController.text = Cart.kullanici_adi ?? "";
  }
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context);
    final double screenHeight = screen.size.height;   //683
    final double screenWidth = screen.size.width;     //411

    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value){
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty){
          return ("Bu alan boş bırakılamaz!");
        }
        // reg expression for email validation
        if(!regex.hasMatch(value)){
          return ("Lütfen geçerli bir kullanıcı adı girin(min 3 karakter");
        }
        return null;
      },
      onSaved: (value){
        userNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: loginButtonColor,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Kullanıcı Adı",
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
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
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
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: loginButtonColor,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "E-Mail Adresi",
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
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Bu alan boş bırakılamaz");
        }
        if (!regex.hasMatch(value)) {
          return ("Geçerli bir parola girin!(En az 6 karakter)");
        }
      },
      onSaved: (value){
        passwordEditingController.text = value!;
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
    final passwordConfirmField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEdittingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEdittingController.text != passwordEditingController.text) {
          return "Şifreler eşlemiyor!";
        }
        return null;
      },
      onSaved: (value){
        confirmPasswordEdittingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: loginButtonColor,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key,),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Şifre Tekrar",
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

    final registerButton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: loginButtonColor,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: screenWidth,
        onPressed: (){
          signUp(emailEditingController.text, passwordEditingController.text);
          Cart.kullanici_adi = userNameEditingController.text;
        },
        child: Text("Kayıt Ol", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),

      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: loginButtonColor),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 36.0, right: 36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight/5,
                      child: Image.asset("assets/login.png", fit: BoxFit.contain,),
                    ),
                    SizedBox(height: screenHeight/15.18),        //45
                    userNameField,
                    SizedBox(height: screenHeight/27.32),        //25
                    emailField,
                    SizedBox(height: screenHeight/27.32),        //35
                    passwordField,
                    SizedBox(height: screenHeight/27.32),        //35
                    passwordConfirmField,
                    SizedBox(height: screenHeight/19.51),
                    registerButton,
                    SizedBox(height: screenHeight/45.53),       //15
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hesabın var mı?"),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPageView()));
                          },
                          child: Text(
                            " Giriş Yap",
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
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.userName = userNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginPageView()),
            (route) => false);
  }
}
