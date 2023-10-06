class ViaCEPBack4AppModel {
  List<ViaCEPBack4> cep = [];

  ViaCEPBack4AppModel(this.cep);

  ViaCEPBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      cep = <ViaCEPBack4>[];
      json['results'].forEach((v) {
        cep.add(ViaCEPBack4.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['results'] = cep.map((v) => v.toJson()).toList();

    return data;
  }
}

class ViaCEPBack4 {
  String objectId = "";
  String cep = "";
  String logradouro = "";
  String complemento = "";
  String bairro = "";
  String localidade = "";
  String uf = "";
  String ibge = "";
  String ddd = "";
  String createdAt = "";
  String updatedAt = "";

  ViaCEPBack4(
      this.objectId,
      this.cep,
      this.logradouro,
      this.complemento,
      this.bairro,
      this.localidade,
      this.uf,
      this.ibge,
      this.ddd,
      this.createdAt,
      this.updatedAt);

  ViaCEPBack4.criar(
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.ibge,
    this.ddd,
  );

  ViaCEPBack4.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    cep = json['cep'];
    logradouro = json['logradouro'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    localidade = json['localidade'];
    uf = json['uf'];
    ibge = json['ibge'];
    ddd = json['ddd'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    data['ibge'] = ibge;
    data['ddd'] = ddd;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonEndPoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cep'] = cep;
    data['logradouro'] = logradouro;
    data['complemento'] = complemento;
    data['bairro'] = bairro;
    data['localidade'] = localidade;
    data['uf'] = uf;
    data['ibge'] = ibge;
    data['ddd'] = ddd;

    return data;
  }
}
