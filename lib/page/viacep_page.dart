import 'package:flutter/material.dart';
import 'package:viacep/model/viacep_model.dart';
import 'package:viacep/repository/viacep_back4app_repository.dart';
import 'package:viacep/repository/viacep_repository.dart';
import '../model/viacep_back4app_model.dart';

class ViaCEPPage extends StatefulWidget {
  const ViaCEPPage({super.key});

  @override
  State<ViaCEPPage> createState() => _ViaCEPPageState();
}

class _ViaCEPPageState extends State<ViaCEPPage> {
  var _viaCEPBack4AppModel = ViaCEPBack4AppModel([]);
  var cepRepository = ViaCEPBack4AppRepository();
  var _viaCEPModel = ViaCEPModel();
  var viaCEPRepository = ViaCEPRepository();
  var cepController = TextEditingController(text: "");
  var loading = false;

  @override
  void initState() {
    super.initState();
    obterCEPS();
  }

  obterCEPS() async {
    _viaCEPBack4AppModel = await cepRepository.getCEP();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    color: Colors.amber,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      width: 200,
                      child: const Text(
                        "Buscar CEP",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    decoration: const InputDecoration(
                      error: AlertDialog(),
                      label: Text("CEP"),
                      hintText: "44.000-000",
                    ),
                    controller: cepController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    onChanged: (value) async {
                      if (value.length == 8) {
                        setState(() {
                          loading = true;
                        });
                        var result = value;
                        _viaCEPModel =
                            await viaCEPRepository.consultarCEP(result);

                        if (_viaCEPModel.logradouro == null) {
                          cepController.text = "";
                          setState(() {
                            loading = false;
                          });
                          return;
                        }

                        await cepRepository.postCEP(
                          ViaCEPBack4.criar(
                              _viaCEPModel.cep ?? "",
                              _viaCEPModel.logradouro ?? "",
                              _viaCEPModel.complemento ?? "",
                              _viaCEPModel.bairro ?? "",
                              _viaCEPModel.localidade ?? "",
                              _viaCEPModel.uf ?? "",
                              _viaCEPModel.ibge ?? "",
                              _viaCEPModel.ddd ?? ""),
                        );
                        cepController.text = "";
                      }
                      setState(() {
                        loading = false;
                      });
                      obterCEPS();
                    },
                  ),
                  Visibility(
                      visible: loading,
                      child: const CircularProgressIndicator()),
                ],
              ),
            ),
            const SizedBox(height: 35),
            Container(
              height: MediaQuery.of(context).size.height / 1.45,
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 15,
                left: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "Endereço",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _viaCEPBack4AppModel.cep.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var cep = _viaCEPBack4AppModel.cep[index];
                        debugPrint(_viaCEPBack4AppModel.cep.length.toString());
                        return Dismissible(
                          onDismissed:
                              (DismissDirection dismissDirectionon) async {
                            await cepRepository.deleteCEP(cep.objectId);
                          },
                          key: Key(cep.cep.toString()),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 30),
                              child: Column(
                                children: [
                                  Text("Rua: ${cep.logradouro}"),
                                  Text("Bairro: ${cep.bairro}"),
                                  Text("Cidade: ${cep.localidade}"),
                                  Text("Estado: ${cep.uf}"),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.amber,
    ));
  }
}
