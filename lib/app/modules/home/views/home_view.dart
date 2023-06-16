import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.blue.shade200,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (value) => controller.filterPlayer(value),
                decoration: const InputDecoration(
                  labelText: 'Search your destination',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.foundPlayers.value.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(
                        controller.foundPlayers.value[index]['name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle:
                          Text(controller.foundPlayers.value[index]['country']),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
