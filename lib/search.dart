import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> stops = [];
  List<String> filteredStops = [];
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
  Map<String, int> availableSeats = {};

  @override
  void initState() {
    super.initState();
    _fetchBusStops();
  }

  Future<void> _fetchBusStops() async {
    final QuerySnapshot snapshot = await _firestore.collection('buses').get();

    final Set<String> allStops = Set<String>();
    final Map<String, int> seatsCount = {};

    for (final QueryDocumentSnapshot doc in snapshot.docs) {
      final List<dynamic> stopsList = doc['stops'];
      final int? availableSeatsCount = doc['seatsAvailable'] as int?;

      for (final stop in stopsList) {
        final String stopName = stop.toString();
        allStops.add(stopName);

        if (availableSeatsCount != null) {
          seatsCount[stopName] =
              (seatsCount[stopName] ?? 0) + availableSeatsCount;
        }
      }
    }

    setState(() {
      stops = allStops.toList();
      filteredStops = stops;
      availableSeats = seatsCount;
    });
  }

  void filterStops(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredStops = stops
            .where((stop) => stop.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
      } else {
        filteredStops = stops;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade200,
              Colors.purple.shade50,
            ],
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AutoCompleteTextField<String>(
                key: key,
                clearOnSubmit: false,
                suggestions: filteredStops,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                itemFilter: (item, query) =>
                    item.toLowerCase().startsWith(query.toLowerCase()),
                itemSorter: (a, b) => a.compareTo(b),
                itemSubmitted: (item) {
                  setState(() {
                    key.currentState?.textField?.controller?.text = item;
                  });
                },
                itemBuilder: (context, item) => ListTile(
                  title: Text(item),
                  subtitle:
                      Text('Available Seats: ${availableSeats[item] ?? 0}'),
                  onTap: () {
                    setState(() {
                      key.currentState?.textField?.controller?.text = item;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStops.length,
                itemBuilder: (context, index) {
                  final stop = filteredStops[index];
                  return ListTile(
                    title: Text(stop),
                    subtitle:
                        Text('Available Seats: ${availableSeats[stop] ?? 0}'),
                    onTap: () {
                      // Perform action when item is tapped
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
