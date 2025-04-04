import 'package:cidade_singular/app/screens/shared/add_photo_button.dart';
import 'package:cidade_singular/app/util/singularity_request_utils.dart';
import 'package:cidade_singular/app/stores/city_store.dart';
import 'package:flutter/material.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/models/creative_economy_type.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cidade_singular/app/screens/shared/tool_tip_widget.dart';
import 'package:image_picker/image_picker.dart';

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
  CreativeEconomyType? type;
  String description = "";
  String? phone;
  String? email;

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
          photos: await SingularityResquestUtils.convertToEncodedList(photos),
          city: cityStore.city!.id,
          phone: phone!=""? phone : null,
          email: email!=""? email : null,
      );

      bool success = await requestService.create(request);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Requisição de singularidade enviada com sucesso! Aguarde aprovação")),
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
      body: SingleChildScrollView(
        child: Padding(
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
                _buildTextField(
                    "Título", "Digite o título", (value) => title = value),
                _buildTextField("Horário de visitação", "Ex: 08:00 - 18:00",
                    (value) => visitingHours = value),
                _buildTextField("Endereço", "Digite o endereço",
                    (value) => address = value),
                _buildDropdownField(),
                _buildPhotoUploadField(),
                _buildTextField("Descrição", "Descreva seu empreendimento",
                    (value) => description = value),
                SizedBox(height: 20),
                Text("Contato", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTextField("E-mail", "Escreva um e-mail",
                    (value) => email = value, optional: true),
                _buildTextField("Número de telefone", "Digite um número de telefone",
                    (value) => phone = value, optional: true),
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
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onSaved,
      {int maxLines = 1, optional = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: ToolTipWidget(message: _getTooltipMessage(label)),
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator: (value) =>
            !optional && (value == null || value.isEmpty) ? "Campo obrigatório" : null,
        onSaved: (value) => onSaved(value!),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<CreativeEconomyType>(
        decoration: InputDecoration(
          labelText: "Tipo",
          suffixIcon: ToolTipWidget(message: _getTooltipMessage("Tipo")),
          border: OutlineInputBorder(),
        ),
        items: CreativeEconomyType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type.value),
          );
        }).toList(),
        validator: (value) => value == null ? "Selecione um tipo" : null,
        onChanged: (value) => setState(() => type = value),
      ),
    );
  }

  final ImagePicker picker = ImagePicker();
  List<XFile> photos = [];

  Widget _buildPhotoUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fotos",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...photos.map((photo) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        photo.path,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(photo),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.7),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              if (photos.length < 5)
                AddPhotoButton(onTap: _pickImage)
            ],
          ),
        ),
      ],
    );
  }

  void _removePhoto(XFile photo) {
    setState(() {
      photos.remove(photo);
    });
  }

  void _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (photos.length < 5) {
          photos.add(image);
        }
      });
    }
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
      case "E-mail"  :
        return "Informe um e-mail para contato (opcional)";
      case "Número de telefone" :
        return "Informe um número de telefone contato (opcional)";
      default:
        return "";
    }
  }
}
