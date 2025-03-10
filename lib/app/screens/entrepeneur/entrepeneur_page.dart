import 'package:cidade_singular/app/models/progress.dart';
import 'package:cidade_singular/app/models/singularity.dart';
import 'package:cidade_singular/app/models/ticket.dart';
import 'package:cidade_singular/app/models/title.dart' as model;
import 'package:cidade_singular/app/models/mission.dart';
import 'package:cidade_singular/app/models/singularity_request.dart';
import 'package:cidade_singular/app/screens/mission/mission_widget.dart';
import 'package:cidade_singular/app/screens/singularity/singularity_page.dart';
import 'package:cidade_singular/app/screens/singularity_request/singularity_request_details_page.dart';
import 'package:cidade_singular/app/screens/singularity_request/singularity_request_page.dart';
import 'package:cidade_singular/app/screens/ticket/ticket_details_page.dart';
import 'package:cidade_singular/app/screens/title/title_details_page.dart';
import 'package:cidade_singular/app/screens/mission/mission_details_page.dart';
import 'package:cidade_singular/app/services/singularity_service.dart';
import 'package:cidade_singular/app/services/ticket_service.dart';
import 'package:cidade_singular/app/services/title_service.dart';
import 'package:cidade_singular/app/services/mission_service.dart';
import 'package:cidade_singular/app/services/singularity_request_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class EntrepreneurPage extends StatefulWidget {
  const EntrepreneurPage({Key? key}) : super(key: key);

  @override
  _EntrepreneurPageState createState() => _EntrepreneurPageState();
}

class _EntrepreneurPageState extends State<EntrepreneurPage> {
  final UserStore userStore = Modular.get();
  final SingularityService singularityService = Modular.get();
  final TitleService titleService = Modular.get();
  final TicketService ticketService = Modular.get();
  final MissionService missionService = Modular.get();
  final SingularityRequestService singularityRequestService = Modular.get();

  int _selectedTab = 0;

  List<Singularity> _singularities = [];
  List<model.Title> _titles = [];
  List<SingularityRequest> _requests = [];
  List<Ticket> _tickets = [];
  List<Mission> _missions = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final userId = userStore.user!.id;

    final singularities = await singularityService.getByCreator(userId);
    final titles = await titleService.getByCreator(userId);
    final requests = await singularityRequestService.getByCreator(userId);
    final tickets = await ticketService.getByCreator(userId);
    final missions = await missionService.getBySponsor(userId);

    setState(() {
      _singularities = singularities;
      _titles = titles;
      _requests = requests;
      _tickets = tickets;
      _missions = missions;
    });
  }

  void _navigateToDetails(dynamic item) {
    if (item is Singularity) {
      Modular.to.push(MaterialPageRoute(builder: (_) => SingularityPage(singularity: item)));
    } else if (item is model.Title) {
      Modular.to.push(MaterialPageRoute(builder: (_) => TitleDetailsPage(title: item)));
    } else if (item is SingularityRequest) {
      Modular.to.push(MaterialPageRoute(builder: (_) => SingularityRequestDetailsPage(request: item)));
    } else if (item is Ticket) {
      Modular.to.push(MaterialPageRoute(builder: (_) => TicketDetailsPage(ticket: item)));
    } else if (item is Mission) {
      Modular.to.push(MaterialPageRoute(builder: (_) => MissionDetailsPage(missionToEdit: item)));
    }
  }

  void _createNew() {
    switch (_selectedTab) {
      case 0:
        Modular.to.push(MaterialPageRoute(builder: (_) => SingularityRequestPage()));
        break;
      case 1:
        Modular.to.push(MaterialPageRoute(builder: (_) => TitleDetailsPage()));
        break;
      case 2:
        Modular.to.push(MaterialPageRoute(builder: (_) => SingularityRequestPage()));
        break;
      case 3:
        Modular.to.push(MaterialPageRoute(builder: (_) => TicketDetailsPage()));
        break;
      case 4:
        Modular.to.push(MaterialPageRoute(builder: (_) => MissionDetailsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> tabTitles = [
      "Singularidades",
      "Títulos",
      "Requisições",
      "Tickets",
      "Missões"
    ];

    final List<Widget> lists = [
      _buildList(_singularities, "Nenhuma singularidade encontrada"),
      _buildList(_titles, "Nenhum título encontrado"),
      _buildList(_requests, "Nenhuma requisição encontrada"),
      _buildList(_tickets, "Nenhum ticket encontrado"),
      _buildList(_missions, "Nenhuma missão encontrada"),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Menu do Empreendedor")),
      body: Column(
        children: [
          _buildTabButtons(tabTitles),
          Expanded(child: lists[_selectedTab]),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _createNew,
              child: Text("Criar Novo"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(List<String> tabTitles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabTitles.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedTab == index ? Colors.blue : Colors.grey,
              ),
              child: Text(tabTitles[index]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildList(List<dynamic> items, String emptyMessage) {
    return items.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if(item is Mission) {
          return MissionProgressWidget(
              missionProgress: MapEntry(Progress(missionId: "", value: 0, target: item.target, sources: []), item),
              onTap: () => _navigateToDetails(item)
          );
        }
        return ListTile(
          title: Text(_getItemTitle(item)),
          onTap: () => _navigateToDetails(item),
        );
      },
    );
  }

  String _getItemTitle(dynamic item) {
    if (item is Singularity) return item.title;
    if (item is model.Title) return item.name;
    if (item is SingularityRequest) return "Requisição: ${item.title}";
    if (item is Ticket) return item.name;
    if (item is Mission) return item.description;
    return "Item Desconhecido";
  }
}
