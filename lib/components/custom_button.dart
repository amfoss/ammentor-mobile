
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final List<String> options;
  final String initialSelection;
  final void Function(String selected)? onSelect;

  const CustomButton({
    super.key,
    required this.options,
    required this.initialSelection,
    this.onSelect,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  late String _selected;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(backgroundColor: Color(0xFFF6C32E), radius: 12),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selected,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            height: _expanded ? widget.options.length * 60.0 : 0,
            
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: widget.options.map((option) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 10,
                    child: option == _selected
                        ? const Icon(Icons.check, color: Colors.black, size: 14)
                        : null,
                  ),
                  title: Text(option,
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                  onTap: () {
                    setState(() {
                      _selected = option;
                      _expanded = false;
                    });
                    if (widget.onSelect != null) {
                      widget.onSelect!(option);
                    }
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}