import 'dart:io';

import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher_redeem.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:open_settings/open_settings.dart';

class VoucherRedeemWidget extends StatefulWidget {
  final Voucher voucher;

  VoucherRedeemWidget({required this.voucher});

  @override
  State<StatefulWidget> createState() => VoucherRedeemState();
}

class VoucherRedeemState extends State<VoucherRedeemWidget> {
  final FirstVoucherApi _firstVoucherApi = new FirstVoucherApi();

  List<bool> _isSelected = [];

  String amount = "";

  bool _hasError = false;

  @override
  void initState() {
    _isSelected = [
      true,
      false,
    ];
    amount = widget.voucher.remainingAmount.toStringAsFixed(0);
    super.initState();
  }

  void _onKeyboardTap(String value) {
    setState(() {
      if (!(amount.isEmpty && value == "0")) {
        amount = amount + value;
      }
      _hasError = amount.isNotEmpty &&
          double.parse(amount) > widget.voucher.remainingAmount;
    });
  }

  void _onRemove() {
    if (amount.length > 0) {
      setState(() {
        amount = amount.substring(0, amount.length - 1);
        _hasError = amount.isNotEmpty &&
            double.parse(amount) > widget.voucher.remainingAmount;
      });
    }
  }

  void _onSubmit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gutschein einlösen'),
          content: Text('$amount € für den Gutschein einlösen?'),
          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Einlösen'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  VoucherRedeem voucherRedeem =
                      await _firstVoucherApi.createVoucherRedeem(
                    price: double.parse(amount),
                    voucherId: widget.voucher.id,
                  );
                  Navigator.of(this.context).pop();
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

  bool _isTotalRedeem() {
    return _isSelected[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einlösen'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Text(
                    amount.toString() + " €",
                    style: TextStyle(
                      fontSize: 60,
                      color: _hasError ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ),
              ToggleButtons(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Vollständig einlösen'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Teilbetrag einlösen'),
                  ),
                ],
                isSelected: _isSelected,
                onPressed: (index) => {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = !_isSelected[i];
                    }
                    amount = widget.voucher.remainingAmount.toStringAsFixed(0);
                    _hasError = false;
                  }),
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 40),
                  ),
                  onPressed: (_hasError || amount.isEmpty) ? null : _onSubmit,
                  child: Text('Einlösen'),
                ),
              ),
              Visibility(
                visible: !_isTotalRedeem(),
                child: NumericKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  rightIcon: Icon(Icons.backspace),
                  rightButtonFn: _onRemove,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
