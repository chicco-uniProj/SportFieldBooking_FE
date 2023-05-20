import 'package:flutter/material.dart';
import 'package:progetto/UI/widget/CircularIconButton.dart';
import 'package:progetto/UI/widget/InputField.dart';
import 'package:progetto/model/Model.dart';
import 'package:progetto/model/objects/User.dart';
import 'package:progetto/model/objects/UserReq.dart';
import 'package:progetto/model/support/LogInResult.dart';

import '../../model/objects/Booking.dart';
import '../../model/support/Constants.dart';

class UserRegistration extends StatefulWidget {

  UserRegistration({Key key}) : super(key: key);

  @override
  _UserRegistrationState createState() => _UserRegistrationState();

}

class _UserRegistrationState extends State<UserRegistration>{
  bool _adding=false;
  bool _logging=false;
  bool _signUp=true;
  bool _bookedPage=false;
  List<Booking>listaPrenot=[];

  TextEditingController _controllerFirstName = TextEditingController();
  TextEditingController _controllerLastName = TextEditingController();
  TextEditingController _controllerTelephone = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if(Model.sharedInstance.logged){
      if(_bookedPage)
        print("pagina prenot");
      else
        print("profilo");
    }

    return Scaffold(
      body: SingleChildScrollView(
        child:
        Model.sharedInstance.logged? profilo():
            _signUp?
                signUp():
                logIn()
      ),
    );

    /*return Scaffold(
      body: SingleChildScrollView(
        child: Model.sharedInstance.logged?
          _bookedPage?_bookedPage(): profile():
            _signUp?_signUp():login()
      ),
    );*/
  }

  Widget signUp(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Text(
            "SignUp!",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Column(
            children: [
              InputField(
                labelText: "Nome",
                controller: _controllerFirstName,
              ),
              InputField(
                labelText: "Cognome",
                controller: _controllerLastName,
              ),
              InputField(
                labelText: "Telefono",
                controller: _controllerTelephone,
              ),
              InputField(
                labelText: "Email",
                controller: _controllerEmail,
              ),
              InputField(
                labelText: "Password",
                controller: _controllerPassword,
                isPassword: true,
              ),
              Row(
                children: [
                  Text("SignUp",style: TextStyle(color: Colors.deepOrange),),
                  CircularIconButton(
                    icon: Icons.person_pin,
                    onPressed: (){
                      _register();
                    },
                  ),
                ]
              ),
              Row(
                children: [
                  Text("Passa a login",style: TextStyle(color: Colors.orange),),
                  CircularIconButton(
                    icon: Icons.login,
                    onPressed: (){
                      setState(() {
                        _signUp=false;
                      });
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: _adding ?
                        CircularProgressIndicator() :
                          Model.sharedInstance.currentUser != null ?
                            Text(
                              "Si è appena registrato:" + Model.sharedInstance.currentUser.firstName + " " + Model.sharedInstance.currentUser.lastName + "!"
                            ) :
                          SizedBox.shrink(),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
  void _register(){
    setState(() {
      _adding=true;
      Model.sharedInstance.currentUser==null;
    });
    if(_controllerFirstName.text=="" ||_controllerLastName.text=="" ||
        _controllerTelephone.text==""||_controllerEmail.text==""||_controllerPassword.text=="" ){
      final snackBar = SnackBar(
        content: Text("Tutti campi obbligatori"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        _adding=false;
      });
    }
    else{
      User user = User(
        firstName: _controllerFirstName.text,
        lastName: _controllerLastName.text,
        telephone: _controllerTelephone.text,
        email: _controllerEmail.text,
      );
      UserReq userReq = UserReq(
        user: user,
        password: _controllerPassword.text
      );
      Model.sharedInstance.addUser(userReq).then((result){
        setState(() {
          _adding = false;
          Model.sharedInstance.currentUser=result;
        });
      });
    }

  }
  Widget logIn(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Text(
            "Log-in",
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: Column(
            children: [
              InputField(
                labelText: "Email",
                controller: _controllerEmail,
              ),
              InputField(
                labelText: "Password",
                controller: _controllerPassword,
                isPassword: true,
              ),
              Row(
                children: [
                  Text("LogIn",style: TextStyle(color: Colors.deepOrangeAccent)),
                  CircularIconButton(
                    icon: Icons.login,
                    onPressed: (){
                      _logIn();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Passa a signUp",style: TextStyle(color: Colors.orange)),
                  CircularIconButton(
                    icon: Icons.person_pin,
                    onPressed: (){
                      setState(() {
                        _signUp=true;
                      });
                    },
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: _logging?
                      CircularProgressIndicator():
                      Model.sharedInstance.currentUser != null?
                          Text(""+Model.sharedInstance.currentUser.firstName
                          ):
                          Text("")
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _logIn(){
    setState(() {
      _logging=true;
      Model.sharedInstance.currentUser=null;
    });
    Model.sharedInstance.logIn(_controllerEmail.text, _controllerPassword.text).then((result){
      if(result==LogInResult.logged){
        Model.sharedInstance.getUtente().then((value) {
          setState(() {
            Model.sharedInstance.logged = true;
            _logging = false;
            Model.sharedInstance.currentUser = value;
          });
        });
      }
      else{
        setState(() {
          _logging=false;
        });
        final snackBar=SnackBar(content:Text("Attenzione,credenziali sbagliate"),backgroundColor: Colors.red,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

  }

  Widget profilo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Text(
      "Benvenuto !",
        style: TextStyle(
          fontSize: 50,
          color: Theme.of(context).primaryColor,
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
        child: Row(
          children: [
            Text("Logout",style: TextStyle(color: Colors.blue)),
            CircularIconButton(
              icon: Icons.logout,
              onPressed: (){
                _logout();
              },
            )
          ],
        ),
      ),
    ]
    );

  }

  void _logout(){
    setState(() {
      _logging=true;
      Model.sharedInstance.logged=false;
    });
    Model.sharedInstance.logOut().then((result){
      if(result) {
        setState(() {
          _logging = false;
          Model.sharedInstance.currentUser = null;
        });
      }
      else{
        _logging=false;
      }
    });

  }


}