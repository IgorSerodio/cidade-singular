import 'package:cidade_singular/app/screens/profile/user_tickets_page.dart';
import 'package:cidade_singular/app/screens/profile/user_titles_page.dart';
import 'package:flutter/material.dart';


class UserItemsButton extends StatelessWidget {
  final String itemType;

  const UserItemsButton({Key? key, required this.itemType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => itemType == "TICKET" ? const UserTicketsPage() : const UserTitlesPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              itemType == "TICKET" ? 'assets/images/ticket.png' : 'assets/images/title.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            itemType == "TICKET" ? "Meus Tickets" : "Meus Títulos",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
