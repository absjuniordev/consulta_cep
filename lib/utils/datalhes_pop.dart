import 'package:flutter/material.dart';

detalhesPop(BuildContext context, {required List item}) {
  showDialog(
    context: (context),
    builder: (bc) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(204, 255, 193, 7),
        title: const Text("Informações Complementares"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CEP: ${item[0]}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Logradouro: ${item[1]}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Bairro: ${item[2]}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Cidade: ${item[3]}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Estado: ${item[4]}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "População: ${item[5]}",
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
}
