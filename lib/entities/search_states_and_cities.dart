import 'dart:convert';
import 'dart:io';
import 'package:acad_calculator/entities/brazilian_state.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<List<BrazilianState>> carregarEstadosECidades() async {
  final conectado = await Connectivity().checkConnectivity();
  final isOnline = conectado != ConnectivityResult.none;

  final file = await _getJsonFile();

  if (isOnline) {
    try {
      final estadosRes = await http.get(
        Uri.parse(
          'https://servicodados.ibge.gov.br/api/v1/localidades/estados',
        ),
      );

      final estadosJson = jsonDecode(estadosRes.body);
      final List<BrazilianState> estadosComCidades = [];

      for (final estado in estadosJson) {
        final uf = estado['sigla'];
        final nome = estado['nome'];

        final cidadesRes = await http.get(
          Uri.parse(
            'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/municipios',
          ),
        );
        final cidadesJson = jsonDecode(cidadesRes.body) as List;
        final cidades = cidadesJson.map((e) => e['nome'].toString()).toList();

        estadosComCidades.add(
          BrazilianState(acronym: uf, name: nome, cities: cidades),
        );
      }

      // Salva localmente
      final jsonString = jsonEncode(
        estadosComCidades.map((e) => e.toJson()).toList(),
      );
      await file.writeAsString(jsonString);

      return estadosComCidades;
    } catch (e) {
      print('Erro ao buscar do IBGE: $e');
      // Se der erro, usa o local
      return await _carregarLocal(file);
    }
  } else {
    return await _carregarLocal(file);
  }
}

Future<File> _getJsonFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/estados_cidades.json');
}

Future<List<BrazilianState>> _carregarLocal(File file) async {
  if (await file.exists()) {
    final jsonStr = await file.readAsString();
    final jsonList = jsonDecode(jsonStr) as List;
    return jsonList.map((e) => BrazilianState.fromJson(e)).toList();
  }
  return []; // Retorna vazio se não tiver nada salvo ainda
}
