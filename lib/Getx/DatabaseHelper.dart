import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableTodo = 'todo';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDone = 'done';

class User {
  final int? id;
  final String email;
  final String password;

  User({this.id, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email}';
  }
}

List<Todo> sampleTodos = [
  Todo(
    id: 1,
    title: "Mua sắm thực phẩm",
    description: "Mua rau củ, trái cây và thịt.",
    createAt: DateTime.now(),
    done: false,
    dueDate: DateTime.now().add(Duration(days: 2)),
  ),
  Todo(
    id: 2,
    title: "Dắt chó đi dạo",
    description: "Đi dạo công viên với chú chó.",
    createAt: DateTime.now(),
    done: true,
    dueDate: DateTime.now().add(Duration(days: 1)),
  ),
  Todo(
    id: 3,
    title: "Đọc sách",
    description: "Đọc sách về lập trình Flutter.",
    createAt: DateTime.now(),
    done: false,
    dueDate: DateTime.now().add(Duration(days: 7)),
  ),
  Todo(
    id: 4,
    title: "Giặt quần áo",
    description: "Giặt sạch sẽ và phơi khô.",
    createAt: DateTime.now(),
    done: true,
    dueDate: DateTime.now().add(Duration(days: 3)),
  ),
  Todo(
    id: 5,
    title: "Nấu bữa tối",
    description: "Chuẩn bị bữa tối cho gia đình.",
    createAt: DateTime.now(),
    done: false,
    dueDate: DateTime.now().add(Duration(days: 1)),
  ),
];

class Todo {
  int? id;
  String title;
  String description;
  DateTime createAt;
  bool done;
  DateTime? dueDate;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.createAt,
    this.done = false,
    required this.dueDate,
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: title,
      'description': description,
      'createAt': createAt.toIso8601String(),
      columnDone: done ? 1 : 0,
      'dueDate': dueDate?.toIso8601String(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Todo.fromMap(Map<String, Object?> map)
      : id = map[columnId] as int?,
        title = map[columnTitle] as String,
        description = map['description'] as String,
        createAt = DateTime.parse(map['createAt'] as String),
        done = (map[columnDone] as int) == 1,
        dueDate = map['dueDate'] != null
            ? DateTime.parse(map['dueDate'] as String)
            : null;
}

class TodoProvider extends GetxController {
  late Database db;

  Future<void> open() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'db.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableTodo ( 
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
            $columnTitle TEXT NOT NULL, 
            description TEXT, 
            createAt TEXT NOT NULL,
            $columnDone INTEGER NOT NULL,
            dueDate TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertSampleUsers() async {
    await db.insert('users', {'email': 'nguyenvu1', 'password': '123456'});
    await db.insert('users', {'email': 'nguyenvu', 'password': '123456'});
    await db.insert('users', {'email': 'nguyenvu123', 'password': '123456'});
  }

  Future<bool> login(String email, String password) async {
    final List<Map<String, dynamic>> users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (users.isNotEmpty) {
      return true;
    }

    return false; // Trả về true nếu tìm thấy người dùng
  }

  Future<Todo?> insert(Todo todo) async {
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<Todo?> getTodo(int id) async {
    List<Map<String, dynamic>> maps = await db.query(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Todo>> listTodo() async {
    List<Map<String, dynamic>> maps = await db.query(tableTodo);

    return List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
  }

  Future<int> updateTodoStatus(int id, bool done) async {
    return await db.update(
      tableTodo,
      {columnDone: done ? 1 : 0}, // Cập nhật trạng thái đã hoàn thành
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTuDo(Todo todo, int id) async {
    return await db.update(
      tableTodo,
      todo.toMap(), // Convert Todo object to Map
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> addDataTodo() async {
    for (Todo todo in sampleTodos) {
      await insert(todo);
    }
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableTodo,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    await db.close();
  }
}
