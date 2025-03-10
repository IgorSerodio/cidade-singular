import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/ticket.dart';
import 'package:cidade_singular/app/models/title.dart' as model;
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/ticket_service.dart';
import 'package:cidade_singular/app/services/title_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:cidade_singular/app/util/mission_progress_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../models/progress.dart';
import '../shared/tool_tip_widget.dart';
import 'mission_widget.dart';

class MissionDetailsPage extends StatefulWidget {
  final Mission? missionToEdit;

  const MissionDetailsPage({Key? key, this.missionToEdit}) : super(key: key);

  @override
  _MissionDetailsPageState createState() => _MissionDetailsPageState();
}

class _MissionDetailsPageState extends State<MissionDetailsPage> {
  final MissionService missionService = Modular.get();
  final SingularityService singularityService = Modular.get();
  final TicketService ticketService = Modular.get();
  final TitleService titleService = Modular.get();
  final UserStore userStore = Modular.get();
  final UserService userService = Modular.get();

  String? _selectedSingularityId;
  TaskType? _selectedTask;
  String? _selectedRewardType;
  String? _selectedRewardId;
  List<Singularity> _singularities = [];
  List<Ticket> _tickets = [];
  List<model.Title> _titles = [];

  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _customDescriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSingularities();

    if (widget.missionToEdit != null) {
      _selectedSingularityId = widget.missionToEdit?.tags.first;
      _selectedRewardType = widget.missionToEdit?.rewardType.name;
      _selectedRewardId = widget.missionToEdit?.reward;
      _targetController.text = widget.missionToEdit?.target.toString() ?? '';
    }
  }

  void _loadSingularities() async {
    List<Singularity> singularities = await singularityService.getByCreator(userStore.user!.id);
    setState(() {
      _singularities = singularities;
    });
  }

  Map<TaskType, String> taskText = {
    TaskType.VISIT: "Visite",
    TaskType.REVIEW: "Avalie",
    TaskType.CUSTOM: "???",
  };

  String _generateDescription() {
    if (_selectedSingularityId == null ||
        _selectedTask == null ||
        _selectedRewardId == null ||
        _targetController.text.isEmpty) {
      if(widget.missionToEdit != null && widget.missionToEdit!.description != null){
        return widget.missionToEdit!.description;
      }
      return "Descrição prévia da missão";
    }

    String singularityTitle = _singularities.firstWhere((s) => s.id == _selectedSingularityId).title;
    String rewardName = _selectedRewardType == "TICKET"
        ? _tickets.firstWhere((t) => t.id == _selectedRewardId).name
        : _titles.firstWhere((t) => t.id == _selectedRewardId).name;
    String rewardType = _selectedRewardType == "TICKET" ? "ingresso" : "título";

    return "${taskText[_selectedTask]} ${_targetController.text} vezes a singularidade $singularityTitle para ganhar o $rewardType $rewardName. ${_customDescriptionController.text}";
  }

  void _createOrUpdateMission() async {
    if (_selectedSingularityId == null || _selectedTask == null || _selectedRewardId == null || _targetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos obrigatórios!")),
      );
      return;
    }

    Mission mission = Mission(
      id: widget.missionToEdit?.id ?? "",
      city: _singularities.firstWhere((s) => s.id == _selectedSingularityId).city,
      description: _generateDescription(),
      tags: [_selectedSingularityId!, _selectedTask!.name],
      target: int.parse(_targetController.text),
      reward: _selectedRewardId!,
      rewardType: _selectedRewardType == "TICKET" ? RewardType.TICKET : RewardType.TITLE,
      sponsor: userStore.user!.id,
    );

    bool success;
    if (widget.missionToEdit == null) {
      success = await missionService.create(mission);
    } else {
      success = await missionService.update(mission);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.missionToEdit == null ? "Missão criada com sucesso!" : "Missão atualizada com sucesso!")),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao ${widget.missionToEdit == null ? 'criar' : 'atualizar'} a missão!")),
      );
    }
  }

  void _deleteMission() async {
    if (widget.missionToEdit == null) return;

    bool success = await missionService.delete(widget.missionToEdit!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Missão deletada com sucesso!")),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar a missão!")),
      );
    }
  }

  void _increaseProgressManually() async {
    String email = _emailController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, forneça um e-mail válido!")),
      );
      return;
    }

    bool success = await userService.increaseProgressManually(email, widget.missionToEdit!.id);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Progresso manual aumentado com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao aumentar o progresso manual!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.missionToEdit == null ? "Criar Missão Patrocinada" : "Editar Missão Patrocinada")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Singularidade"),
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
                ),
                ToolTipWidget(message: "Escolha uma singularidade que você criou."),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TaskType>(
                    decoration: InputDecoration(labelText: "Objetivo"),
                    value: _selectedTask,
                    items: TaskType.values.map((tag) {
                      return DropdownMenuItem(value: tag, child: Text(tag.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTask = value;
                      });
                    },
                  ),
                ),
                ToolTipWidget(message: "Escolha o objetivo da missão."),
              ],
            ),
            if (_selectedTask == TaskType.CUSTOM)
              TextField(
                controller: _customDescriptionController,
                decoration: InputDecoration(labelText: "Texto Personalizado para o objetivo. Ação da vida real que deve ser resgistrada manualmente. Exemplos: Poste fotos, Coma pratos."),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(labelText: "Ação"),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                taskText[TaskType.CUSTOM] = value;
              }),
            ),
            ToolTipWidget(message: "Número de vezes que a ação precisa ser realizada para completar a missão."),
            SizedBox(height: 20),
            if (widget.missionToEdit != null) ...[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "E-mail para incremento manual"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _increaseProgressManually,
                child: Text("Aumentar Progresso Manual"),
              ),
            ],
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _createOrUpdateMission,
                  child: Text(widget.missionToEdit == null ? "Criar Missão" : "Atualizar Missão"),
                ),
                if(widget.missionToEdit != null)
                  ElevatedButton(
                    onPressed: _deleteMission,
                    child: Text("Deletar Missão"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
