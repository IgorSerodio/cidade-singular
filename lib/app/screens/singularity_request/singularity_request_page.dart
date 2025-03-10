import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter/material.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/models/criative_economy_type.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cidade_singular/app/screens/shared/tool_tip_widget.dart';

class SingularityRequestPage extends StatefulWidget {
  const SingularityRequestPage({Key? key}) : super(key: key);

  @override
  _SingularityRequestPageState createState() => _SingularityRequestPageState();
}

class _SingularityRequestPageState extends State<SingularityRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final SingularityRequestService requestService = Modular.get();
  final UserStore userStore = Modular.get();
  final CityStore cityStore = Modular.get();

  String title = "";
  String visitingHours = "";
  String address = "";
  CriativeEconomyType? type;
  String description = "";

  @override
  void initState() {
    super.initState();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final request = SingularityRequest(
        id: "",
        title: title,
        visitingHours: visitingHours,
        address: address,
        type: type!,
        description: description,
        creator: userStore.user!.id,
        city: cityStore.city!.id
      );

      bool success = await requestService.create(request);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Requisição enviada com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao enviar requisição.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Requisitar uma singularidade")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cadastre seu empreendimento e faça parte da economia criativa da cidade!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              _buildTextField("Título", "Digite o título", (value) => title = value),
              _buildTextField("Horário de visitação", "Ex: 08:00 - 18:00", (value) => visitingHours = value),
              _buildTextField("Endereço", "Digite o endereço", (value) => address = value),
              _buildDropdownField(),
              _buildTextField("Descrição", "Descreva seu empreendimento", (value) => description = value),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Enviar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onSaved, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: ToolTipWidget(message: _getTooltipMessage(label)), // Use o novo ToolTipWidget
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) => value == null || value.isEmpty ? "Campo obrigatório" : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<CriativeEconomyType>(
        decoration: InputDecoration(
          labelText: "Tipo",
          suffixIcon: ToolTipWidget(message: _getTooltipMessage("Tipo")), // Use o novo ToolTipWidget
          border: OutlineInputBorder(),
        ),
        items: CriativeEconomyType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type.name),
          );
        }).toList(),
        validator: (value) => value == null ? "Selecione um tipo" : null,
        onChanged: (value) => setState(() => type = value),
      ),
    );
  }

  String _getTooltipMessage(String field) {
    switch (field) {
      case "Título":
        return "Informe o nome do seu empreendimento.";
      case "Horário de visitação":
        return "Horário em que o empreendimento está aberto.";
      case "Endereço":
        return "Localização do seu empreendimento.";
      case "Tipo":
        return "Selecione o tipo de economia criativa.";
      case "Descrição":
        return "Descreva seu empreendimento.";
      default:
        return "";
    }
  }
}
