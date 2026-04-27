import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'features/project_history/controllers/history_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();
  await apiClient.testHealth();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthController())],
      child: MaterialApp(
        title: 'API Data Display',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 240, 245, 247),
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Platforms List'),
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    _historyController.fetchPlatforms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  const Color.fromARGB(255, 217, 0, 255),
                  const Color.fromARGB(255, 74, 16, 99),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 40,
              ),
            ),
            onSelected: (value) {
              if (value == 'login') {
                Navigator.of(context).pushNamed(AppRoutes.login);
              } else if (value == 'register') {
                Navigator.of(context).pushNamed(AppRoutes.register);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'login',
                child: Row(
                  children: [
                    Icon(Icons.login, size: 20),
                    SizedBox(width: 8),
                    Text('Đăng Nhập'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'register',
                child: Row(
                  children: [
                    Icon(Icons.app_registration, size: 20),
                    SizedBox(width: 8),
                    Text('Đăng Ký'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _historyController,
        builder: (context, child) {
          if (_historyController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_historyController.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _historyController.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (_historyController.platforms.isEmpty) {
            return const Center(child: Text('Không có dữ liệu.'));
          }

          return ListView.builder(
            itemCount: _historyController.platforms.length,
            itemBuilder: (context, index) {
              final platform = _historyController.platforms[index];

              // Trích xuất tên hoặc hiển thị trực tiếp nếu cấu trúc khác
              String name = 'Không có tên';
              String description = '';

              if (platform is Map) {
                name =
                    platform['name']?.toString() ??
                    platform['title']?.toString() ??
                    platform['id']?.toString() ??
                    'Không có tên';
                // Lấy tất cả các keys còn lại để hiển thị dưới dạng subtitle
                final otherData = Map.from(platform)
                  ..remove('name')
                  ..remove('title')
                  ..remove('id');
                if (otherData.isNotEmpty) {
                  description = otherData.entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join(', ');
                }
              } else {
                name = platform.toString();
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.api)),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: description.isNotEmpty
                      ? Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _historyController.fetchPlatforms();
        },
        tooltip: 'Làm mới',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
