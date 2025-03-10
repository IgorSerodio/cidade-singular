import 'package:cidade_singular/app/screens/singularity_request/singularity_request_details_page.dart';
import 'package:flutter/material.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SingularityRequestListPage extends StatefulWidget {

  const SingularityRequestListPage({Key? key}) : super(key: key);

  @override
  _SingularityRequestListPageState createState() => _SingularityRequestListPageState();
}

class _SingularityRequestListPageState extends State<SingularityRequestListPage> {
  late SingularityRequestService singularityRequestService;
  List<SingularityRequest> requests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    singularityRequestService = Modular.get();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    try {
      final UserStore userStore = Modular.get();
      final user = userStore.user;

      if (user == null || user.curatorType == null) {
        setState(() => isLoading = false);
        return;
      }

      final fetchedRequests = await singularityRequestService.getByType(user.curatorType!);
      setState(() {
        requests = fetchedRequests;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar requests: $e");
      setState(() => isLoading = false);
    }
  }

  void _navigateToDetails(SingularityRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingularityRequestDetailsPage(request: request),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Requisições de Singularidade")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : requests.isEmpty
          ? Center(child: Text("Nenhuma requisição encontrada."))
          : ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(request.title),
              onTap: () => _navigateToDetails(request),
            ),
          );
        },
      ),
    );
  }
}
