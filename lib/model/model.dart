class TodoModel {
  bool completed;
  String todo;
  int id;
  int userId;

  TodoModel({
    required this.completed,
    required this.id,
    required this.todo,
    required this.userId,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      completed: json["completed"],
      id: json["id"],
      todo: json["todo"],
      userId: json["userId"],
    );
  }
}

class TodoDataModel {
  int limit;
  int skip;
  int total;
  List<TodoModel> todos;

  TodoDataModel({
    required this.limit,
    required this.skip,
    required this.total,
    required this.todos,
  });

  factory TodoDataModel.fromJson(Map<String, dynamic> json) {
    List<TodoModel> mTodo = [];
    for (Map<String, dynamic> eachtodo in json["todos"]) {
      TodoModel eachmodel = TodoModel.fromJson(eachtodo);
      mTodo.add(eachmodel);
    }
    return TodoDataModel(
      limit: json["limit"],
      skip: json["skip"],
      total: json["total"],
      todos: mTodo,
    );
  }
}
