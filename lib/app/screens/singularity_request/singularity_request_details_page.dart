import 'package:cidade_singular/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/user_service.dart';

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
      List<Location> locations = await locationFromAddress(widget.request.address);
      if (locations.isNotEmpty) {
        bool success = await singularityService.create(
          title: widget.request.title,
          visitingHours: widget.request.visitingHours,
          address: widget.request.address,
          type: widget.request.type,
          description: widget.request.description,
          creator: widget.request.creator,
          city: widget.request.city,
          location: LatLng(locations.first.latitude, locations.first.longitude),
        );

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
            SnackBar(content: Text("Erro ao aprovar singularidade.")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao aprovar singularidade.")),
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

    bool success = await requestService.update(widget.request.id, widget.request);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes da Requisição")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
