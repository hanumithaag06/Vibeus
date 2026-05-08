import 'package:flutter/material.dart';
import 'services/youtube_service.dart';
import 'player_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/sync_service.dart';
import 'chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(VibeUsApp());
}

class VibeUsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "VibeUs",
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List songs = [];

  TextEditingController controller = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String lastSearch = "anirudh tamil songs";

  @override
  void initState() {
    super.initState();
    autoSuggest();
  }

  void autoSuggest() async {
    final result = await YouTubeService.searchSongs(lastSearch);

    setState(() {
      songs = result;
    });
  }

  void searchSongs() async {
    final result =
        await YouTubeService.searchSongs(controller.text + " tamil song");

    setState(() {
      songs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VibeUs 🎧"),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    roomId: roomController.text,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // ROOM ID
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: roomController,
              decoration: InputDecoration(
                hintText: "Enter Room ID",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // USERNAME
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Enter Username",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // SEARCH BAR
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search your vibe 🎧",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => searchSongs(),
            ),
          ),

          // SONG LIST
          Expanded(
            child: songs.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      final title = song['snippet']['title'];

                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Image.network(
                            song['snippet']['thumbnails']['medium']['url'],
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle:
                              Text(song['snippet']['channelTitle']),
                          trailing: Icon(Icons.play_circle_fill,
                              color: Colors.red),
                          onTap: () {
                            final videoId =
                                song['id']['videoId'];
                            final roomId = roomController.text;

                            SyncService.playSong(roomId, videoId);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerScreen(
                                  videoId: videoId,
                                  roomId: roomId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}