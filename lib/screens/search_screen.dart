import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map/controller/search_controller.dart';
import 'package:map/widgets/search_box.dart';
import 'package:map/widgets/search_item.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TSearchController controller = Get.put(TSearchController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SearchBox(text: 'Tìm kiếm..'),
                const SizedBox(height: 20),
                Obx(() => controller.searchList.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.searchList.length,
                        itemBuilder: (context, index) {
                          return SearchItem(
                              address: controller.searchList[index],
                              onDirect: controller.navigateToAddress,
                              index: index);
                        },
                      )
                    : const SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
