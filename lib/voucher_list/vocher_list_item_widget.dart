import 'dart:io';

import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/voucher_detail/vocher_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_settings/open_settings.dart';

class VoucherListItemWidget extends StatefulWidget {
  Voucher voucher;

  VoucherListItemWidget({required this.voucher});

  @override
  State<StatefulWidget> createState() => VoucherListItemState();
}

class VoucherListItemState extends State<VoucherListItemWidget> {
  final FirstVoucherApi _firstVoucherApi = new FirstVoucherApi();

  Future<void> _updateVoucher() async {
    try {
      Voucher updated =
          await _firstVoucherApi.fetchVoucher(widget.voucher.code);
      setState(() {
        widget.voucher = updated;
      });
    } on SocketException {
      showNetworkError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.voucher.isActive() ? 1 : 0.5,
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoucherDetailWidget(
                voucher: widget.voucher,
              ),
            ),
          );
          _updateVoucher();
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.voucher.remainingAmount.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      '${widget.voucher.code}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(DateFormat('dd.MM.yyy')
                        .format(DateTime.parse(widget.voucher.created))),
                    Text(
                      'Gesamt: ${widget.voucher.price.toStringAsFixed(2)} €',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${widget.voucher.redeems} Einlösungen',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
