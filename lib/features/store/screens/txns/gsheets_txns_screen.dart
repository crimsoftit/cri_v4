import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GsheetsTxnsScreen extends StatelessWidget {
  const GsheetsTxnsScreen({super.key});

  List<DataColumn> createColumns() {
    return const [
      DataColumn(label: Text('txnId', maxLines: 2)),
      DataColumn(label: Text('pId')),
      DataColumn(label: Text('pCode')),
      DataColumn(label: Text('name')),
      DataColumn(label: Text('qty')),
      DataColumn(label: Text('amount issued')),
      DataColumn(label: Text('t.Amount')),
    ];
  }

  List<DataRow> createRows() {
    final txnsController = Get.put(CTxnsController());
    txnsController.fetchUserTxnsSheetData();
    return txnsController.userGsheetTxnsData.map((e) {
      return DataRow(
        cells: [
          DataCell(
            Expanded(
              child: Text(
                e.txnId.toString(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.productId.toString(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.productCode,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.productName,
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.quantity.toString(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.amountIssued.toString(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
          DataCell(
            Expanded(
              child: Text(
                e.totalAmount.toString(),
                style: const TextStyle(overflow: TextOverflow.ellipsis),
                maxLines: 2,
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.rBrown,
        title: Text(
          'cloud txns data...',
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.apply(color: CColors.white),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: SizedBox(
              width: CHelperFunctions.screenWidth() * 0.97,
              height: CHelperFunctions.screenHeight() * 0.7,
              child: Obx(() {
                return SizedBox(
                  child: DataTable(
                    columns: createColumns(),
                    rows: createRows(),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
