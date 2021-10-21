class RequestBody {
  final int? page;
  final int? start;
  final int? limit;

  final List<SortItem>? sort;
  final List<FilterItem>? filters;
  final String sourcePanel;
  final String $type;

  RequestBody({
    this.page,
    this.start,
    this.limit,
    this.sort,
    this.filters,
    required this.sourcePanel,
    required this.$type,
  });

  Map<String, dynamic> toJson() => {
        'page': page,
        'start': start,
        'limit': limit,
        'sort': sort?.map((e) => e.toJson()).toList(),
        'filters': filters?.map((e) => e.toJson()).toList(),
        'sourcePanel': sourcePanel,
        '\$type': $type,
      };
}

class SortItem {
  final String property;
  final String direction;

  SortItem({
    required this.property,
    required this.direction,
  });

  Map<String, dynamic> toJson() => {
        'property': property,
        'direction': direction,
      };
}

class FilterItem {
  final String filterType;
  final String? childType;
  final String? parentProperty;
  final String? childProperty;
  final String? property;
  final String? type;
  final Object value;
  final Object? valueRecord;

  FilterItem({
    required this.filterType,
    this.childType,
    this.parentProperty,
    this.childProperty,
    this.property,
    this.type,
    required this.value,
    this.valueRecord,
  });

  Map<String, dynamic> toJson() => {
        'filterType': filterType,
        'childType': childType,
        'parentProperty': parentProperty,
        'childProperty': childProperty,
        'property': property,
        'type': type,
        'value': value,
        'valueRecord': valueRecord,
      };
}

enum Direction {
  ASC,
  DESC,
}

enum FilterType {
  Reference,
  Column,
}

enum ChildType {
  VoucherRedeem,
}

enum SourcePanel {
  Voucher,
  Voucher_VoucherRedeem,
}

enum RequestType {
  DataQueryArguments,
}

/* example:
{
"page": 1,
"start": 0,
"limit": 30,
"sort": [
{
"property": "created",
"direction": "DESC"
}
],
"filters": [
{
"filterType": "Reference",
"childType": "Nemo.Shop.Vouchers.Models.VoucherRedeem",
"parentProperty": "id",
"childProperty": "voucherId",
"value": 2217324,
"valueRecord": null
}
],
"sourcePanel": "Voucher_VoucherRedeem",
"$type": "DataQueryArguments"
}*/
