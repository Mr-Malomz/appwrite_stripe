class AppConstant {
  final String databaseId = "REPLACE WITH DATABASE ID";
  final String projectId = "REPLACE WITH PROJECT ID";
  final String collectionId = "REPLACE WITH COLLECTION ID";
  final String functionId = "REPLACE WITH FUNCTION ID";
  final String userId = "REPLACE WITH SAMPLE ID";
  final String endpoint = "ENDPOINT";
}

class User {
  String name;
  bool is_subscribed;

  User({required this.name, required this.is_subscribed});

  Map<dynamic, dynamic> toJson() {
    return {"name": name, "is_subscribed": is_subscribed};
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(name: json['name'], is_subscribed: json['is_subscribed']);
  }
}
