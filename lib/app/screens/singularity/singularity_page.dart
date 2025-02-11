// ignore_for_file: sort_child_properties_last

import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/review.dart';
import 'package:cidade_singular/app/models/user.dart';

import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:cidade_singular/app/services/review_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/util/mission_progress_handler.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/stores/city_store.dart';

import '../shared/social_share_bar.dart';
import '../shared/review_list.dart';
import 'package:lottie/lottie.dart';

class SingularityPage extends StatefulWidget {
  final Singularity singularity;

  const SingularityPage({Key? key, required this.singularity})
      : super(key: key);

  static String routeName = "/singularity";

  @override
  _SingularityPageState createState() => _SingularityPageState();
}

class _SingularityPageState extends State<SingularityPage> {
  bool loading = false;
  double rating = 0.0;
  double ratingReview = 0.0;

  ReviewService service = Modular.get();
  UserService userService = Modular.get();

  final commentController = TextEditingController();

  UserStore userStore = Modular.get();
  CityStore cityStore = Modular.get();

  String coverImg =
      "https://p-cidade-singular.s3.sa-east-1.amazonaws.com/test-imgs/4054014.jpg";

  @override
  void initState() {
    getReviews(widget.singularity);

    setState(() {
      if (widget.singularity.photos.isNotEmpty) {
        coverImg = widget.singularity.photos.first;
      }
    });
    super.initState();
  }

  List<Review> reviews = [];

  getReviews(Singularity singularity) async {
    setState(() => loading = true);
    reviews = await service.getReviews(query: {
      "singularity": singularity.id,
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            backgroundColor: Constants.primaryColor,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    color: Colors.black12,
                  ),
                ],
              ),
              margin: EdgeInsets.all(6),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Modular.to.pop(),
                color: Color(0xFF3A3A3A),
              ),
            ),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(""),
              background: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      coverImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (widget.singularity.photos.length > 2)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Row(
                        children: [
                          ...widget.singularity.photos
                              .map((photo) => GestureDetector(
                                    onTap: () {
                                      if (coverImg != photo) {
                                        setState(() {
                                          coverImg = photo;
                                        });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      width: coverImg == photo ? 40 : 35,
                                      height: coverImg == photo ? 40 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: NetworkImage(photo),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(2, 2),
                                            blurRadius: 2,
                                            color: Colors.black38,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  child: RatingBarIndicator(
                    rating: calculaRating(reviews),
                    itemPadding: EdgeInsets.only(bottom: 10),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    direction: Axis.horizontal,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.singularity.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Constants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/places.svg",
                        width: 16,
                        color: Constants.textColor1,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.singularity.address,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.textColor1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/hour.svg",
                        width: 16,
                        color: Constants.textColor1,
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          widget.singularity.visitingHours,
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constants.textColor1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SocialShareBar(
                    addXp: addXp,
                    rating: calculaRating(reviews),
                    singularity: widget.singularity),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Descrição",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.textColor1,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.singularity.description,
                    softWrap: true,
                    maxLines: 200,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Constants.textColor1,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Avaliações",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.textColor1,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                reviews.isEmpty ? SizedBox():ReviewList(reviews: reviews),
                SizedBox(height: 10),
                TextButton.icon(
                  // <-- TextButton
                  // onPressed: () {
                  //   openDialogue();
                  // },
                  onPressed: userStore.user == null ? null : ()=>{openDialogue()},
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 24.0,
                  ),
                  label: Text('Nova Avaliação'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future openDialogue() => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 500,
                  child: Column(children: [
                    Text(
                      "Faça uma avaliação ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      maxRating: 5,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (value) {
                        setState(() {
                          ratingReview = value;
                        });
                      },
                    ),
                    TextField(
                      controller: commentController,
                      autocorrect: true,
                      minLines: 1,
                      maxLines: 3,
                      maxLength: 120,
                      // decoration: InputDecoration(hintText: "Comente algo"),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ]),
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Enviar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    var result = await addNewReview(
                        userStore.user?.id ?? "",
                        widget.singularity.id,
                        commentController.text.trim(),
                        ratingReview);
                    if (result) {
                      MissionProgressHandler.handle(["review", widget.singularity.type] + widget.singularity.tags, userStore.user?.id ?? "", cityStore.city?.id ?? "");
                      Navigator.of(context).pop(true);
                      await openCongratulationDialogue('Obrigado pela avaliação!', 100);
                    }
                  },
                )
              ]));

  Future openCongratulationDialogue(String text, int points) =>
      showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                  content: SingleChildScrollView(
                      child: SizedBox(
                    width: 500,
                    child: SizedBox(
                      width: 200,
                      child: Column(children: [
                        Lottie.asset(
                          'assets/lottie/64963-topset-complete.json',
                        ),
                        Text(text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(userStore.user==null? 'Faça login para acumular suas Crias!':"Você recebeu $points Crias.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent,
                            )),
                      ]),
                    ),
                  )),
                  actions: [
                    TextButton(
                      child: Text(
                        'Voltar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ]));

  addNewReview(String creatorId, String singularityId, String comment, double rating) async {
    if (userStore.user == null) return false;

    bool? reviewAdded = await service.addReview(
        creator: creatorId,
        singularity: singularityId,
        comment: comment,
        rating: rating);

    if (reviewAdded) {
      await addXp(100);
    }

    return reviewAdded;
  }

  addXp(int amount) async {
    var id = userStore.user?.id ?? "";

    if (id == "") {
      return;
    }

    User? user = await userService.addXp(id: id, amount: amount);

    if (user != null) {
      userStore.setUser(user);
    }
  }

  double calculaRating(List<Review> reviews) {
    var size = reviews.length;
    if (size == 0) return 0.0;

    var sum = 0.0;
    for (Review review in reviews) {
      sum += review.rating;
    }
    var average = sum / reviews.length;
    var averageTruncate = (average * 100).truncate() / 100;

    setState(() {
      rating = averageTruncate;
    });
    return averageTruncate;
  }
}
