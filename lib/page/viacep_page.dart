import 'dart:async';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viacep/model/viacep_model.dart';
import 'package:viacep/repository/viacep_back4app_repository.dart';
import 'package:viacep/repository/viacep_repository.dart';
import 'package:viacep/utils/datalhes_pop.dart';
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
  var delete = false;

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
                          "Via CEP",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      // canRequestFocus:
                      //     cepController.text.length == 8 ? false : true,
                      decoration: const InputDecoration(
                        label: Text("CEP"),
                        hintText: "44.000-000",
                      ),
                      controller: cepController,
                      // maxLength: 8,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        CepInputFormatter(),
                      ],
                      onChanged: (value) async {
                        if (value.length == 10) {
                          String cep = cepController.text;
                          String numerosCep =
                              cep.replaceAll(RegExp(r'[^0-9]'), '');
                          setState(() {
                            loading = true;
                          });

                          if (loading == true) {
                            Timer(const Duration(seconds: 5), () {
                              showDialog(
                                  context: context,
                                  builder: (bd) => const AlertDialog(
                                        title:
                                            Text("Tempo de consulta excedido"),
                                      ));
                              cepController.text = "";
                              setState(() {
                                loading = false;
                              });
                            });
                          }

                          _viaCEPModel =
                              await viaCEPRepository.consultarCEP(numerosCep);

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
                      child: const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.4,
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _viaCEPBack4AppModel.cep.length,
                          itemBuilder: (BuildContext bc, int index) {
                            var cep = _viaCEPBack4AppModel.cep[index];
                            obterCEPS();
                            return Dismissible(
                              direction: DismissDirection.startToEnd,
                              confirmDismiss:
                                  (DismissDirection dismissDirectionon) async {
                                if (dismissDirectionon ==
                                    DismissDirection.startToEnd) {
                                  return showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Deseja realmente deletar ?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              await cepRepository
                                                  .deleteCEP(cep.objectId);
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                              setState(() {
                                                loading = false;
                                              });
                                            },
                                            child: const Text(
                                              "Sim",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                loading = false;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "Não",
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
                                }
                                return null;
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                color: Colors.red,
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                      ),
                                      Text(
                                        "Deletar",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              key: Key(cep.cep.toString()),
                              child: InkWell(
                                onTap: () async {
                                  await detalhesPop(context, item: [
                                    cep.cep,
                                    cep.logradouro,
                                    cep.bairro,
                                    cep.localidade,
                                    cep.uf,
                                    cep.ibge,
                                  ]);
                                },
                                focusColor: Colors.amber,
                                child: Card(
                                  color:
                                      const Color.fromARGB(155, 255, 214, 64),
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: SizedBox(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        width: 360,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "CEP: ${cep.cep}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Logradouro: ${cep.logradouro}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Bairro: ${cep.bairro}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Cidade: ${cep.localidade}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
