import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GsheetsInvScreen extends StatelessWidget {
  const GsheetsInvScreen({super.key});

  List<DataColumn> createColumns() {
    return const [
      DataColumn(label: Text('pId')),
      DataColumn(label: Text('pCode')),
      DataColumn(label: Text('name')),
      DataColumn(label: Text('qty')),
      DataColumn(label: Text('bp')),
      DataColumn(label: Text('usp')),
    ];
  }

  List<DataRow> createRows() {
    final invController = Get.put(CInventoryController());
    invController.fetchUserInvSheetData();
    return invController.userGSheetData.map((e) {
      return DataRow(
        cells: [
          DataCell(Text(e.productId.toString())),
          DataCell(Text(e.pCode)),
          DataCell(Text(e.name)),
          DataCell(Text(e.quantity.toString())),
          DataCell(Text(e.buyingPrice.toString())),
          DataCell(Text(e.unitSellingPrice.toString())),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    //final invController = Get.put(CInventoryController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.rBrown,
        title: Text(
          'cloud inventory data...',
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
                return DataTable(columns: createColumns(), rows: createRows());
              }),
            ),
          ),
        ),
      ),
    );
  }
}
