class ChatUser {
  ChatUser({
    required this.image,
    required this.createdAt,
    required this.name,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    required this.about ,
    required this.email,
    required this.pushToken,
  });
  late final String image;
  late final String createdAt;
  late final String name;
  late final String id;
  late final bool isOnline;
  late final String lastActive;
  late final String about ;
  late final String email;
  late final String pushToken;
  
  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'];
    createdAt = json['createdAt'];
    name = json['name'];
    id = json['id'];
    isOnline = json['is_online'];
    lastActive = json['last_active'];
    about  = json['about '];
    email = json['email'];
    pushToken = json['push_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['name'] = name;
    data['id'] = id;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['about '] = about ;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}