import 'package:flutter/material.dart';

import '../data/strain_model.dart';
import '../data/get_strains.dart';
import '../screens/strain_details.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<DataStrains>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DataStrains> data = snapshot.data!;
          final List<DataStrains> suggestionList = query.isEmpty
              ? data
              : data
                  .where((d) =>
                      d.strain.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          return ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsStrain(data: suggestionList[index]),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(suggestionList[index].strain),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
