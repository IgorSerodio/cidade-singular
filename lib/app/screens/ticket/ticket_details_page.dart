import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/ticket.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/ticket_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lottie/lottie.dart';

import '../shared/tool_tip_widget.dart';

class TicketDetailsPage extends StatefulWidget {
  final Ticket? ticket;

  const TicketDetailsPage({Key? key, this.ticket}) : super(key: key);

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  final _formKey = GlobalKey<FormState>();

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
    _nameController.text = widget.ticket!.name;
    _descriptionController.text = widget.ticket!.description;
    _selectedSingularityId = widget.ticket!.singularity;
  }

  void _loadSingularities() async {
    List<Singularity> singularities = await singularityService
        .getSingularities(query: {"creator": userStore.user!.id});
    setState(() {
      _singularities = singularities;
    });
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    Ticket ticket = Ticket(
      id: widget.ticket?.id ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      singularity: _selectedSingularityId!,
      creator: userStore.user!.id,
    );

    bool success = isEditing
        ? await ticketService.update(ticket)
        : await ticketService.create(ticket);

    _showSnackBar(success
        ? (isEditing
            ? "Ticket atualizado com sucesso!"
            : "Ticket criado com sucesso!")
        : "Erro ao salvar o ticket!");

    if (success) Modular.to.pop();
  }

  void _deleteTicket() async {
    if (!isEditing) return;

    bool success = await ticketService.delete(widget.ticket!.id);

    _showSnackBar(
        success ? "Ticket deletado com sucesso!" : "Erro ao deletar o ticket!");

    if (success) Modular.to.pop();
  }

  void _giveTicketToUser() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar("Informe o e-mail do usuário!");
      return;
    }

    bool success = await userService.giveManually(_emailController.text,
        ticketId: widget.ticket!.id);

    _showSnackBar(
        success ? "Ticket enviado com sucesso!" : "Erro ao enviar o ticket!");
  }

  _redeemUserTicket() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar("Informe o e-mail do usuário!");
      return;
    }

    String? errorMsg = await userService.redeemTicket(_emailController.text, widget.ticket!.id);

    if (errorMsg == null) {
      _openRedeemDialogue();
    } else {
      _showSnackBar("Erro ao resgatar o ticket. $errorMsg");
    }
  }

  Future _openRedeemDialogue() => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                  child: SizedBox(
                width: 500,
                child: SizedBox(
                  width: 200,
                  child: Column(children: [
                    Text("Ticket resgatado com sucesso",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        )),
                    Lottie.asset(
                      'assets/lottie/64963-topset-complete.json',
                    ),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Editar Ticket" : "Criar Ticket")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tickets podem ser dados como recompensas de missão ou manualmente. Eles podem ser resgatados apenas uma vez para fornecer um benefício real. Para benefícios permanentes, use títulos.",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  suffixIcon: ToolTipWidget(
                      message:
                          "Nome do ticket. Será exibido na descrição de missões que o darão como prêmio."),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "O nome é obrigatório"
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  suffixIcon: ToolTipWidget(
                      message:
                          "Informações sobre o ticket, como detalhes do seu benefício."),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Singularidade",
                  suffixIcon: ToolTipWidget(
                      message: "A singularidade relacionada ao ticket."),
                  border: OutlineInputBorder(),
                ),
                value: _selectedSingularityId,
                items: _singularities.map((singularity) {
                  return DropdownMenuItem(
                      value: singularity.id, child: Text(singularity.title));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSingularityId = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Selecione uma singularidade" : null,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveChanges,
                    child:
                        Text(isEditing ? "Salvar alterações" : "Criar Ticket"),
                  ),
                  if (isEditing) ...[
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _deleteTicket,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Deletar"),
                    ),
                  ],
                ],
              ),
              if (isEditing) ...[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Ações manuais de ticket",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail do usuário",
                    suffixIcon: ToolTipWidget(
                        message:
                            "Digite o e-mail do usuário que receberá ou resgatará o ticket."),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _giveTicketToUser,
                        child: Text("Dar Ticket para Usuário"),
                      ),
                      ElevatedButton(
                        onPressed: _redeemUserTicket,
                        child: Text("Resgatar ticket de Usuário"),
                      ),
                    ]),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
