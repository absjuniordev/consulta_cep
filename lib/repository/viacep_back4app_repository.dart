import 'package:viacep/model/viacep_back4app_model.dart';
import 'package:viacep/repository/back4app_custom_dio.dart';

class ViaCEPBack4AppRepository {
  final _customDio = Back4AppCustomDio();

  ViaCEPBack4AppRepository();

  var url = "/CEPModel";
  Future<ViaCEPBack4AppModel> getCEP() async {
    var result = await _customDio.dio.get(url);
    return ViaCEPBack4AppModel.fromJson(result.data);
  }

  Future<void> postCEP(ViaCEPBack4 viaCEPBack4) async {
    try {
      await _customDio.dio.post(url, data: viaCEPBack4.toJsonEndPoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCEP(String objectId) async {
    try {
      await _customDio.dio.delete("$url/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}
