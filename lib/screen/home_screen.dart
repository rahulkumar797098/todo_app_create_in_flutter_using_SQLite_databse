import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_sql/colors.dart';
import 'package:todo_sql/database/database_handler.dart';
import 'package:todo_sql/database/notes_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var todoMessageController = TextEditingController();
  late Future<List<TodoModel>> todoList;

  DatabaseHandler? databaseHandler;


  @override
  void initState() {
    super.initState();
    databaseHandler = DatabaseHandler();
    todoList = Future.value([]);
    loadData();
  }
// here we create loadData function //
  Future<void> loadData() async {
    setState(() {
      todoList = databaseHandler!.getTodoList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //..................  APP BAR ......................//
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.menu, size: 40, color: appTitle),
            const Text(
              "TODO NOTES",
              style: TextStyle(fontSize: 30, color: appTitle, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 50,
              width: 50,
              child: Image.asset("assets/images/todo.png"),
            ),
          ],
        ),
        backgroundColor: appBarBackground,
        centerTitle: true,
      ),
      backgroundColor: appBackground,

      //...................BODY ...........................//
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 20,),

              Expanded(
                child: FutureBuilder<List<TodoModel>>(
                  future: todoList,
                  builder: (context, snapshot) {
                    //...... WHEN DATA IS LOADED THEN THAT TIME SHOW INDICATOR ...//
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          "No Todo Found",
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: appRed),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8 , right: 8 , left: 8 ),
                            //.......InkWell use for apply on tap method apply on any widgets ....//
                            child: InkWell(

                              // ..... Here we apply update todo list  .. // here we show dialog box
                                onTap: () {
                                  // todo old message
                                  String oldTodoMessage = snapshot.data![index].todoMessage ;
                                  // .......... DIALOG.........//
                                  showDialog(context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: appBackground,
                                        title: Text("Update Todo" , style: TextStyle(fontSize: 20 ,
                                            fontWeight: FontWeight.bold ,
                                            color: appTitle),),
                                        content: TextField(
                                          controller: TextEditingController(text: oldTodoMessage),
                                          onChanged: (value){
                                            // here we update message
                                            todoMessageController.text = value ;
                                          },
                                        ),

                                        actions: [
                                          // Cancel Button when click on cancel button pop and go to Home screen
                                          //................CANCEL BUTTON ........................//
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10) ,
                                          border: Border.all(width: 2 , color: appRed)
                                        )

                                            ,child: TextButton(onPressed: ()=> Navigator.pop(context),
                                                child: Text("Cancel" , style: TextStyle(fontSize: 16 ,
                                                    fontWeight: FontWeight.bold ,
                                                    color: appRed),)),
                                          ) ,

                                          //.......... Update Button ..........///
                                          Container(
                                          decoration: BoxDecoration(
                                            color: Colors.greenAccent ,
                                            borderRadius: BorderRadius.circular(10)
                                          )

                                            ,child: TextButton(onPressed: () async {
                                              if(todoMessageController.text != oldTodoMessage){
                                                await databaseHandler!.update(TodoModel(id: snapshot.data![index].id,
                                                    todoMessage: todoMessageController.text));

                                                todoMessageController.clear();

                                                // after that load database
                                                loadData();
                                              }
                                              // after that pop to the home screen
                                              Navigator.pop(context);

                                            }, child: Text("Update" , style: TextStyle(fontSize: 16 ,
                                              fontWeight: FontWeight.bold,
                                              color: appTitle
                                          ),
                                            ) ,
                                            ),
                                          )
                                        ],
                                      ));
                                },
                              child: Card(
                                child: ListTile(
                                  //....... DATA IS SHOW IN LIST .....//....TEXT ...//
                                  title: Text(snapshot.data![index].todoMessage ,
                                    style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),

                                  // ..............delete button ..............//
                                  trailing: Container(
                                    height: 35,
                                    width: 35,
                                    alignment: Alignment.center ,
                                    decoration: BoxDecoration(
                                      color: Colors.red ,
                                      borderRadius: BorderRadius.circular(5) ,
                                    ),

                                    // Delete button
                                    child: IconButton(
                                      // here we apply delete function
                                      onPressed : () async {
                                        await databaseHandler!.delete(snapshot.data![index].id!) ;
                                        // after deleting reload the data
                                        loadData();
                                      } ,
                                      color: Colors.white,
                                      alignment: Alignment.center,
                                      iconSize: 20,
                                      icon: Icon(Icons.delete) ,
                                      splashColor: appRed,

                                    ),
                                  ),

                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 100,)
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              //...................... ROW ..................//
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: appWhite,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(width: 2, color: appTitle),
                        boxShadow: [BoxShadow(color: appRed, blurRadius: 10)],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),

                        // .................. TODO MESSAGE TEXT FIELD ................//
                        child: TextField(
                          controller: todoMessageController,
                          decoration: InputDecoration(
                            hintText: "Add New Todo Item!",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ...................... FLOATING ACTION BUTTON .................//
                  FloatingActionButton(
                    onPressed: () async {
                     databaseHandler!.insert(TodoModel(
                         todoMessage: todoMessageController.text));
                        todoMessageController.clear();
                        loadData();      // HERE WE CALL FUNCTION LOADDATA()
                      },
                    elevation: 15,
                    child: Icon(
                      Icons.add,
                      size: 50,
                      color: appWhite,
                      shadows: [Shadow(color: Colors.black54,
                          blurRadius: 20,
                          offset: Offset(2.0, 2.0))],
                    ),
                    backgroundColor: appRed,
                    splashColor: appBackground,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 1... DATA INSERT => DONE
// 2.... DATA VIEW   => DONE
// 3.... DATA DELETE => DONE
// 4..... DATA UPDATE => DONE
// 5 ..... DESIGN THE DIALOG BOX =>  DONE
// 6...... SPLASH SCREEN => DONE
// 7 ...... APP ICON CHANGE => NOW
// => FIRST WE SET ICON ON ANDROID DEVICE => DONE
// => NOW WE SET ICON ON MACK OIS DEVICE => DONE
// IF YOU HAVE IPHONE THAN RESTART THE APP ,
// NOW EVERT THIHG IS DONE NOW FINAL CHECK THE APP ,

// BEFORE UPDATE THE LIST SOLVE SOME PROBLEM





// PROBLEM IS SOLVE