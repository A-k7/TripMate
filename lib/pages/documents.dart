// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class MyDocuments extends StatefulWidget {
//   const MyDocuments({super.key});

//   @override
//   State<MyDocuments> createState() => _MyDocumentsState();
// }
// // 1-------------------------------------------------------------------
// class _MyDocumentsState extends State<MyDocuments> {
//   var _isLoading = true;
//   @override

//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _loaditems();
//   }

//   // void _loaditems()async{
//   //   final List<FileObject> _loadedDocs = await
//   // Supabase.instance.client.storage
//   // .from('uploads2')
//   // .list();

//   // }

//   void _loaditems() async {

//   final List<FileObject> _loadedDocs = await
//   Supabase.instance.client.storage
//   .from('uploads2')
//   .list();

//     final List<FileObject> loadedItems = [];
//     for (final item in _loadedDocs) {

//       loadedItems.add(FileObject(
//         name: item.name,
//         bucketId: item.bucketId,
//         id: item.id,
//         buckets: item.buckets,
//         createdAt: item.createdAt,
//         lastAccessedAt: item.lastAccessedAt,
//         metadata: item.metadata,
//         owner: item.owner,
//         updatedAt: item.updatedAt));
//     }
//     return;
//   }

//   // 2 --------------------------------------------------------------------------------------
//   Widget build(BuildContext context) {

//     Widget content = const Center(
//       child: Text('No items added yet'),
//     );

//         if (_loadedDocs.isNotEmpty) {
//       content = ListView.builder(
//           itemCount: _.length,
//           itemBuilder: ((context, index) => Dismissible(
//                 onDismissed: (direction) {
//                   removeItem(loadedItems[index]);
//                 },
//                 key: ValueKey(loadedItems[index].id),
//                 child: ListTile(
//                   title: Text([index].name),
//                 ),
//               )));
//     }
//   // 3 -----------------------------------------------------------------------------------
//     return Scaffold(
//       appBar: AppBar(
//           title: Text('Your documents'),
//           actions: [IconButton(onPressed: (){}, icon: Icon(Icons.add))],
//         ),
//         body: content
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'imageViewScreen.dart';

class MyDocuments extends StatefulWidget {
  const MyDocuments({super.key});

  @override
  State<MyDocuments> createState() => _MyDocumentsState();
}

class _MyDocumentsState extends State<MyDocuments> {
  bool _isLoading = true;
  List<FileObject> _loadedDocs = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    print("User not logged in");
    return;
  }

  try {
    final List<FileObject> docs = await Supabase.instance.client.storage
        .from('privatedoc')
        .list(path: userId); // ✅ List only the user's files

    setState(() {
      _loadedDocs = docs;
      _isLoading = false;
    });
  } catch (e) {
    print("Error loading documents: $e");
  }
}


void removeItem(FileObject item) async {
  final user = Supabase.instance.client.auth.currentUser;

  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User not authenticated.')),
    );
    return;
  }

  final filePath = '${user.id}/${item.name}'; // Ensure correct file path

  try {
    await Supabase.instance.client.storage
        .from('privatedoc')
        .remove([filePath]); // 🗑 Delete file from storage

    setState(() {
      _loadedDocs.remove(item); // ✅ Remove from local list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File deleted successfully.')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error deleting file: $e')),
    );
  }
}


  void _navigateToUploadScreen() async {
    final result = await Navigator.pushNamed(context, '/uploadDocs');

    if (result == true) {
      _loadItems(); // ✅ Reload file list after upload
    }
  }

void _openImage(String fileName) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) {
    print("User not logged in");
    return;
  }

  final imageUrl = await Supabase.instance.client.storage
      .from('privatedoc')
      .createSignedUrl('$userId/$fileName', 60); // ✅ Secure access with signed URL

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageViewerScreen(imageUrl: imageUrl),
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Documents'),
        actions: [
          IconButton(
            onPressed: _navigateToUploadScreen,
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _loadedDocs.isEmpty
              ? Center(child: Text('No items added yet'))
              :ListView.builder(
                  itemCount: _loadedDocs.length,
                  itemBuilder: (context, index) => Dismissible(
                    key: ValueKey(_loadedDocs[index].id),
                    //onDismissed: (direction) {
                      //removeItem(_loadedDocs[index]);
                    //},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Shadow color
                              blurRadius: 8, // Softness of shadow
                              spreadRadius: 2, // How far the shadow spreads
                              offset: Offset(0, 4), // Vertical shadow direction
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            _loadedDocs[index].name,
                            style: TextStyle(fontWeight: FontWeight.w600), // Slightly bold text
                          ),
                          leading: Icon(Icons.insert_drive_file, color: Colors.blueAccent), // File icon
                          tileColor: Colors.white, 
                          onTap: () {
                            _openImage(_loadedDocs[index].name);
                          },// Tile background color
                        ),
      ),
    ),
  ),
)
    );
  }
}
