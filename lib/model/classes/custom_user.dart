class CustomUser {
  String id;
  String name;
  String? imageURL;
  String? publicKey;

  CustomUser({
    required this.id,
    required this.name,
    this.imageURL,
    this.publicKey,
  });

  CustomUser.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        imageURL = json['image'],
        publicKey = json['public_key'];
}
