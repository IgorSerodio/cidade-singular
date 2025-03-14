import 'package:flutter/material.dart';
import 'package:cidade_singular/app/services/title_service.dart';
import 'package:cidade_singular/app/models/title.dart' as model;
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UserTitlesPage extends StatefulWidget {
  const UserTitlesPage({Key? key}) : super(key: key);

  @override
  _UserTitlesPageState createState() => _UserTitlesPageState();
}

class _UserTitlesPageState extends State<UserTitlesPage> {
  late Future<List<model.Title>> _titlesFuture;
  UserStore userStore = Modular.get();
  TitleService titleService = Modular.get();

  @override
  void initState() {
    super.initState();
    _fetchTitles();
  }

  void _fetchTitles() {
    setState(() {
      _titlesFuture = titleService.getByUser(userStore.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meus Títulos")),
      body: _buildTitleList(),
    );
  }

  Widget _buildTitleList() {
    return FutureBuilder<List<model.Title>>(
      future: _titlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erro ao carregar títulos"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Nenhum título encontrado."));
        }

        List<model.Title> titles = snapshot.data!;

        return ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            model.Title title = titles[index];
            return _buildTitleItem(title);
          },
        );
      },
    );
  }

  Widget _buildTitleItem(model.Title title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(title.description ?? "Sem descrição"),
      ),
    );
  }
}
