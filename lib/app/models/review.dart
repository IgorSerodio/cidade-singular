import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/user.dart';

class Review {
  String id;
  String comment;
  User creator;
  Singularity singularity;
  int rating;

  Review({
    required this.id,
    required this.comment,
    required this.creator,
    required this.singularity,
    required this.rating,
  });

  Review.fromMap(Map map)
      : id = map["_id"],
        comment = map["comment"],
        rating = map["rating"],
        singularity = Singularity.fromMap(map["singularity"]),
        creator = User.fromMap(map["creator"]);
}
