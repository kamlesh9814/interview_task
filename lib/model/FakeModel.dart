class FakeModel {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  FakeModel({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory FakeModel.fromJson(Map<String, dynamic> json) {
    return FakeModel(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'id': id,
      'title': title,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
