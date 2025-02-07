import 'package:cidade_singular/app/models/singularity.dart';
import 'package:flutter/material.dart';



class SingularityInfo extends StatefulWidget {
  final Singularity singularity;

  const SingularityInfo({Key? key, required this.singularity}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingularityInfoState();
}

class _SingularityInfoState extends State<SingularityInfo> {
  _SingularityInfoState();

  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.singularity.title, maxLines: 3,),
            centerTitle: true,
            backgroundColor: Colors.red,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.favorite),
                tooltip: "Adicionar aos favoritos",
                onPressed: () { pressed(); },
                color:(isPressed) ? Colors.blue
                  : Colors.white
              )
            ]
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  child: SizedBox(
                    height: 200,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: getPhotos(widget.singularity.photos)
                    )
                  )
                ),
                Align(
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red)
                    ),
                    child: Text(widget.singularity.description),
                  )
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text("Endereço: ${widget.singularity.address}"),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Text("Horário de Funcionamento: ${widget.singularity.visitingHours}"),
                )
              ],
            )
          )
        );
  }

  void pressed() {
    if (isPressed){
      setState(() {
        isPressed = false; });
    }else {
      setState(() {
        isPressed = true; });
    }
  }

  List<Widget> getPhotos(List<String> urls) {
    List<Widget> photos = [];
    for (String url in urls) {
      photos.add(Container(
          width: 300.0,
          margin: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            image: DecorationImage (
              image: Image.network(url).image,
              fit: BoxFit.cover
            )
          ),
        )
      );
    }
    return photos;
  }
}