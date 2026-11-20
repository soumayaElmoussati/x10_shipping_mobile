
import 'package:flutter/material.dart';

class SelectionOption {
  final String label;
  final String? subtitle;
  final IconData? icon;
  final String? emoji;

  const SelectionOption({
    required this.label,
    this.subtitle,
    this.icon,
    this.emoji,
  });
}

class CustomSelectionField extends StatelessWidget {
  final String label;
  final String hint;
  final String value;
  final List<SelectionOption> options;
  final ValueChanged<String> onChanged;
  final IconData leadingIcon;
  final bool searchable;

  const CustomSelectionField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.leadingIcon,
    this.searchable = true,
  });

  static const Color primary = Color(0xFFF15A00);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);
  static const Color border = Color(0xFFE8EAF0);

  Future<void> _openSelection(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (context) => _SelectionSheet(
        title: label,
        options: options,
        selectedValue: value,
        searchable: searchable,
      ),
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: dark,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openSelection(context),
            borderRadius: BorderRadius.circular(13),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  Icon(
                    leadingIcon,
                    color: muted,
                    size: 19,
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      value.isEmpty ? hint : value,
                      style: TextStyle(
                        color: value.isEmpty ? muted : dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: muted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionSheet extends StatefulWidget {
  final String title;
  final List<SelectionOption> options;
  final String selectedValue;
  final bool searchable;

  const _SelectionSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.searchable,
  });

  @override
  State<_SelectionSheet> createState() => _SelectionSheetState();
}

class _SelectionSheetState extends State<_SelectionSheet> {
  static const Color primary = Color(0xFFF15A00);
  static const Color dark = Color(0xFF20242C);
  static const Color muted = Color(0xFF858B98);

  final TextEditingController _searchController =
      TextEditingController();

  String _query = '';

  List<SelectionOption> get _filteredOptions {
    if (_query.trim().isEmpty) return widget.options;

    return widget.options.where((option) {
      return option.label.toLowerCase().contains(
            _query.trim().toLowerCase(),
          ) ||
          (option.subtitle ?? '').toLowerCase().contains(
            _query.trim().toLowerCase(),
          );
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(27),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDADDE3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 16, 15),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select ${widget.title}',
                            style: const TextStyle(
                              color: dark,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.options.length} available options',
                            style: const TextStyle(
                              color: muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F6F8),
                      ),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: dark,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.searchable)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _query = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.title.toLowerCase()}...',
                      hintStyle: const TextStyle(
                        color: muted,
                        fontSize: 12,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: muted,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FB),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

              Flexible(
                child: _filteredOptions.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            'No results found',
                            style: TextStyle(
                              color: muted,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                        itemCount: _filteredOptions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 7),
                        itemBuilder: (context, index) {
                          final option = _filteredOptions[index];
                          final selected =
                              option.label == widget.selectedValue;

                          return InkWell(
                            onTap: () => Navigator.pop(
                              context,
                              option.label,
                            ),
                            borderRadius: BorderRadius.circular(13),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: selected
                                    ? primary.withOpacity(0.07)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: selected
                                      ? primary.withOpacity(0.55)
                                      : const Color(0xFFE8EAF0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (option.emoji != null)
                                    Container(
                                      width: 39,
                                      height: 39,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FB),
                                        borderRadius:
                                            BorderRadius.circular(11),
                                      ),
                                      child: Text(
                                        option.emoji!,
                                        style: const TextStyle(
                                          fontSize: 21,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 39,
                                      height: 39,
                                      decoration: BoxDecoration(
                                        color: primary.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(11),
                                      ),
                                      child: Icon(
                                        option.icon ??
                                            Icons.location_on_outlined,
                                        color: primary,
                                        size: 19,
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.label,
                                          style: const TextStyle(
                                            color: dark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        if (option.subtitle != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            option.subtitle!,
                                            style: const TextStyle(
                                              color: muted,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: primary,
                                      size: 21,
                                    )
                                  else
                                    const Icon(
                                      Icons.circle_outlined,
                                      color: Color(0xFFD6D9DF),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
