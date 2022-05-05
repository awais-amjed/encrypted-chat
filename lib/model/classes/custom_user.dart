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

  Map<String, dynamic> toJson() => {
        '\$id': id,
        'name': name,
        'image': imageURL,
        'public_key': publicKey,
      };

  CustomUser.fromJson(Map<String, dynamic> json)
      : id = json['\$id'],
        name = json['name'],
        imageURL = json['image'],
        publicKey = json['public_key'];
}
