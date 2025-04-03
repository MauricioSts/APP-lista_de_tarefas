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
  Map<String, dynamic> _ultimaRemovida = Map();

  TextEditingController _controllerTarefa = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  Future<void> _salvarArquivo() async {
    var arquivo = await _getFile();
    String dados = json.encode(_listaTarefas);
    await arquivo.writeAsString(dados);
  }

  Future<void> _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      if (await arquivo.exists()) {
        String dados = await arquivo.readAsString();
        if (dados.isNotEmpty) {
          setState(() {
            _listaTarefas = jsonDecode(dados);
          });
        } else {
          setState(() {
            _listaTarefas = [];
          });
        }
      } else {
        setState(() {
          _listaTarefas = [];
        });
      }
    } catch (e) {
      print("Erro ao ler o arquivo: $e");
      setState(() {
        _listaTarefas = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo();
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text.trim();
    if (textoDigitado.isEmpty) return;

    Map<String, dynamic> tarefa = {"titulo": textoDigitado, "realizada": false};

    setState(() {
      _listaTarefas.add(tarefa);
    });

    _controllerTarefa.clear();
    _salvarArquivo();
  }

  Widget criaItemLista(context, index) {
    final item = _listaTarefas[index]["titulo"];

    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _ultimaRemovida = _listaTarefas[index];

          _listaTarefas.removeAt(index);
          _salvarArquivo();
        });

        final snackbar = SnackBar(
          content: Text("Tarefa removida"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _listaTarefas.insert(index, _ultimaRemovida);
              });
              _salvarArquivo();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      },
      key: ValueKey(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete, color: Colors.white)],
        ),
      ),
      child: CheckboxListTile(
        title: Text(_listaTarefas[index]["titulo"]),
        value: _listaTarefas[index]["realizada"],
        onChanged: (valorAlterado) {
          if (valorAlterado == null) return;
          setState(() {
            _listaTarefas[index]["realizada"] = valorAlterado;
          });
          _salvarArquivo();
        },
      ),
    );
  }

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
                  controller: _controllerTarefa,
                  decoration: InputDecoration(labelText: "Digite sua tarefa"),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _salvarTarefa();
                      Navigator.pop(context);
                    },
                    child: Text("Adicionar"),
                  ),
                  TextButton(
                    child: Text("Cancelar"),
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
                itemBuilder: criaItemLista,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
