class Usuarios {
  String name;
  String email;
  String age;
  
  Usuarios(this.name, this.email, this.age);

  Usuarios.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    age = json['age'];
  }
}