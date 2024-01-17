class UserModel {
  final String? id;
  final String fullname;
  final String email;
  final String phoneNo;
  final String password;

  const UserModel(this.fullname, this.email, this.phoneNo, this.password,
      {this.id});

  toJSBox() {
    return {
      "Fullname": fullname,
      "Email": email,
      "Phone": phoneNo,
      'Password': password
    };
  }
}
