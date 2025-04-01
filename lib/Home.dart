import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listaTarefas = [];

  TextEditingController _controllerTarefa = TextEditingController();

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;

    Map<String, dynamic> tarefa = Map();

    tarefa["titulo"] = textoDigitado;
    tarefa["realizada"] = false;
    setState(() {
      _listaTarefas.add(tarefa);
    });

    _controllerTarefa.text = "";
    _salvarArquivo();
  }

  _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(
      _listaTarefas,
    ); //converte LIST ou MAP em string Json
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = jsonDecode(dados);
      });
    });
  }

  Widget build(BuildContext context) {
    // _salvarArquivo();

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
                  controller: _controllerTarefa,
                  decoration: InputDecoration(labelText: "digite sua tarefa"),
                  onChanged: (text) {},
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                    child: Text("adicionar"),
                  ),
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
                  /*  return ListTile(title: Text(_listaTarefas[index]["titulo"]));*/

                  return CheckboxListTile(
                    title: Text(_listaTarefas[index]["titulo"]),
                    value: _listaTarefas[index]["realizada"],
                    onChanged: (valorAlterado) {
                      setState(() {
                        _listaTarefas[index]["realizada"] = valorAlterado;
                      });
                      _salvarArquivo();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
