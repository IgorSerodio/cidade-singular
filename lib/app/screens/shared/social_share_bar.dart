import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/singularity.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_modular/flutter_modular.dart';

class SocialShareBar extends StatelessWidget {
  const SocialShareBar({
    Key? key,
    required this.addXp,
    required this.singularity,
    required this.rating,
  }) : super(key: key);

  final Function(int xp) addXp;
  final Singularity singularity;
  final double rating;

  @override
  Widget build(BuildContext context) {
    UserStore userStore = Modular.get();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            child: Icon(Icons.copy),
            onPressed: () async {
              SocialShare.copyToClipboard(
                text:
                    "Cidade Singular, seu app de divulgação de atividades, bens e serviços culturais! Visite ${singularity.title}.${userStore.user == null ? "": " Meu rank: ${getTitleUser(userStore.user!.xp)}"}",
              ).then((data) async {
                openCongratulationDialogue(
                    context, 'Obrigado por compartilhar!', 100, userStore.user);
                await addXp(100);
                print(data);
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              SocialShare.shareWhatsapp(
                "Cidade Singular, seu app de divulgação de atividades, bens e serviços culturais! Visite ${singularity.title}.${userStore.user == null ? "": " Meu rank: ${getTitleUser(userStore.user!.xp)}"}",
              ).then((data) async {
                openCongratulationDialogue(
                    context, 'Obrigado por compartilhar!', 100, userStore.user);
                await addXp(100);
                print(data);
              });
            },
            child: FaIcon(FontAwesomeIcons.whatsapp),
          ),
          ElevatedButton(
            child: FaIcon(FontAwesomeIcons.twitter),
            onPressed: () async {
              SocialShare.shareTwitter(
                "Cidade Singular, seu app de divulgação de atividades, bens e serviços culturais! Visite ${singularity.title}.${userStore.user == null ? "": " Meu rank: ${getTitleUser(userStore.user!.xp)}"}",
                hashtags: [
                  "CidadeSingular",
                  "UFCG",
                  singularity.title.replaceAll(" ", "")
                ],
                url: "",
              ).then((data) async {
                openCongratulationDialogue(
                    context, 'Obrigado por compartilhar!', 100, userStore.user);
                await addXp(100);
                print(data);
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              SocialShare.shareTelegram(
                "Cidade Singular, seu app de divulgação de atividades, bens e serviços culturais! Visite ${singularity.title}.${userStore.user == null ? "": " Meu rank: ${getTitleUser(userStore.user!.xp)}"}",
              ).then((data) async {
                openCongratulationDialogue(
                    context, 'Obrigado por compartilhar!', 100, userStore.user);
                await addXp(100);
                print(data);
              });
            },
            child: Icon(Icons.telegram),
          ),
          ElevatedButton(
              child: Icon(Icons.share),
              onPressed: () async {
                SocialShare.shareOptions(
                  "Cidade Singular, seu app de divulgação de atividades, bens e serviços culturais! Visite ${singularity.title}.${userStore.user == null ? "": " Meu rank: ${getTitleUser(userStore.user!.xp)}"}",
                ).then((data) async {
                  openCongratulationDialogue(context,
                      'Obrigado por compartilhar!', 100, userStore.user);
                  await addXp(100);
                  print(data);
                });
              }),
        ],
      ),
    );
  }

  String getTitleUser(int crias) {
    if (crias >= 5000) return 'Vice-Curador';
    if (crias >= 1001) return 'Visitante Criativo';
    if (crias >= 101) return 'Visitante Singular';
    return 'Visitante Descobridor';
  }

  Future openCongratulationDialogue(
          BuildContext context, String text, int points, User? user) =>
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
                        Text(
                            user == null
                                ? 'Faça login para acumular suas Crias!'
                                : "Você recebeu $points Crias.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: user == null
                                  ? Colors.red
                                  : Colors.greenAccent,
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
}
