class DataModel {
  late List<String> dataTypes;
  late Map<String, dynamic> data;
  late Map<String, Map<String, Set>> availableParams;

  static const Set<String> availableIntegerFilters = {'year', 'duration', 'score'};
  static const Set<String> availableListFilters = {'tags', 'type'};

  DataModel({required this.dataTypes, required this.data, required this.availableParams});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var dataTypesRaw = json.keys.toList();

    Map<String, Map<String, Set>> availableParams = {};
    for (var type in dataTypesRaw) {
      var rawData = json[type] as List;
      availableParams[type] = {};
      for (var row in rawData) {
        for (var key in row.keys.toList()) {
          var value = row[key];
          if (value == null) {
            continue;
          }
          if (!availableParams[type]!.containsKey(key)) {
            if (availableIntegerFilters.contains(key)) {
              availableParams[type]![key] = <double>{};
            } else {
              availableParams[type]![key] = <String>{};
            }
          }
          if (availableListFilters.contains(key)) {
            for (var x in value) {
              availableParams[type]![key]!.add(x);
            }
          } else if (availableIntegerFilters.contains(key)) {
            availableParams[type]![key]!.add(double.parse(value.toString()));
          } else {
            availableParams[type]![key]!.add(value.toString());
          }
        }
      }
      for (var i in availableParams[type]!.keys.toList()) {
        var listParams = availableParams[type]![i]?.toList();
        listParams?.sort();
        availableParams[type]![i] = listParams!.toSet();
      }
    }
    return DataModel(
      dataTypes: dataTypesRaw,
      data: json,
      availableParams: availableParams,
    );
  }
}

class FilterModel {
  late String category;
  late Map<String, Map<String, dynamic>> filters;

  FilterModel({required this.category, required this.filters});

  factory FilterModel.initFilters() {
    return FilterModel(category: 'games', filters: {});
  }

  void addStringFilter(String filterName, List<String> value) {
    if (!filters.containsKey(filterName)) {
      filters[filterName] = {};
    }
    filters[filterName]!['in'] = value;
  }

  void addIntFilter(String filterName, double from, double to) {
    if (!filters.containsKey(filterName)) {
      filters[filterName] = {};
    }
    filters[filterName]!['from'] = from;
    filters[filterName]!['to'] = to;
  }

  void removeFilter(String filterName) {
    filters.remove(filterName);
  }

  void removeFilters() {
    filters.clear();
  }

  Map<String, dynamic> getExistingFilters() {
    Map<String, dynamic> result = {};
    for (var entry in filters.entries) {
      if (DataModel.availableIntegerFilters.contains(entry.key)) {
        result[entry.key] = {};
        result[entry.key]['from'] = entry.value['from'];
        result[entry.key]['to'] = entry.value['to'];
      } else {
        result[entry.key] = entry.value['in'];
      }
    }
    return result;
  }

  bool checkRowByFilters(Map<String, dynamic> row) {
    var existingFilters = getExistingFilters();
    for (var filter in existingFilters.entries) {
      var rowValue = row[filter.key];

      if (rowValue == null) {
        return false;
      }

      if (DataModel.availableIntegerFilters.contains(filter.key)) {
        var rowValueDouble = double.parse(rowValue.toString());
        if (filter.value['from'] > rowValueDouble || rowValueDouble > filter.value['to']) {
          return false;
        }
      } else if (DataModel.availableListFilters.contains(filter.key)) {
        if (!rowValue.toSet().cast<String>().containsAll(filter.value.toSet().cast<String>())) {
          return false;
        }
      } else {
        if (!filter.value.contains(rowValue)) {
          return false;
        }
      }
    }
    return true;
  }
}
