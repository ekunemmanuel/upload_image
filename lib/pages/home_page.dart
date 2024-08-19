import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upload_image/services/storage_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // context.read<StorageService>().fetchImages();
  }

  Future<void> fetchImages() async {
    await Provider.of<StorageService>(context, listen: false).fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(builder: (context, storage, child) {
      List<String> imgUrls = storage.imageUrls;
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => storage.uploadImage(),
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: ListView.separated(
            itemBuilder: (context, index) {
              final String imgUrl = imgUrls[index];
              return Image.network(imgUrl);
            },
            itemCount: storage.imageUrls.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 5,
            ),
          ),
        ),
      );
    });
  }
}
