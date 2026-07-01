import 'package:flutter/material.dart';

class SearchableOption {
  final int id;
  final String label;
  final String? sublabel;
  const SearchableOption(
      {required this.id, required this.label, this.sublabel});
}

class SearchablePicker extends StatelessWidget {
  final String labelText;
  final List<SearchableOption> options;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final bool dense;

  const SearchablePicker({
    super.key,
    required this.labelText,
    required this.options,
    required this.selectedId,
    required this.onChanged,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final selected = options.where((o) => o.id == selectedId);
    final controller = TextEditingController(
        text: selected.isNotEmpty ? selected.first.label : '');

    return Autocomplete<SearchableOption>(
      initialValue: TextEditingValue(
          text: selected.isNotEmpty ? selected.first.label : ''),
      displayStringForOption: (o) => o.label,
      optionsBuilder: (value) {
        final q = value.text.trim();
        if (q.isEmpty) return options;
        return options.where((o) =>
            o.label.contains(q) || (o.sublabel ?? '').contains(q));
      },
      onSelected: (o) => onChanged(o.id),
      fieldViewBuilder: (context, fieldController, focusNode, onSubmit) {
        fieldController.text = controller.text;
        return TextField(
          controller: fieldController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            isDense: dense,
            prefixIcon: const Icon(Icons.search, size: 18),
            suffixIcon: (fieldController.text.isNotEmpty)
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      fieldController.clear();
                      onChanged(null);
                    },
                  )
                : null,
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, opts) {
        return Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 260, maxWidth: 380),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: opts.length,
                itemBuilder: (context, i) {
                  final o = opts.elementAt(i);
                  return ListTile(
                    dense: true,
                    title: Text(o.label),
                    subtitle: o.sublabel != null
                        ? Text(o.sublabel!,
                            style: const TextStyle(fontSize: 11))
                        : null,
                    onTap: () => onSelected(o),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}