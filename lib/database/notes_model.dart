class TodoModel {
  final int? id;
  final String todoMessage;

  TodoModel({this.id, required this.todoMessage});

  TodoModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        todoMessage = res["todomessage"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'todomessage': todoMessage,
    };
  }
}
