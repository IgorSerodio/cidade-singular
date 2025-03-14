import 'package:cidade_singular/app/models/owned_ticket.dart';
import 'package:cidade_singular/app/services/ticket_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';

import 'package:cidade_singular/app/models/ticket.dart';
import 'package:flutter_modular/flutter_modular.dart';


class UserTicketsPage extends StatefulWidget {

  const UserTicketsPage({Key? key}) : super(key: key);

  @override
  _UserTicketsPageState createState() => _UserTicketsPageState();
}

class _UserTicketsPageState extends State<UserTicketsPage> {
  late Future<List<Ticket>> _ticketsFuture;
  TicketService ticketService = Modular.get();
  UserStore userStore = Modular.get();
  bool _showIrredeemable = false;

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  void _fetchTickets() {
    setState(() {
      _ticketsFuture = ticketService.getByUser(userStore.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Tickets")),
      body: Column(
        children: [
          _buildToggle(),
          Expanded(child: _buildTicketList()),
        ],
      ),
    );
  }

  bool _isRedeemable(Ticket ticket){
    return userStore.user!.tickets.firstWhere(
            (ot) => ot.ticketId == ticket.id,
            orElse: () => OwnedTicket(ticketId: "", redeemable: false)).redeemable;
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Exibir irresgatáveis"),
          Switch(
            value: _showIrredeemable,
            onChanged: (value) {
              setState(() {
                _showIrredeemable = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    return FutureBuilder<List<Ticket>>(
      future: _ticketsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar tickets"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nenhum ticket encontrado."));
        }

        List<Ticket> tickets = snapshot.data!;

        if (!_showIrredeemable) {
          tickets = tickets.where((ticket) => _isRedeemable(ticket)).toList();
        }

        tickets.sort((a, b) => _isRedeemable(b).toString().compareTo(_isRedeemable(a).toString()));

        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            Ticket ticket = tickets[index];
            return _buildTicketItem(ticket);
          },
        );
      },
    );
  }

  Widget _buildTicketItem(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _isRedeemable(ticket)? Colors.white : Colors.grey[700],
      child: ListTile(
        title: Text(
          ticket.name,
          style: TextStyle(
            color: _isRedeemable(ticket) ? Colors.black : Colors.white70,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticket.description,
              style: TextStyle(
                color: _isRedeemable(ticket) ? Colors.black87 : Colors.white54,
              ),
            ),
            Text(
              _isRedeemable(ticket) ? "Resgatável" : "Irresgatável",
              style: TextStyle(
                color: _isRedeemable(ticket) ? Colors.green : Colors.red[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
