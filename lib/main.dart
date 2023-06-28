import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_analytics_test/profile_screen.dart';
import 'firebase_options.dart';
Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  //print(five);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home:homePAge() ,

    );
  }
}
/*    1.Creating UI
      2. Login to firebase
      3. Make new firebase project
         *
* */
class homePAge extends StatefulWidget {
  const homePAge({Key? key}) : super(key: key);

  @override
  State<homePAge> createState() => _homePAgeState();
}

class _homePAgeState extends State<homePAge> {

  //init the firebase app
  Future<FirebaseApp> _initializeFirebase() async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future:_initializeFirebase(),
          builder: (context, snapshot){
            if (snapshot.connectionState==ConnectionState.done)
              {
                return LoginScreen();
              }
            return const Center(
            child: CircularProgressIndicator(),
            );
    } ,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  // Login function
  static Future<User?> loginusingEmailPAssword({required String email, required String password, required BuildContext context}) async{
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  try{
    UserCredential userCredential = await auth.signInWithEmailAndPassword(email:email,password:password);
   user = userCredential.user;
  } on FirebaseAuthException catch(e)
  {
    if(e.code == "user-not-found"){
      print("No user found for that email");
    }
  }
  return user;
  }


  Widget build(BuildContext context) {
    //creating the textfield controller

    TextEditingController _emailcontroller = TextEditingController();
    TextEditingController _passwordcontroller = TextEditingController();
    return Padding(
        padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("MyApp Title",style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
          ),
          const Text(
            "Login to the app",
            style: TextStyle(color: Colors.black,
                fontSize: 44.0,
                fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
           TextField(
            controller: _emailcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(Icons.mail,color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 26.0,
          ),
          TextField(
            controller: _passwordcontroller,
            obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock,color: Colors.black),
              ),
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text("Dont remember your password?",style: TextStyle(color: Colors.blue)
          ),
          const SizedBox(
            height: 88.0,
          ),
          SizedBox(
            width: double.infinity,
            child:RawMaterialButton(
              fillColor: const Color(0xFF0069FE),
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical : 20.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                User? user = await loginusingEmailPAssword(email: _emailcontroller.text, password: _passwordcontroller.text, context: context);
                print(user);
                if(user != null)
                {
                  //open new screen if successful
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>ProfileScreen()));
                }
              },
              child: const Text("Login",
              style: TextStyle(color: Colors.white,
                fontSize: 18.0,

              )
              ),
            ),
          ),
        ],
      )
    );
  }
}


