import 'package:progetto/model/objects/Court.dart';
import 'package:progetto/model/objects/User.dart';

class Booking{
  int id;
  String data;//ora-data che si vuole prenotare il campetto
  DateTime purchaseTime;
  double prezzo;
  User buyer;
  Court court;

  Booking({this.id, this.data, this.purchaseTime, this.prezzo, this.buyer,
      this.court});

  factory Booking.fromJson(Map<String,dynamic>json){
    var milliSeconds = json['purchaseTime'];
    DateTime dateTime;
    if(milliSeconds!=null)
       dateTime= DateTime.fromMicrosecondsSinceEpoch(milliSeconds);
    return Booking(
      id: json['id'],
      data: json['data'],
      purchaseTime: dateTime,
      prezzo: json['prezzo'],
      buyer: User.fromJson(json['user']),
      court: Court.fromJson(json['court']),
    );
  }

  Map<String,dynamic> toJson() =>{
    'id': id,
    'data':data,
    'purchaseTime':purchaseTime,
    'prezzo':prezzo,
    'buyer':buyer,
    'court':court,
  };
  @override
  String toString(){
    return id.toString()+": orario prenotato,"+ data +"dall'utente: "+buyer.userName;
  }


}