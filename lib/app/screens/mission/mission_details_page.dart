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
  String? _selectedTarget;
  RewardType? _selectedRewardType;
  String? _selectedRewardId;
  String _extraDescription = "";
  List<Singularity> _singularities = [];
  List<Ticket> _tickets = [];
  List<model.Title> _titles = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _customTaskController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _extraDescriptionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOwned();

    if (widget.missionToEdit != null) {
      _selectedSingularityId = widget.missionToEdit?.tags.first;
      _selectedRewardType = widget.missionToEdit?.rewardType;
      _selectedRewardId = widget.missionToEdit?.reward;
      _selectedTarget = widget.missionToEdit?.target.toString() ?? '0';
    }
  }

  void _loadOwned() async {
    final singularities = await singularityService.getSingularities(query: {"creator": userStore.user!.id});
    final tickets = await ticketService.getByCreator(userStore.user!.id);
    final titles = await titleService.getByCreator(userStore.user!.id);
    setState(() {
      _tickets = tickets;
      _titles = titles;
      _singularities = singularities;
    });
  }

  List<dynamic> selectRewardList(RewardType type){
    switch(type){
      case RewardType.TICKET:
        return _tickets;
      case RewardType.TITLE:
        return _titles;
      default:
        return [];
    }
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
        _targetController == null ||
        _selectedRewardType == null) {
      if (widget.missionToEdit != null &&
          widget.missionToEdit!.description != null) {
        return widget.missionToEdit!.description;
      }
      return "Descrição prévia da missão";
    }

    String singularityTitle =
        _singularities.firstWhere((s) => s.id == _selectedSingularityId).title;
    String rewardName = _selectedRewardType!.name == "TICKET"
        ? _tickets.firstWhere((t) => t.id == _selectedRewardId).name
        : _titles.firstWhere((t) => t.id == _selectedRewardId).name;
    RewardType rewardType = _selectedRewardType!;

    return "${taskText[_selectedTask]} $_selectedTarget vezes a singularidade $singularityTitle para ganhar o ${rewardType.name.toLowerCase()} $rewardName. $_extraDescription";
  }

  void _createOrUpdateMission() async {
    if (_selectedSingularityId == null ||
        _selectedTask == null ||
        _selectedRewardId == null ||
        _selectedTarget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Preencha todos os campos obrigatórios!")),
      );
      return;
    }

    Mission mission = Mission(
      id: widget.missionToEdit?.id ?? "",
      city:
          _singularities.firstWhere((s) => s.id == _selectedSingularityId).city,
      description: _generateDescription(),
      tags: [_selectedSingularityId!, _selectedTask!.name],
      target: int.parse(_selectedTarget!),
      reward: _selectedRewardId!,
      rewardType: _selectedRewardType!.name == "TICKET"
          ? RewardType.TICKET
          : RewardType.TITLE,
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
        SnackBar(
            content: Text(widget.missionToEdit == null
                ? "Missão criada com sucesso!"
                : "Missão atualizada com sucesso!")),
      );
      Modular.to.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Erro ao ${widget.missionToEdit == null ? 'criar' : 'atualizar'} a missão!")),
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

    bool success = await userService.increaseProgressManually(
        email, widget.missionToEdit!.id);

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
      appBar: AppBar(
          title: Text(widget.missionToEdit == null
              ? "Criar Missão Patrocinada"
              : "Editar Missão Patrocinada"
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Singularidade",
                    suffixIcon: ToolTipWidget(
                        message: "Escolha uma singularidade que você criou."),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedSingularityId,
                  items: _singularities.map((singularity) {
                    return DropdownMenuItem(
                        value: singularity.id, child: Text(singularity.title));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedSingularityId = value),
                  validator: (value) =>
                      value == null ? "Selecione uma singularidade" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<TaskType>(
                  decoration: InputDecoration(
                    labelText: "Objetivo",
                    suffixIcon:
                        ToolTipWidget(message: "Escolha o objetivo da missão."),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedTask,
                  items: TaskType.values.map((task) {
                    return DropdownMenuItem(
                        value: task, child: Text(task.name));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedTask = value),
                  validator: (value) =>
                      value == null ? "Selecione um objetivo" : null,
                ),
                const SizedBox(height: 20),
                if (_selectedTask == TaskType.CUSTOM) ...[
                  TextFormField(
                    controller: _customTaskController,
                    decoration: InputDecoration(
                      labelText: "Ação Personalizada para o objetivo",
                      suffixIcon: ToolTipWidget(
                          message:
                              "Descreva a ação personalizada para esta missão. Exemplos: Peça pratos, Tire fotos com as artes, Compre artesanato"),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty
                        ? "Digite uma descrição personalizada"
                        : null,
                    onChanged: (value) => taskText[TaskType.CUSTOM] = value!,
                  ),
                  const SizedBox(height: 20),
                ],
                TextFormField(
                  controller: _targetController,
                  decoration: InputDecoration(
                    labelText: "Número de vezes",
                    suffixIcon: ToolTipWidget(
                        message:
                            "Número de vezes que a ação precisa ser realizada para completar a missão."),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => _selectedTarget = value),
                  validator: (value) =>
                      int.tryParse(value!) == null ? "Digite um número" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<RewardType>(
                  decoration: InputDecoration(
                    labelText: "Tipo de recompensa",
                    suffixIcon: ToolTipWidget(
                        message: "Escolha o tipo de recompensa da missão."),
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedRewardType,
                  items: RewardType.values.where((type) => type != RewardType.ACCESSORY)
                      .map((type) {
                    return DropdownMenuItem(
                        value: type, child: Text(type.name));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedRewardType = value),
                  validator: (value) =>
                      value == null ? "Selecione um tipo" : null,
                ),
                const SizedBox(height: 20),
                if(_selectedRewardType != null) ...[
                  DropdownButtonFormField<dynamic>(
                    decoration: InputDecoration(
                      labelText: "Recompensa",
                      suffixIcon: ToolTipWidget(
                          message: "Escolha a recompensa do tipo selecionado. Caso a lista estiver vazia, crie recompensas no menu de empreendedor ou escolha outro tipo"),
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedRewardId,
                    items: selectRewardList(_selectedRewardType!).map((item) {
                      return DropdownMenuItem(
                          value: item.id, child: Text(item.name));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedRewardId = value),
                    validator: (value) =>
                    value == null ? "Selecione um prêmio" : null,
                  ),
                  const SizedBox(height: 20),
                ],
                TextFormField(
                  controller: _extraDescriptionController,
                  decoration: InputDecoration(
                    labelText: "Descrição adicional (opcional)",
                    suffixIcon: ToolTipWidget(
                        message:
                            "Detalhes adicionais que você queira acrescentar."),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) =>
                      setState(() => _extraDescription = value),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _createOrUpdateMission,
                      child: Text(widget.missionToEdit == null
                          ? "Criar Missão"
                          : "Atualizar Missão"),
                    ),
                    if (widget.missionToEdit != null)
                      ElevatedButton(
                        onPressed: _deleteMission,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        child: const Text("Deletar Missão"),
                      ),
                  ],
                ),
                if (widget.missionToEdit != null) ...[
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Ações manuais de missão",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "E-mail do usuário",
                      suffixIcon: ToolTipWidget(
                          message:
                              "E-mail do usuário que receberá progresso de missão. Use com missões personalizadas"),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _increaseProgressManually,
                      child: Text("Aumentar Progresso Manualmente"),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "Prévia",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MissionProgressWidget(
                    missionProgress: MapEntry(
                        Progress(
                            missionId: "",
                            target: int.tryParse(_targetController.text) ?? 0,
                            value: 0,
                            sources: []),
                        Mission(
                          id: "",
                          city: "",
                          description: _generateDescription(),
                          tags: [],
                          target: int.tryParse(_targetController.text) ?? 0,
                          reward: "",
                          rewardType: _selectedRewardType == RewardType.TICKET
                              ? RewardType.TICKET
                              : RewardType.TITLE,
                          sponsor: "",
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
