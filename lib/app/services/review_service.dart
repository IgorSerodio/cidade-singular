import 'package:cidade_singular/app/models/review.dart';
import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:dio/dio.dart';

class ReviewService {
  DioService dioService;

  ReviewService(this.dioService);

  Future<bool> addReview({
    required String creator,
    required String singularity,
    required String comment,
    required double rating
  }) async {
    try {
      var response = await dioService.dio.post(
        "/review",
        data: {
          "creator": creator,
          "singularity": singularity,
          "comment": comment,
          "rating": rating
        },
      );

      if (response.data["error"]) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future<List<Review>> getReviews(
      {Map<String, String> query = const {}}) async {
    try {
      var response = await dioService.dio.get(
        "/review",
        queryParameters: query,
      );

      if (response.data["error"]) {
        return [];
      } else {
        List<Review> reviews = [];
        for (Map data in response.data["data"]) {
          reviews.add(Review.fromMap(data));
        }
        return reviews;
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      } else {
        print(e);
      }
      return [];
    }
  }
}
