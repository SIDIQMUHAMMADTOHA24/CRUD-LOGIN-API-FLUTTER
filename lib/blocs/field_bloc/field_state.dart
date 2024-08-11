part of 'field_bloc.dart';

class FieldState extends Equatable {
  final Map<KeyConstants, bool> focusMap;
  final Map<KeyConstants, String> textMap;
  final Map<KeyConstants, bool> visibilityMap;

  const FieldState({
    required this.focusMap,
    required this.textMap,
    required this.visibilityMap,
  });

  bool hasFocus(KeyConstants key) => focusMap[key] ?? false;
  bool isNotEmpty(KeyConstants key) => textMap[key]?.isNotEmpty ?? false;
  bool isVisible(KeyConstants key) => visibilityMap[key] ?? true;

  @override
  List<Object> get props => [focusMap, textMap, visibilityMap];
}
