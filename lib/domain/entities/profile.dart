import 'dart:math';

class Profile {
  final String name;
  final List<String> roles;
  final List<String> skills;
  final String bio;
  final String email;
  final String imageUrl;

  Profile({
    required this.name,
    required this.roles,
    required this.skills,
    required this.bio,
    required this.email,
    required this.imageUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    List<String> availableSkills = [
      'Java',
      'Flutter',
      'Dart',
      'Python',
      'JavaScript',
    ];
    List<String> availableRoles = [
      'Senior Mobile',
      'Project Manger',
      'Devops',
      'Web Developer',
    ];
    return Profile(
      name: json['name'],
      roles:
          json['roles'] != null && json['roles'].isNotEmpty
              ? List<String>.from(json['roles'])
              : [availableRoles[Random().nextInt(availableRoles.length)]],
      skills:
          json['skills'] != null && json['skills'].isNotEmpty
              ? List<String>.from(json['skills'])
              : [availableSkills[Random().nextInt(availableSkills.length)]],
      imageUrl: json['imageUrl'],
      bio: json['bio'],
      email: json['email'],
    );
  }
}
