import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/models/data_model.dart';
import 'package:sample_app/provider/app_provider.dart';
import 'package:sample_app/screens/detail_page.dart';

import 'package:sample_app/screens/post_screen.dart';
import 'package:sample_app/services/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<AuthProvider>(context);

    Future<void> postData(
      String title,
      String body,
    ) async {
      if (title.isEmpty || body.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter all fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      try {
        Map<String, dynamic> data = {
          'title': title,
          'body': body,
          // 'id':id,
          // we can add more fields as per your API endpoint requirements
        };

        DataModel newPost = await ApiService().createPost(
          data: data,
        );

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PostScreen(
                      newPost: newPost,
                    )));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(data.toString())));
        
      } catch (e) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }

    Future<void> _showAddDialog() async {
      String title = '';
      String body = '';
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Add New Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => title = value,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                onChanged: (value) => body = value,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
              // TextField(
              //   onChanged: (value) => id =value.toString(),
              //   decoration: InputDecoration(labelText: 'id'),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                postData(
                  title,
                  body,
                );
              },
              child: const Text('Add'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        // actions: [
        //   BackButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut().then((value) {
        //         return Navigator.push(
        //             context, MaterialPageRoute(builder: (_) => LoginPage()));
        //       });
        //     },
        //   )
        // ],
      ),
      body: FutureBuilder(
        future: dataProvider.getData(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: dataProvider.dataList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataProvider.dataList[index].title),
                subtitle: Text(dataProvider.dataList[index].body),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            DetailPage(data: dataProvider.dataList[index])),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showAddDialog();
          _showAddDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
