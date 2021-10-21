import 'dart:io';

import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/error/network_error_widget.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher_redeem.dart';
import 'package:firstvoucher_mobile_client/voucher_detail/pdf_view_widget.dart';
import 'package:firstvoucher_mobile_client/voucher_redeem/vocher_redeem_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_settings/open_settings.dart';

class VoucherDetailWidget extends StatefulWidget {
  Voucher voucher;

  VoucherDetailWidget({required this.voucher});

  @override
  State<StatefulWidget> createState() => VoucherDetailState();
}

class VoucherDetailState extends State<VoucherDetailWidget> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.voucher.code),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfViewWidget(
                    voucher: widget.voucher,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.voucher.remainingAmount.toStringAsFixed(2)} €',
                        style: TextStyle(
                            fontSize: 50,
                            color: widget.voucher.isActive()
                                ? Colors.green
                                : Colors.grey),
                      ),
                      Text(
                        'Gesamt: ${widget.voucher.price.toStringAsFixed(2)} €',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Gekauft am ' +
                            DateFormat('dd.MM.yyy')
                                .format(DateTime.parse(widget.voucher.created)),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Visibility(
                        visible: widget.voucher.locked,
                        child: Text(
                          'GESPERRT',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Einlösungen', style: TextStyle(fontSize: 20)),
                    FutureBuilder(
                      future: _firstVoucherApi
                          .fetchVoucherRedeems(widget.voucher.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          List<VoucherRedeem> redeems = snapshot.data;
                          if (redeems.length == 0) {
                            return Expanded(
                                child:
                                    Center(child: Text('Keine Einlösungen')));
                          }
                          return Expanded(
                            child: ListView.separated(
                              itemCount: redeems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.swap_horiz),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                              '${redeems[index].price.toStringAsFixed(2)} €'),
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yyy').format(
                                            DateTime.parse(
                                                redeems[index].created)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Expanded(
                            child: NetworkErrorWidget(),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 40),
                ),
                onPressed: widget.voucher.isActive()
                    ? () async => {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VoucherRedeemWidget(
                                voucher: widget.voucher,
                              ),
                            ),
                          ),
                          _updateVoucher(),
                        }
                    : null,
                child: Text('Einlösen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
