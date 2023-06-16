import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TextEditingController> stopControllers = [];
  TextEditingController _stopTextController = TextEditingController();

  @override
  void dispose() {
    for (var controller in stopControllers) {
      controller.dispose();
    }
    _stopTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = false;
    return SafeArea(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue,
                      Colors.purple.shade50,
                    ],
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 130),
                      const Text(
                        'Updations',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black87,
                              offset: Offset(-2.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      FlutterSwitch(
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        value: isButtonEnabled,
                        onToggle: (value) {
                          setState(() {
                            isButtonEnabled = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _showAddBusDialog();
                            },
                            child: Image.asset(
                              'assets/images/addbus.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/susbus.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              _showModifyBusDetailsDialog();
                            },
                            child: Image.asset(
                              'assets/images/editbus.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {
                              _showBusFareUpdationDialog();
                            },
                            child: Image.asset(
                              'assets/images/BusfareUpdation.png',
                              width: 130,
                              height: 130,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          //bottomNavigationBar : MyBottomNavigationBar(),
        ),
      ),
    );
  }

  void _showAddBusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String busNumber = '';
        String vehicleNumber = '';
        int seatsAvailable = 0;
        String destination = '';
        String route = '';
        List<String> stops = [];

        void _addStop() {
          String stopToAdd = _stopTextController.text.trim();
          if (stopToAdd.isNotEmpty) {
            setState(() {
              stops.add(stopToAdd);
              _stopTextController.clear();
            });
          }
        }

        void _removeStop(int index) {
          setState(() {
            stops.removeAt(index);
          });
        }

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Bus'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        busNumber = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Bus Number'),
                    ),
                    TextField(
                      onChanged: (value) {
                        vehicleNumber = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Vehicle Number'),
                    ),
                    TextField(
                      onChanged: (value) {
                        seatsAvailable = int.tryParse(value) ?? 0;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Seats Available'),
                    ),
                    TextField(
                      onChanged: (value) {
                        destination = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Destination'),
                    ),
                    TextField(
                      onChanged: (value) {
                        route = value;
                      },
                      decoration: const InputDecoration(labelText: 'Route'),
                    ),
                    const SizedBox(height: 10),
                    Text('Stops:'),
                    Column(
                      children: [
                        for (int i = 0; i < stops.length; i++)
                          Row(
                            children: [
                              Expanded(
                                child: Text(stops[i]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeStop(i);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _stopTextController,
                            decoration:
                                const InputDecoration(labelText: 'Add Stop'),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Store bus details into Firestore
                    _firestore.collection('buses').add({
                      'busNumber': busNumber,
                      'vehicleNumber': vehicleNumber,
                      'seatsAvailable': seatsAvailable,
                      'destination': destination,
                      'route': route,
                      'stops': stops,
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showBusFareUpdationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<QuerySnapshot>(
          future: _firestore.collection('buses').get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No buses found.');
            } else {
              List<QueryDocumentSnapshot> buses = snapshot.data!.docs;
              return AlertDialog(
                title: const Text('Edit Bus Fares'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var bus in buses)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Bus Number: ${bus['busNumber'] ?? ''}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            for (var stop in bus['stops'])
                              Row(
                                key: ValueKey('$bus-$stop'),
                                children: [
                                  Expanded(child: Text(stop)),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final busId = bus.id;
                                      final fare =
                                          await _showFareDialog(busId, stop);
                                      if (fare != null) {
                                        // Update fare in Firestore
                                        _firestore
                                            .collection('buses')
                                            .doc(busId)
                                            .update({
                                          'fares.$stop': fare,
                                        });
                                      }
                                    },
                                    child: const Text('Edit Fare'),
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
                    },
                    child: const Text('Done'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Future<double?> _showFareDialog(String busId, String stop) {
    TextEditingController fareController = TextEditingController();

    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Fare'),
          content: TextField(
            controller: fareController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Fare'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final fare = double.tryParse(fareController.text);
                Navigator.of(context).pop(fare);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showModifyBusDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<QuerySnapshot>(
          future: _firestore.collection('buses').get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No buses found.');
            } else {
              List<QueryDocumentSnapshot> buses = snapshot.data!.docs;

              return AlertDialog(
                title: const Text('Modify Bus Details'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var bus in buses)
                        ListTile(
                          title: Text('Bus Number: ${bus['busNumber']}'),
                          subtitle:
                              Text('Vehicle Number: ${bus['vehicleNumber']}'),
                          onTap: () {
                            _showEditBusDialog(bus);
                          },
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _showEditBusDialog(QueryDocumentSnapshot bus) {
    showDialog(
      context: context,
      builder: (context) {
        String busNumber = bus['busNumber'];
        String vehicleNumber = bus['vehicleNumber'];
        int seatsAvailable = bus['seatsAvailable'];
        String destination = bus['destination'];
        String route = bus['route'];
        List<String> stops = List<String>.from(bus['stops']);

        void _addStop() {
          String stopToAdd = _stopTextController.text.trim();
          if (stopToAdd.isNotEmpty) {
            setState(() {
              stops.add(stopToAdd);
              _stopTextController.clear();
            });
          }
        }

        void _removeStop(int index) {
          setState(() {
            stops.removeAt(index);
          });
        }

        TextEditingController busNumberController =
            TextEditingController(text: busNumber);
        TextEditingController vehicleNumberController =
            TextEditingController(text: vehicleNumber);
        TextEditingController seatsAvailableController =
            TextEditingController(text: seatsAvailable.toString());
        TextEditingController destinationController =
            TextEditingController(text: destination);
        TextEditingController routeController =
            TextEditingController(text: route);

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Bus Details'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: busNumberController,
                      onChanged: (value) {
                        busNumber = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Bus Number'),
                    ),
                    TextField(
                      controller: vehicleNumberController,
                      onChanged: (value) {
                        vehicleNumber = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Vehicle Number'),
                    ),
                    TextField(
                      controller: seatsAvailableController,
                      onChanged: (value) {
                        seatsAvailable = int.tryParse(value) ?? 0;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Seats Available'),
                    ),
                    TextField(
                      controller: destinationController,
                      onChanged: (value) {
                        destination = value;
                      },
                      decoration:
                          const InputDecoration(labelText: 'Destination'),
                    ),
                    TextField(
                      controller: routeController,
                      onChanged: (value) {
                        route = value;
                      },
                      decoration: const InputDecoration(labelText: 'Route'),
                    ),
                    const SizedBox(height: 10),
                    Text('Stops:'),
                    Column(
                      children: [
                        for (int i = 0; i < stops.length; i++)
                          Row(
                            children: [
                              Expanded(
                                child: Text(stops[i]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _removeStop(i);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _stopTextController,
                            decoration:
                                const InputDecoration(labelText: 'Add Stop'),
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Update bus details in Firestore
                    _firestore.collection('buses').doc(bus.id).update({
                      'busNumber': busNumber,
                      'vehicleNumber': vehicleNumber,
                      'seatsAvailable': seatsAvailable,
                      'destination': destination,
                      'route': route,
                      'stops': stops,
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
