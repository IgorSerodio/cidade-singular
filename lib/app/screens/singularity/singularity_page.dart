import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SingularityPage extends StatefulWidget {
  final Singularity singularity;
  const SingularityPage({Key? key, required this.singularity})
      : super(key: key);

  static String routeName = "/singularity";

  @override
  _SingularityPageState createState() => _SingularityPageState();
}

class _SingularityPageState extends State<SingularityPage> {
  String coverImg =
      "https://p-cidade-singular.s3.sa-east-1.amazonaws.com/test-imgs/4054014.jpg";

  @override
  void initState() {
    setState(() {
      if (widget.singularity.photos.isNotEmpty) {
        coverImg = widget.singularity.photos.first;
      }
    });
    super.initState();
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
                SizedBox(height: 20),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
