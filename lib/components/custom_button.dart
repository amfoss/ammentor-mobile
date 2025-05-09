
import 'package:ammentor/components/theme.dart';
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * 0.7,
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
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: AppColors.primary, radius: 12),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: Text(
                      _selected,
                      style: AppTextStyles.caption(context).copyWith(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.white,
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
                  contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 10,
                    child: option == _selected
                        ? const Icon(Icons.check, color: AppColors.background, size: 14)
                        : null,
                  ),
                  title: Text(option,
                      style:  AppTextStyles.caption(context).copyWith(color: AppColors.white)),
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