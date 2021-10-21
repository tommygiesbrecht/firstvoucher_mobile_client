import 'dart:io';

import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/voucher_detail/vocher_detail_widget.dart';
import 'package:firstvoucher_mobile_client/voucher_search/qr_code_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoucherSearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VoucherSearchState();
}

class VoucherSearchState extends State {
  final TextEditingController _textController = TextEditingController();

  final FirstVoucherApi _firstVoucherApi = FirstVoucherApi();

  bool _isButtonEnabled = false;

  bool _isLoading = false;

  @override
  void initState() {
    _isButtonEnabled = _textController.text.isNotEmpty;
    _textController.addListener(() {
      setState(() {
        _isButtonEnabled = _textController.text.isNotEmpty;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _searchVoucher() async {
    _isLoading = true;
    String voucherCode = _textController.text;
    try {
      Voucher voucher = await _firstVoucherApi.fetchVoucher(voucherCode);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoucherDetailWidget(
            voucher: voucher,
          ),
        ),
      );
    } on SocketException {
      showNetworkError(context);
    } on Exception {
      final snackBar = SnackBar(content: Text('Ungültiger Code: $voucherCode'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Gutscheincode eingeben',
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 40),
                            ),
                            onPressed: _isButtonEnabled ? _searchVoucher : null,
                            child: Text('Suchen'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child:
                            Text('oder', style: TextStyle(color: Colors.grey)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Expanded(
                    child: IconButton(
                      iconSize: 48,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrCodeScannerWidget(),
                          ),
                        )
                      },
                      icon: Icon(Icons.qr_code_scanner_outlined),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
