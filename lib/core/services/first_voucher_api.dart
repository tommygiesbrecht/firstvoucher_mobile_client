import 'dart:convert';

import 'package:firstvoucher_mobile_client/core/env.dart';
import 'package:firstvoucher_mobile_client/core/services/models/request_body.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/src/response.dart';

import 'models/voucher_redeem.dart';

class FirstVoucherApi {
  static String BASE_URL = '${Environment.BASE_URL}/api/';
  static String TOKEN = Environment.AUTH_TOKEN;

  Future<T> _withClient<T>(Future<T> Function(Client) fn) async {
    var client = Client();
    try {
      return await fn(client);
    } finally {
      client.close();
    }
  }

  Future<Response> _sendRequest(Request request) {
    return _withClient<Response>(
        (client) async => Response.fromStream(await client.send(request)));
  }

  Future<Voucher> fetchVoucher(String voucherCode) async {
    RequestBody requestBody = new RequestBody(
      sort: [
        SortItem(property: 'created', direction: describeEnum(Direction.DESC)),
      ],
      sourcePanel: describeEnum(SourcePanel.Voucher),
      $type: describeEnum(RequestType.DataQueryArguments),
      filters: [
        new FilterItem(
          filterType: describeEnum(FilterType.Column),
          property: 'code',
          value: voucherCode,
          type: '==',
        ),
      ],
    );

    Request request =
        Request('QUERY', Uri.parse('${BASE_URL}data/Nemo.Shop.Models.Voucher'));
    request.headers.addAll({
      'Authorization': 'Bearer $TOKEN',
    });
    request.body = jsonEncode(requestBody.toJson());

    final response = await _sendRequest(request);

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'] as List;
      if (list.length == 1) {
        return Voucher.fromJson(list[0]);
      }
    }
    throw Exception('Failed to load voucher');
  }

  Future<List<Voucher>> fetchVouchers() async {
    RequestBody requestBody = new RequestBody(
      sort: [
        SortItem(property: 'created', direction: describeEnum(Direction.DESC)),
      ],
      sourcePanel: describeEnum(SourcePanel.Voucher),
      $type: describeEnum(RequestType.DataQueryArguments),
      filters: [
        new FilterItem(
          filterType: describeEnum(FilterType.Column),
          property: 'locked',
          value: false,
          type: '==',
        ),
      ],
    );

    Request request =
        Request('QUERY', Uri.parse('${BASE_URL}data/Nemo.Shop.Models.Voucher'));
    request.headers.addAll({
      'Authorization': 'Bearer $TOKEN',
    });
    request.body = jsonEncode(requestBody.toJson());

    final response = await _sendRequest(request);

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'] as List;
      return list.map((item) => Voucher.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  Future<List<VoucherRedeem>> fetchVoucherRedeems(int voucherId) async {
    RequestBody requestBody = new RequestBody(
      sort: [
        SortItem(property: 'created', direction: describeEnum(Direction.DESC)),
      ],
      sourcePanel: describeEnum(SourcePanel.Voucher_VoucherRedeem),
      $type: describeEnum(RequestType.DataQueryArguments),
      filters: [
        new FilterItem(
          filterType: describeEnum(FilterType.Reference),
          childType: 'Nemo.Shop.Vouchers.Models.' +
              describeEnum(ChildType.VoucherRedeem),
          parentProperty: 'id',
          childProperty: 'voucherId',
          value: voucherId,
        ),
      ],
    );

    Request request = Request(
        'QUERY', Uri.parse('${BASE_URL}data/Nemo.Shop.Models.VoucherRedeem'));
    request.headers.addAll({
      'Authorization': 'Bearer $TOKEN',
    });
    request.body = jsonEncode(requestBody.toJson());

    final response = await _sendRequest(request);

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body)['data'] as List;
      return list.map((item) => VoucherRedeem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load redeems');
    }
  }

  Future<Voucher> createVoucher({required double price}) async {
    Map<String, dynamic> requestBody = {
      'price': price,
    };
    Response response = await post(
      Uri.parse('${BASE_URL}data/Nemo.Shop.Models.Voucher'),
      headers: {
        'Authorization': 'Bearer $TOKEN',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Voucher voucher = Voucher.fromJson(jsonDecode(response.body));
      voucher.code = voucher.id.toString();
      return await updateVoucher(voucher: voucher);
    } else {
      throw Exception('Failed to create voucher');
    }
  }

  Future<Voucher> updateVoucher({required Voucher voucher}) async {
    Response response = await put(
      Uri.parse('${BASE_URL}data/Nemo.Shop.Models.Voucher/${voucher.id}'),
      headers: {
        'Authorization': 'Bearer $TOKEN',
      },
      body: jsonEncode(voucher),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return Voucher.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update voucher');
    }
  }

  Future<VoucherRedeem> createVoucherRedeem({
    required double price,
    required int voucherId,
  }) async {
    Map<String, dynamic> requestBody = {
      'price': price,
      'voucherId': voucherId,
    };
    Response response = await post(
      Uri.parse('${BASE_URL}data/Nemo.Shop.Models.VoucherRedeem'),
      headers: {
        'Authorization': 'Bearer $TOKEN',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return VoucherRedeem.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create voucher');
    }
  }
}
