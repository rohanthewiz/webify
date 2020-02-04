class Contact {
  final String Name;
  final String Role;
  final String Company;
  final String Phone;
  final String Email;

  Contact._({
    this.Name,
    this.Role,
    this.Company,
    this.Phone,
    this.Email,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact._(
      Name: json['name'],
      Role: json['role'],
      Company: json['company'],
      Phone: json['phone'],
      Email: json['email'],
    );
  }
}
