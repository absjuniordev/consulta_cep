import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    elevation: 30,
                    color: const Color.fromARGB(0, 255, 193, 7),
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
                    canRequestFocus:
                        cepController.text.length == 8 ? false : true,
                    decoration: const InputDecoration(
                      label: Text("CEP"),
                      hintText: "44.000-000",
                    ),
                    controller: cepController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
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
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: (context),
                            builder: (BuildContext bc) {
                              return AlertDialog(
                                backgroundColor: Colors.red,
                                title: const Text("CEP INVALIDO"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Sair",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }
                        for (var element in _viaCEPBack4AppModel.cep) {
                          if (element.cep == _viaCEPModel.cep) {
                            cepController.text = "";
                            setState(() {
                              loading = false;
                            });
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: (context),
                              builder: (BuildContext bc) {
                                return AlertDialog(
                                  backgroundColor: Colors.green,
                                  title: const Text("CEP JA CADASTRADO"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Sair",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
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
                    "Lista de Endereço",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
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
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: (context),
                                builder: (BuildContext bc) {
                                  return AlertDialog(
                                    backgroundColor:
                                        const Color.fromARGB(204, 255, 193, 7),
                                    title: const Text(
                                        "Informações Complementares"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "CEP: ${cep.cep}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Logradouro: ${cep.logradouro}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Bairro: ${cep.bairro}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Cidade: ${cep.localidade}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "Estado: ${cep.uf}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "População: ${cep.ibge}",
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Sair",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            focusColor: Colors.amber,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("CEP: ${cep.cep}"),
                                    Text("Logradouro: ${cep.logradouro}"),
                                    Text("Bairro: ${cep.bairro}"),
                                    Text("Cidade: ${cep.localidade}"),
                                  ],
                                ),
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
