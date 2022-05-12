class CustomUser {
  String id;
  String name;
  String? imagePath;
  String? publicKey;
  List<String>? chatIDs;

  CustomUser({
    required this.id,
    required this.name,
    this.imagePath,
    this.publicKey,
    this.chatIDs,
  });

  Map<String, dynamic> toJson() => {
        '\$id': id,
        'name': name,
        'image_path': imagePath,
        'public_key': publicKey,
        'chat_ids': chatIDs,
      };

  CustomUser.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        imagePath = json['image_path'],
        publicKey = json['public_key'],
        chatIDs = json['chat_ids']?.map<String>((e) => e.toString()).toList();
}
