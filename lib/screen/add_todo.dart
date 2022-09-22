import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app_202209/utility/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    Key? key,
    this.todo, //optional
  }) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;

    super.initState();
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit == true ? "Edit Todo" : "Add Todo"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'description'),
            maxLines: 8,
            minLines: 3,
            // keyboardType: TextInputType.multiline,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you can't call update without todo data");
      return;
    }
    final id = todo['_id'];
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //submit updated data to the server
    var url = Uri.https('api.nstack.in', 'v1/todos/$id');
    var response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //show success or fail based on status
    if (response.statusCode == 200) {
      showSuccessMessage(context, message: 'updating success');
    } else {
      showErrorMessage(context, message: 'updating fail');
      print('Response body: ${response.body}');
    }
  }

  Future<void> submitData() async {
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    //submit data to the server
    var url = Uri.https('api.nstack.in', 'v1/todos');
    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    //show success or fail based on status

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'creation success');
    } else {
      showErrorMessage(context, message: 'creation fail');
      print('Response body: ${response.body}');
    }
  }
}
