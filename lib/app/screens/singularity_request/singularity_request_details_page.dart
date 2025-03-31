import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/user.dart';
import 'package:cidade_singular/app/screens/shared/add_photo_button.dart';
import 'package:cidade_singular/app/util/singularity_request_utils.dart';
import 'package:cidade_singular/app/util/URLImage.dart';
import 'package:flutter/material.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/user_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SingularityRequestDetailsPage extends StatefulWidget {
  final SingularityRequest request;

  const SingularityRequestDetailsPage({Key? key, required this.request}) : super(key: key);

  @override
  _SingularityRequestDetailsPageState createState() => _SingularityRequestDetailsPageState();
}

class _SingularityRequestDetailsPageState extends State<SingularityRequestDetailsPage> {
  final SingularityRequestService requestService = Modular.get();
  final SingularityService singularityService = Modular.get();
  final UserService userService = Modular.get();
  final UserStore userStore = Modular.get();
  late bool isCreator;
  late bool isCurator;

  late TextEditingController titleController;
  late TextEditingController visitingHoursController;
  late TextEditingController addressController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  final int minMaturity = 2;

  @override
  void initState() {
    super.initState();
    isCreator = userStore.user!.id == widget.request.creator;
    isCurator = userStore.user!.type == UserType.CURATOR;

    titleController = TextEditingController(text: widget.request.title);
    visitingHoursController = TextEditingController(text: widget.request.visitingHours);
    addressController = TextEditingController(text: widget.request.address);
    descriptionController = TextEditingController(text: widget.request.description);
    phoneController = TextEditingController(text: widget.request.phone);
    emailController = TextEditingController(text: widget.request.email);
  }

  Future<void> _approveRequest() async {
    try {
      GeoCode geoCode = GeoCode();
      Coordinates location = await geoCode.forwardGeocoding(
          address: widget.request.address
      );
      bool success = false;
      if (location.latitude!=null && location.longitude != null) {
         success = await singularityService.create(
             Singularity(
               id: '',
               title: widget.request.title,
               visitingHours: widget.request.visitingHours,
               address: widget.request.address,
               type: widget.request.type,
               description: widget.request.description,
               creator: widget.request.creator,
               city: widget.request.city,
               latLng: LatLng(location.latitude!, location.longitude!),
               photos: widget.request.photos,
               tags: widget.request.tags,
             ),
             fromRequest: true,
        );
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Singularidade aprovada com sucesso!")),
        );
        userService.update(
          id: widget.request.creator,
          type: UserType.ENTREPRENEUR.name,
        );
        requestService.delete(widget.request.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao aprovar singularidade.${location.latitude == null? " Endereço não encontrado, tente novamente.": ""}"),)
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao aprovar singularidade: $e")),
     );
    }
  }

  Future<void> _deleteRequest() async {
    bool success = await requestService.delete(widget.request.id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Requisição deletada com sucesso!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao deletar requisição.")),
      );
    }
  }

  Future<void> _updateRequest() async {
    widget.request.title = titleController.text;
    widget.request.visitingHours = visitingHoursController.text;
    widget.request.address = addressController.text;
    widget.request.description = descriptionController.text;
    widget.request.email = emailController.text != ""? emailController.text : null;
    widget.request.phone = phoneController.text != ""? phoneController.text : null;
    List<String> encodedNewPhotos = await SingularityResquestUtils.convertToEncodedList(newPhotos);
    bool success = await requestService.update(widget.request, newPhotos: encodedNewPhotos.isNotEmpty? encodedNewPhotos: null);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Requisição atualizada com sucesso!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar requisição.")),
      );
    }
  }

  final ImagePicker picker = ImagePicker();
  List<XFile> newPhotos = [];

  Widget _photoListWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...widget.request.photos.map((photoUrl) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: URLImage(photoUrl),
                      ),
                    ),
                    if (isCreator)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removePhoto(url: photoUrl),
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
              );
            }),
            ...newPhotos.map((photo) => Padding(
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
                      onTap: () => _removePhoto(file: photo),
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
            if (isCreator && newPhotos.length + widget.request.photos.length < 5)
              AddPhotoButton(onTap: _pickImage)
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (newPhotos.length < 5) {
          newPhotos.add(image);
        }
      });
    }
  }

  void _removePhoto({XFile? file, String? url}) {
    if(file!=null){
      setState(() {
        newPhotos.remove(file);
      });
    }
    if(url!=null){
      setState(() {
        widget.request.photos.remove(url);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Requisição")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _photoListWidget(),
                TextField(controller: titleController, enabled: isCreator, decoration: InputDecoration(labelText: "Título")),
                TextField(controller: visitingHoursController, enabled: isCreator, decoration: InputDecoration(labelText: "Horário de Visitação")),
                TextField(controller: addressController, enabled: isCreator, decoration: InputDecoration(labelText: "Endereço")),
                TextField(controller: descriptionController, enabled: isCreator, decoration: InputDecoration(labelText: "Descrição")),
                SizedBox(height: 20),
                if(isCreator || widget.request.email != null || widget.request.email != null)
                  Text("Contato", style: TextStyle(fontWeight: FontWeight.bold)),
                if(isCreator || widget.request.email != null)
                  TextField(controller: emailController, enabled: isCreator, decoration: InputDecoration(labelText: "E-mail para contato")),
                if(isCreator || widget.request.phone != null)
                  TextField(controller: phoneController, enabled: isCreator, decoration: InputDecoration(labelText: "Telefone para contato")),
                SizedBox(height: 20),
                Text("O Curador usa um conjunto de critérios de maturidade comprovados pelo empreendedor para avaliar o cadastro do empreendimento ou obra, com base na 1) visita in loco do curador ao empreendimento, 2) com base na sua consulta dos comentários e sugestões dos visitantes, e 3) com base na verificação dos critérios comprovados pelo empreendedor. O Curador atribui o nível de maturidade e edita o cadastro da singularidade com o selo correspondente. O selo do nível de maturidade do empreendimento será publicado junto com as informações no mapa da Cidade Singular. O empreendedor terá um botão de acesso a uma tela com a descrição do Selo Internacional de Empreendimento Singular e do Programa de Capacitação para progredir nos 5 níveis do selo. Cada Curador é coordenador do Programa do Selo para a área da economia criativa e será remunerado por esse trabalho. Terá menos funções do que o curador titular mas também poderá ser remunerado pelo empreendedor que recebe sua curadoria pela sua atuação como agente de marketing e vendas."),
                SizedBox(height: 20),
                Text("Nível de Maturidade", style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: widget.request.maturity.toDouble(),
                  min: 0,
                  max: 5,
                  divisions: 5,
                  label: widget.request.maturity.toString(),
                  onChanged: isCurator
                      ? (value) {
                          setState(() {
                            widget.request.maturity = value.toInt();
                          });
                      }
                      : null,
                  onChangeEnd: isCurator ? (value) => _updateRequest() : null,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isCreator)
                      ElevatedButton(
                        onPressed: _updateRequest,
                        child: Text("Salvar Alterações"),
                      ),
                    if (isCurator)
                      ElevatedButton(
                        onPressed: widget.request.maturity < minMaturity
                            ? () => ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Nível de maturidade insuficiente."))
                                    ,)
                            : _approveRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.request.maturity < minMaturity ? Colors.grey : Colors.blue,
                        ),
                        child: Text("Publicar"),
                      ),
                    if (isCreator)
                      ElevatedButton(
                        onPressed: _deleteRequest,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("Deletar"),
                      ),
                  ],
                ),
              ],
            ),
        )
      ),
    );
  }
}
