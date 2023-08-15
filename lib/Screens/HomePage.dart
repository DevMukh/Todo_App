import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_app/Screens/Add_Todo_Pages.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchingdata();
    // here we can call the function
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 152, 147, 144),
        appBar: AppBar(
          title: const Text(
            'Todo List App Bar',
            style: TextStyle(
                color: Color.fromARGB(221, 208, 197, 197), fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.black87,
                ))
          ],
          backgroundColor: const Color.fromARGB(255, 42, 49, 53),
          centerTitle: true,
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 93, 86, 66),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 16, 17, 18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        radius: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'pkblinders',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  )),
              ListTile(
                title: const Text(
                  'Accounts details',
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                leading: const Icon(
                  Icons.account_box,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Authentications',
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                leading: const Icon(
                  Icons.verified,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                leading: const Icon(
                  Icons.privacy_tip,
                  size: 30,
                  color: Colors.black,
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const todo_addition()));
            },
            label: const Text('Add todo')),
        body: Visibility(
          visible: isloading,
          replacement: RefreshIndicator(
            onRefresh: fetchingdata,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  /*didplay get data from posted data on server
                  this item helps to store the list of items in item and we display using to store in item*/
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(31, 12, 11, 11),
                        child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (value) => {
                        if (value == 'edit')
                          {
                            // edit here
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        todo_addition(todo: item)))
                            // jojo store hn woh item todo ko do 
                          }
                        else if (value == 'delete')
                          {
                            // delete api call
                            deltebyId(id),
                          }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('delete'),
                          ),
                        ];
                      },
                    ),
                  );
                }),
          ),
          child: const Center(
              child: CircularProgressIndicator(
            backgroundColor: Color.fromARGB(255, 47, 47, 48),
          )),
        ));
  }

  Future<void> fetchingdata() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=18';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isloading = false;
    });
  }

  //now there s another fuction of delte api
  Future<void> deltebyId(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filter = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filter;
      });
    }
  }
}
