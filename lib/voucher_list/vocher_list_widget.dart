import 'package:firstvoucher_mobile_client/core/services/error/network_error_widget.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/voucher_list/vocher_list_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

class VoucherListWidget extends StatelessWidget {
  final FirstVoucherApi _firstVoucherApi = new FirstVoucherApi();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _firstVoucherApi.fetchVouchers(),
        builder: (BuildContext context, AsyncSnapshot<List<Voucher>> snapshot) {
          if (snapshot.hasData) {
            List<Voucher> vouchers = snapshot.data ?? <Voucher>[];
            return ListView.separated(
              itemCount: vouchers.length,
              itemBuilder: (BuildContext context, int index) {
                Voucher voucher = vouchers[index];
                return VoucherListItemWidget(voucher: voucher);
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Divider(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
            return NetworkErrorWidget();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
