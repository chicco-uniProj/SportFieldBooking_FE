class Court{
  int id;
  String name;
  String type;
  String city;
  double priceHourly;
  String description;

  Court({this.id, this.name, this.type, this.city, this.priceHourly,
      this.description});

  factory Court.fromJson(Map<String,dynamic>json){
    return Court(
      id : json['id'],
      name : json['name'],
      type : json['type'],
      city: json['city'],
      priceHourly : json['priceHourly'],
      description : json['description'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'name':name,
    'type':type,
    'city':city,
    'priceHourly':priceHourly,
    'description':description,
  };

  @override
  String toString(){
    return name+" "+type+" "+city;
  }
}