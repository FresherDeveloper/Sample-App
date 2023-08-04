import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/models/data_model.dart';
import 'package:sample_app/provider/app_provider.dart';

class PostScreen extends StatelessWidget {
  final DataModel newPost;
  // Add a constructor to receive the new post from the HomePage
  const PostScreen({super.key, required this.newPost});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<AuthProvider>(
      context,
    );
    List<DataModel> responseData = dataProvider.dataList;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Post"),
        ),
        body: // Show the newly created post along with the existing posts
            ListView.builder(
                itemCount: responseData.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Display the newly created post at the top
                    return ListTile(
                      title: Text(newPost.title),
                      subtitle: Text(newPost.body),
                      onTap: () {
                        // ... ( navigate to the detail page)
                      },
                    );
                  } else {
                    return ListTile(
                      title: Column(
                        children: [
                          Text(responseData[index].id.toString()),
                          Text(responseData[index].title),
                        ],
                      ),
                      subtitle: Text(responseData[index].body),
                      onTap: () {},
                    );
                  }
                }));
  }
}
