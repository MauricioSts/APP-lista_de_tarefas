import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = ["Ir ao mercado", "Estudar Flutter", "ir ao cinema"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Adicionar tarefa"),
                content: TextField(
                  decoration: InputDecoration(labelText: "digite sua tarefa"),
                  onChanged: (text) {},
                ),
                actions: [
                  TextButton(onPressed: () {}, child: Text("adicionar")),
                  TextButton(
                    child: Text("cancelar"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(_listaTarefas[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
