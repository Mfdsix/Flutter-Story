class PostStoryFileRequest {
  List<int> fileBytes;
  String filename;

  PostStoryFileRequest({required this.fileBytes, required this.filename});
}

class PostStoryBodyRequest {
  String description;
  double? lat;
  double? lon;

  PostStoryBodyRequest({required this.description, this.lat, this.lon});
}