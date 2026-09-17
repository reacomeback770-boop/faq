import 'package:flutter/material.dart';

class BreadcrumbItem {
  final String title;
  final VoidCallback? onTap;
  final bool isActive;

  const BreadcrumbItem({
    required this.title,
    this.onTap,
    this.isActive = false,
  });
}

class BreadcrumbBar extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const BreadcrumbBar({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF1F5F9),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(items.length * 2 - 1, (index) {
            if (index.isOdd) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
              );
            }

            final itemIndex = index ~/ 2;
            final item = items[itemIndex];

            return InkWell(
              onTap: item.isActive ? null : item.onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: item.isActive
                      ? const Color(0xFFEFF6FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        item.isActive ? FontWeight.w700 : FontWeight.w500,
                    color: item.isActive
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
