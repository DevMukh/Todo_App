import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/Screens/HomePage.dart';

class todo_addition extends StatefulWidget {
  final Map? todo;
  const todo_addition({super.key, this.todo});
  @override
  State<todo_addition> createState() => _todo_additionState();
}

class _todo_additionState extends State<todo_addition> {
  TextEditingController textcontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  bool isedit = false;
  @override
  void initState() {
    final todo = widget.todo;
    //getting values form previous widgets
    super.initState();
    if (todo != null) {
      // agr todo editing ka ley req kry aor es mae values hn to edit true kr ke agy bhejy ga
      isedit = true;
      final title = todo['title'];
      final description = todo['description'];
      textcontroller.text = title;
      descriptioncontroller.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 152, 147, 144),
      appBar: AppBar(
        title: Text(
          isedit ? 'Update' : ' Add Todo',
          style: const TextStyle(
              color: Color.fromARGB(221, 218, 214, 214), fontSize: 20),
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
      body: ListView(
        // scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          TextField(
              controller: textcontroller,
              decoration: const InputDecoration(
                hintText: 'Enter Some thing',
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.green)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2, color: Color.fromARGB(255, 50, 116, 126))),
              )),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptioncontroller,
            decoration: const InputDecoration(
              hintText: 'Enter description',
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.green)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 2, color: Color.fromARGB(255, 50, 116, 126))),
            ),
            minLines: 2,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              isedit ? await editdata() : await postdata(context);
            },
            child: Text(isedit ? 'update ' : 'Submit'),
          )
        ],
      ),
    );
  }

  Future<void> editdata() async {
    final todo = widget.todo;
    if (todo == null) {
      debugPrint('Please add some data first');
      return;
    }
    final id = todo['_id'];
    final title = textcontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      const snak = SnackBar(content: Text('You have successfully update data'));
      ScaffoldMessenger.of(context).showSnackBar(snak);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  // here we can add some functionality
  Future<void> postdata(BuildContext context) async {
// get data
    final title = textcontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

// post data
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    // statue received
    if (response.statusCode == 201) {
      debugPrint(response.body);
      debugPrint('${response.statusCode}');
      // print(response.body);
      // print(response.statusCode);
      textcontroller.text = "";
      descriptioncontroller.text = "";
      showSuccessMessage(context, 'Success response having a status code');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      showFailureMessage(context, 'Error response status code');
    }
  }

  // there we define a two function success and failure using snackbarr
  void showSuccessMessage(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void showFailureMessage(BuildContext context, String message) {
    final snackbars = SnackBar(
        content: Text(
      message,
      style: const TextStyle(color: Colors.red),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackbars);
  }
}
