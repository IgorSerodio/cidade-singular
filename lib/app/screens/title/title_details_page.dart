import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/title.dart' as model;
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/title_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../shared/tool_tip_widget.dart';

class TitleDetailsPage extends StatefulWidget {
  final model.Title? title;

  const TitleDetailsPage({Key? key, this.title}): super(key: key);

  @override
  _TitleDetailsPageState createState() => _TitleDetailsPageState();
}

class _TitleDetailsPageState extends State<TitleDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TitleService titleService = Modular.get();
  final SingularityService singularityService = Modular.get();
  final UserService userService = Modular.get();
  final UserStore userStore = Modular.get();

  String? _selectedSingularityId;
  List<Singularity> _singularities = [];

  bool get isEditing => widget.title != null;

  @override
  void initState() {
    super.initState();
    _loadSingularities();
    if (isEditing) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    _nameController.text = widget.title!.name;
    _descriptionController.text = widget.title!.description;
    _selectedSingularityId = widget.title!.singularity;
  }

  void _loadSingularities() async {
    List<Singularity> singularities = await singularityService.getSingularities(query: {
      "creator": userStore.user!.id
    });
    setState(() {
      _singularities = singularities;
    });
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    model.Title updatedTitle = model.Title(
      id: widget.title?.id ?? "",
      name: _nameController.text,
      description: _descriptionController.text,
      singularity: _selectedSingularityId!,
      creator: userStore.user!.id,
    );

    bool success = isEditing
        ? await titleService.update(updatedTitle)
        : await titleService.create(updatedTitle);

    if (success) {
      _showSnackBar(isEditing
          ? "Título atualizado com sucesso!"
          : "Título criado com sucesso!");
      Modular.to.pop();
    } else {
      _showSnackBar("Erro ao salvar o título!");
    }
  }

  void _deleteTitle() async {
    if (widget.title == null) return;

    bool success = await titleService.delete(widget.title!.id);

    if (success) {
      _showSnackBar("Título deletado com sucesso!");
      Modular.to.pop();
    } else {
      _showSnackBar("Erro ao deletar o título!");
    }
  }

  void _giveTitleToUser() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar("Informe o e-mail do usuário!");
      return;
    }

    bool success =
    await userService.giveManually(_emailController.text, titleId: widget.title!.id);

    _showSnackBar(success
        ? "Título enviado com sucesso!"
        : "Erro ao enviar o título!");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Detalhes do Título" : "Criar Título"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Títulos podem ser dados como recompensas de missão ou manualmente e fornecem benefícios ou permissões permanentes.",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nome",
                  suffixIcon: ToolTipWidget(
                    message: "Nome do título. Será exibido na descrição de missões.",
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Campo obrigatório" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  suffixIcon: ToolTipWidget(
                    message: "Permissões, benefícios e outras características do título.",
                  ),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Singularidade",
                  suffixIcon: ToolTipWidget(
                    message: "A singularidade relacionada ao título.",
                  ),
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
                    child: Text(isEditing ? "Salvar mudanças" : "Criar"),
                  ),
                  if (isEditing)
                    ElevatedButton(
                      onPressed: _deleteTitle,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Deletar"),
                    ),
                ],
              ),
              if (isEditing) ...[
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Ações manuais de título",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail do usuário",
                    suffixIcon: ToolTipWidget(
                      message: "Digite o e-mail do usuário que receberá o título.",
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _giveTitleToUser,
                    child: Text("Dar Título para Usuário"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
