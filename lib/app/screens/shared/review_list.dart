import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import '../../models/review.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: SizedBox(
          height: 200.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemCount: reviews.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 10.0),
                      child: Text(reviews[index].comment),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              reviews[index].creator.picture,
                              fit: BoxFit.cover,
                              height: 35,
                              width: 35,
                            ),
                          ),
                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "  ${getTitleUser(reviews[index].creator.xp)}  ",
                                style: TextStyle(
                                  // fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Text("  ${reviews[index].creator.name}  "),
                                  RatingBarIndicator(
                                    rating: reviews[index].rating.toDouble(),
                                    // itemPadding: EdgeInsets.only(left: 10),
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    direction: Axis.horizontal,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      
    );
  }

  String getTitleUser(int crias){
    if (crias >= 5000) return 'Vice-Curador';
    if (crias >= 1001) return 'Visitante Criativo';
    if (crias >= 101) return 'Visitante Singular';
    return 'Visitante Descobridor';
  }
}
