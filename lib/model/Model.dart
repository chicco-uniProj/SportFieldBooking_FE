
import 'dart:async';
import 'dart:convert';

import 'package:progetto/model/objects/AuthenticationData.dart';
import 'package:progetto/model/objects/Booking.dart';
import 'package:progetto/model/objects/UserReq.dart';
import 'package:progetto/model/support/Constants.dart';
import 'package:progetto/model/support/LogInResult.dart';

import 'managers/RestManager.dart';
import 'objects/Court.dart';
import 'objects/User.dart';

class Model {

  static Model sharedInstance = Model();
  bool logged = false;
  RestManager _restManager = RestManager();
  AuthenticationData _authentication;
  User currentUser;

  Future<List<Court>> searchCourtCity(String city,{int numPage,int dimPage,String sortBy}) async {
    Map<String, String> params = Map();
    params["city"] = city;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_CITY,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }
  Future<List<Court>> searchAllCourt({int numPage,int dimPage,String sortBy}) async {
    Map<String, String> params = Map();
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_ALL,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }
  Future<List<Court>> searchCourtType(String type,{int numPage,int dimPage,String sortBy}) async {
    Map<String, String> params = Map();
    params["type"] = type;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_TYPE,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<List<Court>> searchCourtTypeCity(String type,String city,{int numPage,int dimPage,String sortBy}) async {
    Map<String, String> params = Map();
    params["type"] = type;
    params["city"] = city;
    params["numPage"] = numPage.toString();
    params["dimPage"] = dimPage.toString();
    try {
      return List<Court>.from(json.decode(await _restManager.makeGetRequest(
          Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_SEARCH_COURT_CITY_TYPE,
          params)).map((i) => Court.fromJson(i)).toList());
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<LogInResult>logIn(String email,String password) async{
    try {
     Map<String, String>params = Map();
     params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;

      String result = await _restManager.makePostRequest(
          Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN,
          params, type: TypeHeader.urlencoded);

      //String result = await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_TOKEN,params);


      _authentication = AuthenticationData.fromJson(jsonDecode(result));


      if (_authentication.hasError()) { //cerchiamo di capire che errore è
        if (_authentication.error == "Invalid user credentials")
          return LogInResult.error_wrong_credentials;
        else if (_authentication.error == "Account is not fully set up")
          return LogInResult.error_not_fully_setupped;
        else
          return LogInResult.error_unknown;
      }
      _restManager.token = _authentication.accessToken;
      Timer.periodic(
          Duration(seconds: (_authentication.expiresIn - 60)), (Timer t) {
        _refreshToken();
      });
      logged=true;
      return LogInResult.logged;
    }
    catch(e)
    {
      logged=false;
      print(e);
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authentication.refreshToken;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authentication = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authentication.hasError() ) {
        logged=false;
        return false;
      }
      _restManager.token = _authentication.accessToken;
      logged=false;
      return true;
    }
    catch (e) {
      logged=false;
      return false;
    }
  }
  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authentication.refreshToken;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      logged=false;
      return true;
    }
    catch (e) {
      logged=true;
      return false;
    }
  }
  Future<User> addUser(UserReq reqObj) async {
    try {
      String rawResult = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_ADD_USER, reqObj);
      if ( rawResult.contains(Constants.RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS) ) {
        return null;
      }
      else {
        //print(await logIn(reqObj.user.email,reqObj.password));
        return User.fromJson(jsonDecode(rawResult));
      }
    }
    catch (e) {
      return null; // not the best solution
    }
  }

  Future<User> getUtente() async {
    try {
      return User.fromJson(jsonDecode(await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_USER)));
    }
    catch (e) {
      return null; // not the best solution
    }
  }
  
  Future<String>addBooking(String dataDaPrenotare,Court court) async{
    Booking booking = Booking();
    User user= User(
      userName: "chicco1501",
      firstName: "francesco",
      lastName: "zumpano",
      email: "zchicco1@gmail.com"
    );
    booking.buyer=user;
    booking.court=court;
    booking.data=dataDaPrenotare;
    //booking.purchaseTime=DateTime.now();
    booking.prezzo=court.priceHourly;
    
    try{

      String result = await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, Constants.REQUEST_BOOK_COURT, booking);
      return result;
    }
    catch(e){
      print("Errore prenotazione ");
    }
  }






}