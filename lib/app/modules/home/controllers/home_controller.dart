import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<Map<String, dynamic>> allPlayers = [
    {"name": "Vaikom", "country": "26"},
    {"name": "Pala", "country": "20"},
    {"name": "Erattupetta", "country": "10"},
    {"name": "Thodupuzha", "country": "25"},
    {"name": "Thiruvalla", "country": "30"},
    {"name": "Kanjirappally", "country": "10"},
    {"name": "Ettumanoor", "country": "10"},
    {"name": "kottayam", "country": "21"},
  ];
  Rx<List<Map<String, dynamic>>> foundPlayers =
      Rx<List<Map<String, dynamic>>>([]);

  @override
  void onInit() {
    super.onInit();
    foundPlayers.value = allPlayers;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void filterPlayer(String playerName) {
    List<Map<String, dynamic>> results = [];
    if (playerName.isEmpty) {
      results = allPlayers;
    } else {
      results = allPlayers
          .where((element) => element["name"]
              .toString()
              .toLowerCase()
              .contains(playerName.toLowerCase()))
          .toList();
    }
    foundPlayers.value = results;
  }
}
