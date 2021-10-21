import 'dart:io';

import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/voucher_detail/vocher_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

class VoucherCreateWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoucherCreateState();
}

class VoucherCreateState extends State<VoucherCreateWidget> {
  final _firstVoucherApi = FirstVoucherApi();

  String amount = "50";

  void _onKeyboardTap(String value) {
    setState(() {
      if (!(amount.isEmpty && value == "0")) {
        amount = amount + value;
      }
    });
  }

  void _onRemove() {
    if (amount.length > 0) {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
      });
    }
  }

  void _onSubmit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gutschein erstellen'),
          content: Text('Gutschen für $amount € erstellen?'),
          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Erstellen'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  Voucher voucher = await _firstVoucherApi.createVoucher(
                      price: double.parse(amount));
                  Navigator.push(
                    this.context,
                    MaterialPageRoute(
                      builder: (context) => VoucherDetailWidget(
                        voucher: voucher,
                      ),
                    ),
                  );
                } on SocketException {
                  showNetworkError(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
                child: Text(amount.toString() + " €",
                    style: TextStyle(fontSize: 60))),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 16.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: amount.length > 0 ? _onSubmit : null,
              child: Text('Weiter'),
            ),
          ),
          Expanded(
            flex: 5,
            child: NumericKeyboard(
              onKeyboardTap: _onKeyboardTap,
              rightIcon: Icon(Icons.backspace),
              rightButtonFn: _onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
