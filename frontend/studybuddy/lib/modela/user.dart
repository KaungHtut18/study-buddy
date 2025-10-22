class User {
  final int id;
  final String name;
  final String email;
  final String? description;
  final List<String>? skills;
  final List<String>? interests;
  final List<dynamic>? matchedUsers;
  final List<dynamic>? interestedUsers;
  String? imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.description,
    this.skills,
    this.interests,
    this.matchedUsers,
    this.interestedUsers,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'], 
      name: json['userName'],
      email: json['email'],
      description: json['description'] ?? '',
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      matchedUsers: json['matchedUsers']?.toList(),
      interestedUsers: json['interestedUsers']?.toList(),
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': name,
      'email': email,
      'description': description,
      'skills': skills,
      'interests': interests,
      'matchedUsers': matchedUsers?.map((user) => user.toJson()).toList(),
      'interestedUsers': interestedUsers?.map((user) => user.toJson()).toList(),
    };
  }
}
