class CustomUser {
  String id;
  String name;
  String? imageURL;
  String? publicKey;
  List<String>? chatIDs;

  CustomUser({
    required this.id,
    required this.name,
    this.imageURL,
    this.publicKey,
    this.chatIDs,
  });

  Map<String, dynamic> toJson() => {
        '\$id': id,
        'name': name,
        'image': imageURL,
        'public_key': publicKey,
        'chat_ids': chatIDs,
      };

  CustomUser.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        imageURL = json['image'],
        publicKey = json['public_key'],
        chatIDs = json['chat_ids']?.map<String>((e) => e.toString()).toList();
}
