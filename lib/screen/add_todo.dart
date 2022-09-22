
import 'package:flutter/material.dart';
import 'package:todo_app_202209/service/todo_service.dart';
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
    //submit updated data to the server
    var isSuccess = await TodoService.updateTodo(id, body);
    //show success or fail based on status
    if (isSuccess) {
      showSuccessMessage(context, message: 'updating success');
    } else {
      showErrorMessage(context, message: 'updating fail');
    }
  }

  Future<void> submitData() async {
    //submit data to the server
    var isSuccess = await TodoService.addTodo(body);

    //show success or fail based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'creation success');
    } else {
      showErrorMessage(context, message: 'creation fail');
    }
  }

  Map get body{
    //get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
  }
}
