import 'package:flutter/material.dart';
import 'package:map/model/address_model.dart';

class SearchItem extends StatelessWidget {
  final Address address;
  final int index;
  final void Function(int index) onDirect;

  const SearchItem({super.key, required this.address, required this.onDirect, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onDirect(index);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.location_on_outlined),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(address.title,
                      overflow: TextOverflow.ellipsis, maxLines: 2)),
              const SizedBox(width: 10),
              const Icon(Icons.directions),
            ],
          )),
    );
  }
}
