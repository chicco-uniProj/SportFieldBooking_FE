class User {
  int id;
  String userName;
  String firstName;
  String lastName;
  String telephone;
  String email;


  User({this.id, this.userName, this.firstName, this.lastName, this.telephone, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      telephone: json['telephone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'firstName': firstName,
    'lastName': lastName,
    'telephoneNumber': telephone,
    'email': email,
  };

  @override
  String toString() {
    return firstName + " " + lastName;
  }


}