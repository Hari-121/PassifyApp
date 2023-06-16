import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class Bus {
  final String busNumber;
  final String vehicleNumber;
  final int seatsAvailable;
  final String destination;
  final String route;
  final List<String> stops;

  Bus({
    required this.busNumber,
    required this.vehicleNumber,
    required this.seatsAvailable,
    required this.destination,
    required this.route,
    required this.stops,
  });

  Map<String, dynamic> toMap() {
    return {
      'busNumber': busNumber,
      'vehicleNumber': vehicleNumber,
      'seatsAvailable': seatsAvailable,
      'destination': destination,
      'route': route,
      'stops': stops,
    };
  }
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _busNumberController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _seatsAvailableController = TextEditingController();
  final _destinationController = TextEditingController();
  final _routeController = TextEditingController();
  final List<TextEditingController> stopControllers = [];
  final _stopTextController = TextEditingController();
  Bus? selectedBus;

  @override
  void dispose() {
    _busNumberController.dispose();
    _vehicleNumberController.dispose();
    _seatsAvailableController.dispose();
    _destinationController.dispose();
    _routeController.dispose();
    _stopTextController.dispose();
    super.dispose();
  }

  Future<void> addBusDetails() async {
    final String busNumber = _busNumberController.text.trim();
    final String vehicleNumber = _vehicleNumberController.text.trim();
    final int seatsAvailable =
        int.tryParse(_seatsAvailableController.text.trim()) ?? 0;
    final String destination = _destinationController.text.trim();
    final String route = _routeController.text.trim();

    final List<String> stops =
        stopControllers.map((controller) => controller.text.trim()).toList();

    final bus = Bus(
      busNumber: busNumber,
      vehicleNumber: vehicleNumber,
      seatsAvailable: seatsAvailable,
      destination: destination,
      route: route,
      stops: stops,
    );

    try {
      DocumentReference docRef =
          await _firestore.collection('buses').add(bus.toMap());

      // Update the stops in Firestore using the generated document ID
      for (String stop in bus.stops) {
        await docRef.collection('stops').add({
          'stopName': stop,
        });
      }

      _resetTextFields();
      // Show success message or perform any other action
    } catch (e) {
      // Handle error
    }
  }

  Future<List<Bus>> _fetchBuses() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('buses').get();

    final List<Bus> buses = snapshot.docs.map((doc) {
      final data = doc.data();
      return Bus(
        busNumber: data['busNumber'],
        vehicleNumber: data['vehicleNumber'],
        seatsAvailable: int.parse(data['seatsAvailable'].toString()),
        destination: data['destination'],
        route: data['route'],
        stops: List<String>.from(data['stops']),
      );
    }).toList();

    return buses;
  }

  void _resetTextFields() {
    _busNumberController.clear();
    _vehicleNumberController.clear();
    _seatsAvailableController.clear();
    _destinationController.clear();
    _routeController.clear();
    _stopTextController.clear();
    stopControllers.clear();
  }

  Widget _buildAddBusDialog() {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Add Bus Details'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(labelText: 'Vehicle Number'),
              ),
              TextField(
                controller: _seatsAvailableController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Seats Available'),
              ),
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
              ),
              TextField(
                controller: _routeController,
                decoration: const InputDecoration(labelText: 'Route'),
              ),
              const SizedBox(height: 16),
              Text(
                'Stops:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  for (int i = 0; i < stopControllers.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: Text(stopControllers[i].text),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeStop(i);
                          },
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _stopTextController,
                          decoration: const InputDecoration(
                            labelText: 'Stop',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addStop,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              addBusDetails();
            },
            child: const Text('Add'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetTextFields();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addStop() {
    setState(() {
      stopControllers
          .add(TextEditingController(text: _stopTextController.text));
      _stopTextController.clear();
    });
  }

  void _removeStop(int index) {
    setState(() {
      stopControllers.removeAt(index);
    });
  }

  void _showEditBusDialog(BuildContext context) async {
    final buses = await _fetchBuses();
    if (buses.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No Bus Details Found'),
          content: const Text('There are no bus details to edit.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => _buildEditBusDetailsDialog(buses),
      );
    }
  }

  Widget _buildEditBusDetailsDialog(List<Bus> buses) {
    return SingleChildScrollView(
      child: AlertDialog(
        title: const Text('Edit Bus Details'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<Bus>(
                value: selectedBus,
                onChanged: (value) {
                  setState(() {
                    selectedBus = value;
                    _busNumberController.text = value!.busNumber;
                    _vehicleNumberController.text = value.vehicleNumber;
                    _seatsAvailableController.text =
                        value.seatsAvailable.toString();
                    _destinationController.text = value.destination;
                    _routeController.text = value.route;
                    stopControllers.clear();
                    stopControllers.addAll(value.stops
                        .map((stop) => TextEditingController(text: stop)));
                  });
                },
                items: buses.map((bus) {
                  return DropdownMenuItem<Bus>(
                    value: bus,
                    child: Text(bus.busNumber),
                  );
                }).toList(),
              ),
              TextField(
                controller: _busNumberController,
                decoration: const InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(labelText: 'Vehicle Number'),
              ),
              TextField(
                controller: _seatsAvailableController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Seats Available'),
              ),
              TextField(
                controller: _destinationController,
                decoration: const InputDecoration(labelText: 'Destination'),
              ),
              TextField(
                controller: _routeController,
                decoration: const InputDecoration(labelText: 'Route'),
              ),
              const SizedBox(height: 16),
              Text(
                'Stops:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  for (int i = 0; i < stopControllers.length; i++)
                    Row(
                      children: [
                        Expanded(
                          child: Text(stopControllers[i].text),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _removeStop(i);
                          },
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _stopTextController,
                          decoration: const InputDecoration(
                            labelText: 'Stop',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addStop,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateBusDetails(selectedBus!);
              // Perform the necessary logic to update the bus details in Firestore
              // You can use the _busNumberController, _vehicleNumberController, _seatsAvailableController, etc., to access the edited values
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateBusDetails(Bus bus) async {
    final String busNumber = _busNumberController.text.trim();
    final String vehicleNumber = _vehicleNumberController.text.trim();
    final int seatsAvailable = int.parse(_seatsAvailableController.text.trim());
    final String destination = _destinationController.text.trim();
    final String route = _routeController.text.trim();

    final List<String> stops =
        stopControllers.map((controller) => controller.text.trim()).toList();

    final updatedBus = Bus(
      busNumber: busNumber,
      vehicleNumber: vehicleNumber,
      seatsAvailable: seatsAvailable,
      destination: destination,
      route: route,
      stops: stops,
    );

    try {
      await _firestore
          .collection('buses')
          .doc(bus.busNumber)
          .update(updatedBus.toMap());

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bus Details Updated'),
          content:
              const Text('The bus details have been successfully updated.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: addBusDetails,
              child: const Text('Add Bus Details'),
            ),
            ElevatedButton(
              onPressed: () => _showEditBusDialog(context),
              child: const Text('Edit Bus Details'),
            ),
          ],
        ),
      ),
    );
  }
}
