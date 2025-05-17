import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todos/model/model.dart';

// class Homepage extends StatefulWidget {
//   @override
//   State<Homepage> createState() => _homePageState();
// }
//
// class _homePageState extends State<Homepage> {
//   Future<TodoDataModel> getTodosViaAPI() async {
//     String baseUri = "https://dummyjson.com/todos";
//     var response = await http.get(Uri.parse(baseUri));
//     Map<String, dynamic> mdata = jsonDecode(response.body);
//     // print(mdata);
//     var fromjson = await TodoDataModel.fromJson(mdata);
//     // print("wwwwwww:${fromjson}");
//     return fromjson;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Todo Via Api")),
//       body: FutureBuilder(
//         future: getTodosViaAPI(),
//         builder: (contex, snap) {
//           if (snap.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snap.hasError) {
//             return Center(child: Text("${snap.error}"));
//           }
//           if (snap.hasData) {
//             return ListView.builder(
//               itemCount: snap.data!.todos.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                     snap.data!.todos[index].todo,
//                     style: TextStyle(
//                       decoration:
//                           snap.data!.todos[index].completed
//                               ? TextDecoration.lineThrough
//                               : TextDecoration.none,
//                     ),
//                   ),
//                   subtitle: Text("User ID: ${snap.data!.todos[index].userId}"),
//                   trailing: Checkbox(
//                     value: snap.data!.todos[index].completed,
//                     onChanged: (value) {
//                       setState(() {
//                         value = !snap.data!.todos[index].completed;
//                       });
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {

  Future<TodoDataModel> getTodosViaAPI() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/todos"));
    if (response.statusCode == 200) {
      return TodoDataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Todo List", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: getTodosViaAPI(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    "Failed to load todos",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.deepPurple,
                    ),
                    child: Text("Retry",style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            );
          }
          if (snapshot.hasData) {
            return RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () async => setState(() {}),
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: snapshot.data!.todos.length,
                itemBuilder: (context, index) {
                  final todo = snapshot.data!.todos[index];
                  return Card(
                    shadowColor: Colors.grey.shade300,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Checkbox(
                            value: todo.completed,
                            onChanged: (value) => setState(() {
                              todo.completed = value!;
                            }),
                            activeColor: Colors.deepPurple,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todo.todo,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: todo.completed
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: todo.completed
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "User ID: ${todo.userId}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.grey),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}