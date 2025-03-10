import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/ticket.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/ticket_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../shared/tool_tip_widget.dart';

class TicketDetailsPage extends StatefulWidget {
  final Ticket? ticket;

  const TicketDetailsPage({Key? key, this.ticket}) : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TicketService ticketService = Modular.get();
  final SingularityService singularityService = Modular.get();
  final UserService userService = Modular.get();
  final UserStore userStore = Modular.get();

  String? _selectedSingularityId;
  List<Singularity> _singularities = [];

  bool get isEditing => widget.ticket != null;

  @override
  void initState() {
    super.initState();
    _loadSingularities();
    if (isEditing) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    _nameController.text = widget.ticket?.name ?? '';
    _descriptionController.text = widget.ticket?.description ?? '';
    _selectedSingularityId = widget.ticket?.singularity ?? '';
  }

  void _loadSingularities() async {
    List<Singularity> singularities = await singularityService.getByCreator(userStore.user!.id);
    setState(() {
      _singularities = singularities;
    });
  }

  void _saveChanges() async {
    if (_nameController.text.isEmpty || _selectedSingularityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos obrigatórios!")),
      );
      return;
    }

    Ticket ticket = Ticket(
      id: widget.ticket?.id ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      singularity: _selectedSingularityId!,
    );

    bool success;
    if (isEditing) {
      success = await ticketService.update(ticket);
    } else {
      success = await ticketService.create(ticket);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? "Ticket atualizado com sucesso!" : "Ticket criado com sucesso!")),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditing ? "Erro ao atualizar o ticket!" : "Erro ao criar o ticket!")),
      );
    }
  }

  void _deleteTicket() async {
    if (!isEditing) return;

    bool success = await ticketService.delete(widget.ticket!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ticket deletado com sucesso!")),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar o ticket!")),
      );
    }
  }

  void _giveTicketToUser() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Informe o e-mail do usuário!")),
      );
      return;
    }

    bool success = await userService.giveManually(_emailController.text, ticketId: widget.ticket!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ticket enviado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar o ticket!")),
      );
    }
  }

  String _getTooltipMessage(String field) {
    switch (field) {
      case "Nome":
        return "Nome do ticket. Será exibido na descrição de missões que o darão como prêmio.";
      case "Descrição":
        return "Informações sobre o ticket, como detalhes do seu benefício.";
      case "Singularidade":
        return "A singularidade relacionada ao ticket.";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Ticket" : "Criar Ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tickets podem ser dados como recompensas de missão ou manualmente e servem para ser resgatados apenas uma vez, fornecendo um benefício da vida real à sua escolha. Para benefícios permanentes use títulos.",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nome",
                suffixIcon: ToolTipWidget(message: _getTooltipMessage("Nome")),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descrição",
                suffixIcon: ToolTipWidget(message: _getTooltipMessage("Descrição")),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Singularidade",
                suffixIcon: ToolTipWidget(message: _getTooltipMessage("Singularidade")),
              ),
              value: _selectedSingularityId,
              items: _singularities.map((singularity) {
                return DropdownMenuItem(value: singularity.id, child: Text(singularity.title));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSingularityId = value;
                });
              },
            ),
            if (isEditing) ...[
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Enviar ticket manualmente para usuário"),
                    ),
                  ),
                  ToolTipWidget(message: "Digite o e-mail do usuário que receberá o ticket."),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _giveTicketToUser,
                  child: Text("Dar Ticket para Usuário"),
                ),
              ),
            ],
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text(isEditing ? "Salvar alterações" : "Criar Ticket"),
                ),
                if(isEditing)
                ElevatedButton(
                  onPressed: _deleteTicket,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Deletar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
