class MovieInfo {
  int id;
  String movieName;
  String directorName;
  String photo;

  MovieInfo({this.id, this.movieName, this.directorName, this.photo});

  factory MovieInfo.fromMap(Map<String, dynamic> json) => MovieInfo(
      id: json['id'],
      movieName: json['movieName'],
      directorName: json['directorName'],
      photo: json['photo']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "movieName": movieName,
        "directorName": directorName,
        "photo": photo,
      };
}
