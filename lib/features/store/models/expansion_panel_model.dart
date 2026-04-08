// stores ExpansionPanel state information
class CExpansionPanelModel {
  CExpansionPanelModel(
      {required this.expandedValue,
      required this.headerValue,
      this.isExpanded = false});

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
