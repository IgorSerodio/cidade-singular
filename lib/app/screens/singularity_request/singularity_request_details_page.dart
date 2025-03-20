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

  @override
  void initState() {
    super.initState();
    isCreator = userStore.user!.id == widget.request.creator;
    isCurator = userStore.user!.type == UserType.CURATOR;

    titleController = TextEditingController(text: widget.request.title);
    visitingHoursController = TextEditingController(text: widget.request.visitingHours);
    addressController = TextEditingController(text: widget.request.address);
    descriptionController = TextEditingController(text: widget.request.description);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _photoListWidget(),
            TextField(controller: titleController, enabled: isCreator, decoration: InputDecoration(labelText: "Título")),
            TextField(controller: visitingHoursController, enabled: isCreator, decoration: InputDecoration(labelText: "Horário de Visitação")),
            TextField(controller: addressController, enabled: isCreator, decoration: InputDecoration(labelText: "Endereço")),
            TextField(controller: descriptionController, enabled: isCreator, decoration: InputDecoration(labelText: "Descrição")),
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
                    onPressed: _approveRequest,
                    child: Text("Aprovar"),
                  ),
                if (isCreator || isCurator)
                  ElevatedButton(
                    onPressed: _deleteRequest,
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
