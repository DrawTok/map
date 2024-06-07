import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map/controller/search_controller.dart';

class SearchBox extends GetView<TSearchController> {
  const SearchBox({
    super.key,
    required this.text,
    this.icon = Icons.search,
    this.showBg = true,
    this.showBorder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
  });

  final String text;
  final IconData? icon;
  final bool showBg, showBorder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), // Rounded corners
        boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 2),
        ), BoxShadow(
        color: Colors.grey.shade200,
        spreadRadius: 1,
        blurRadius: 10,
        offset: const Offset(0, 2),
      )
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 16,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(
                  () => TextField(
                controller: textController,
                onChanged: (newQuery) {
                  controller.updateQuery(newQuery);
                },
                decoration: InputDecoration(
                  hintText: text,
                  enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
                  suffixIcon: controller.query.value.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, size: 16),
                    onPressed: () {
                      textController.clear();
                      controller.updateQuery('');
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
