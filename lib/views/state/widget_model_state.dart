import 'package:falconx/lib.dart';

class WidgetModelState<T extends BaseUniqueModel> with EquatableMixin {
  WidgetModelState({
    String? id,
    required this.data,
    this.index,
    this.selected,
  }) : id = id ?? data.id;

  final String id;
  final int? index;
  bool? selected;
  final T data;

  @override
  List<Object?> get props => [id, data, index, selected];

  @override
  bool? get stringify => true;

  set setSelected(bool isSelected) => selected = isSelected;

  WidgetModelState<T> copyWith({
    String? id,
    T? data,
    int? index,
    bool? selected,
  }) {
    return WidgetModelState<T>(
      id: id ?? this.id,
      data: data ?? this.data.copyWith(),
      index: index ?? this.index,
      selected: selected ?? this.selected,
    );
  }
}
