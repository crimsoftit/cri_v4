import 'dart:io';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/models/cart_item_model.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf_widget;

class CPdfServices extends GetxController {
  CPdfServices.init();

  static CPdfServices instance = CPdfServices.init();

  //static CPdfServices get instance => Get.find();

  /// -- variables --
  final cartController = Get.put(CCartController());

  final userController = Get.put(CUserController());

  Future<Uint8List> createHelloWorld() {
    final pdfDoc = pdf_widget.Document();

    pdfDoc.addPage(
      pdf_widget.Page(
        build: (pdf_widget.Context context) {
          return pdf_widget.Center(child: pdf_widget.Text('Hello world'));
        },
      ),
    );

    return pdfDoc.save();
  }

  Future<Uint8List> generateReceipt(List<CCartItemModel> itemsInCart) async {
    final receipt = pdf_widget.Document();

    // final receiptLogo =
    //     (await rootBundle.load(CImages.darkAppLogo)).buffer.asUint8List();

    receipt.addPage(
      pdf_widget.MultiPage(
        pageFormat: PdfPageFormat.a6,
        build: (pdf_widget.Context context) {
          return [
            receiptTitle(),
            pdf_widget.SizedBox(height: 1.0),
            receiptBarCode(),
            pdf_widget.Column(
              children: [
                // pdf_widget.Image(
                //   pdf_widget.MemoryImage(receiptLogo),
                //   width: 50.0,
                //   height: 50.0,
                //   fit: pdf_widget.BoxFit.cover,
                // ),
                pdf_widget.Row(
                  mainAxisAlignment: pdf_widget.MainAxisAlignment.spaceBetween,
                  children: [
                    pdf_widget.Column(
                      children: [
                        pdf_widget.Text('customer name'),
                        pdf_widget.Text('customer address'),
                        pdf_widget.Text('customer city'),
                      ],
                    ),
                    pdf_widget.Column(
                      children: [
                        pdf_widget.Text('Simiyu Sindani'),
                        pdf_widget.Text('Kisumu Dala'),
                        pdf_widget.Text('customer city'),
                        pdf_widget.Text('VAT-id: 4219384'),
                        pdf_widget.Text('txn id: 01234'),
                      ],
                    ),
                  ],
                ),
                pdf_widget.Divider(),
                // pdf_widget.Text(elements.first.itemName),
                // pdf_widget.Text((double.parse(
                //         CPriceCalculator.instance.computeVatTotals(itemsInCart))
                //     .toStringAsFixed(2))),
                receiptItems(),
              ],
            ),
          ];
        },
      ),
    );

    return receipt.save();
  }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final receiptOutput = await getApplicationDocumentsDirectory();
    var filePath = '${receiptOutput.path}/$fileName.pdf';
    final pdfFile = File(filePath);

    await pdfFile.writeAsBytes(byteList);

    await OpenFile.open(filePath);
  }

  static pdf_widget.Widget receiptTitle() {
    final userController = Get.put(CUserController());
    return pdf_widget.Column(
      crossAxisAlignment: pdf_widget.CrossAxisAlignment.start,
      children: [
        pdf_widget.Text(
          userController.user.value.businessName.toUpperCase(),
          style: pdf_widget.TextStyle(
            fontBold: pdf_widget.Font.helveticaBold(),
            fontSize: 13.0,
            // color: pdf_widget.CColors.rBrown,
          ),
        ),
      ],
    );
  }

  pdf_widget.Widget receiptBarCode() {
    final checkoutController = Get.put(CCheckoutController());
    return pdf_widget.Container(
      decoration: pdf_widget.BoxDecoration(
        borderRadius: pdf_widget.BorderRadius.only(
          bottomLeft: pdf_widget.Radius.circular(21),
          bottomRight: pdf_widget.Radius.circular(21),
        ),
        color: PdfColors.white,
      ),
      padding: const pdf_widget.EdgeInsets.symmetric(
        vertical: CSizes.spaceBtnItems,
      ),
      margin: const pdf_widget.EdgeInsets.symmetric(
        horizontal: CSizes.spaceBtnItems,
      ),
      child: pdf_widget.Container(
        padding: const pdf_widget.EdgeInsets.symmetric(
          horizontal: CSizes.spaceBtnItems,
        ),
        child: pdf_widget.ClipRRect(
          horizontalRadius: 15.0,
          verticalRadius: 15.0,
          child: pdf_widget.BarcodeWidget(
            barcode: pdf_widget.Barcode.code128(),
            data: checkoutController.txnId.value.toString(),
            drawText: false,
            width: double.maxFinite,
            height: 70.0,
          ),
        ),
      ),
    );
  }

  pdf_widget.Widget receiptItems() {
    final currencySymbol = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    final headers = ['description', 'price', 'qty', 'vat', 'total'];

    cartController.fetchCartItems();

    final receiptData = cartController.cartItems.map((item) {
      final itemTotal = item.price * item.quantity * .19;
      return [
        item.pName,
        '$currencySymbol.${item.price.toStringAsFixed(2)}',
        item.quantity,
        19,
        '$currencySymbol.${itemTotal.toStringAsFixed(2)}',
      ];
    }).toList();

    return pdf_widget.TableHelper.fromTextArray(
      columnWidths: {
        0: pdf_widget.FractionColumnWidth(0.4),
        1: pdf_widget.FractionColumnWidth(0.2),
        2: pdf_widget.FractionColumnWidth(0.2),
        3: pdf_widget.FractionColumnWidth(0.2),
        4: pdf_widget.FractionColumnWidth(0.4),
      },
      headers: headers,
      data: receiptData,
      border: null,
      headerStyle: pdf_widget.TextStyle(fontWeight: pdf_widget.FontWeight.bold),
      cellHeight: 30.0,
      headerDecoration: pdf_widget.BoxDecoration(color: PdfColors.brown500),
      cellAlignments: {
        0: pdf_widget.Alignment.centerLeft,
        1: pdf_widget.Alignment.centerRight,
        2: pdf_widget.Alignment.centerRight,
        3: pdf_widget.Alignment.centerRight,
        4: pdf_widget.Alignment.centerRight,
      },
    );
  }
}
