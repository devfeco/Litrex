class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? bio;
  String? createdAt;
  String? updatedAt;
  int? isPremium;
  String? status;


  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.avatar,
    this.bio,
    this.createdAt,
    this.updatedAt,
    this.isPremium,
    this.status,
  });



  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      bio: json['bio'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isPremium: json['is_premium'] is String ? int.tryParse(json['is_premium']) : json['is_premium'],
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'bio': bio,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_premium': isPremium,
      'status': status,
    };
  }
}

class AuthResponse {
  bool? success;
  String? message;
  UserModel? user;
  String? token;

  AuthResponse({
    this.success,
    this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    UserModel? user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    
    // Eğer user objesi içinde status yoksa veya ana response'da farklı bir status varsa oradan al
    if (user != null && json['user_status'] != null) {
      user.status = json['user_status']?.toString();
    }
    
    return AuthResponse(
      success: json['success'],
      message: json['message'],
      user: user,
      token: json['token'],
    );
  }
}
