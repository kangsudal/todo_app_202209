
import 'package:flutter/material.dart';
import 'package:todo_app_202209/screen/add_todo.dart';
import 'package:todo_app_202209/service/todo_service.dart';
import 'package:todo_app_202209/utility/snackbar_helper.dart';
import 'package:todo_app_202209/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                      item: item,
                      index: index,
                      navigateToEditPage: navigateToEditPage,
                      deleteById: deleteById);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage();
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return AddTodoPage(
          todo: item,
        );
      },
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final result = await TodoService.fetchTodo();
    if (result != null) {
      setState(() {
        items = result;
      });
    } else {
      //error
      showErrorMessage(
        context,
        message: 'something went wrong',
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    //delete the item api??? ??? ??????????????? (status code??? 200??????)
    final isSuccess = await TodoService.deleteById(id);
    //remove item from the list
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage(context, message: 'Delete Failed');
    }
  }
}
