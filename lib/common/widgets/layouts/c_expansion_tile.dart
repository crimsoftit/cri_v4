import 'package:cri_v3/utils/constants/app_icons.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CExpansionTile extends StatelessWidget {
  const CExpansionTile({
    super.key,
    required this.avatarTxt,
    required this.titleTxt,
    required this.subTitleTxt1Item1,
    required this.subTitleTxt1Item2,
    this.subTitleTxt2Item1,
    required this.subTitleTxt2Item2,
    required this.subTitleTxt3Item1,
    required this.subTitleTxt3Item2,
    this.btn1NavAction,
    this.btn1Txt = '',
    this.btn2Txt = '',
    this.btn1Icon,
    this.btn2Icon,
    this.btn2NavAction,
    this.includeRefundBtn = false,
    this.isSynced,
    this.refundBtnAction,
    this.refundBtn,
    this.syncAction,
    this.txnStatus,
  });

  final bool includeRefundBtn;
  final Icon? btn1Icon, btn2Icon;
  final String avatarTxt;
  final String titleTxt;
  final String subTitleTxt1Item1;
  final String subTitleTxt1Item2;
  final String? subTitleTxt2Item1;
  final String subTitleTxt2Item2;
  final String subTitleTxt3Item1;
  final String subTitleTxt3Item2;
  final String? isSynced;
  final String? syncAction, txnStatus;
  final String btn1Txt, btn2Txt;
  final VoidCallback? btn1NavAction, btn2NavAction, refundBtnAction;
  final Widget? refundBtn;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return ExpansionTile(
      title: ListTile(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.all(5.0),
        leading: CircleAvatar(
          backgroundColor: Colors.brown[300],
          radius: 16.0,
          child: Text(
            avatarTxt,
            style: Theme.of(
              context,
            ).textTheme.labelLarge!.apply(color: CColors.white),
          ),
        ),
        title: Text(
          titleTxt,
          style: Theme.of(context).textTheme.labelMedium!.apply(
            color: isDarkTheme ? CColors.white : CColors.rBrown,
            //fontSizeFactor: 1.2,
            //fontWeightDelta: 2,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$subTitleTxt1Item1 $subTitleTxt1Item2',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                color: isDarkTheme
                    ? CColors.white
                    : CColors.rBrown.withValues(alpha: 0.8),
                //fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '$subTitleTxt2Item1 $subTitleTxt2Item2',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                color: isDarkTheme
                    ? CColors.white
                    : CColors.rBrown.withValues(alpha: 0.8),
                //fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '$subTitleTxt3Item1 $subTitleTxt3Item2',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                color: isDarkTheme
                    ? CColors.white
                    : CColors.rBrown.withValues(alpha: 0.7),
                //fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '$isSynced $syncAction  $txnStatus',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                color: isDarkTheme
                    ? CColors.white
                    : CColors.rBrown.withValues(alpha: 0.7),
                //fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      tilePadding: const EdgeInsets.all(5.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 0, bottom: 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: TextButton.icon(
                  label: Text(
                    btn1Txt,
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: isDarkTheme ? CColors.white : CColors.rBrown,
                    ),
                  ),
                  icon: Icon(
                    Iconsax.info_circle,
                    color: isDarkTheme ? CColors.white : CColors.rBrown,
                  ),
                  onPressed: btn1NavAction,
                ),
              ),
              const SizedBox(width: CSizes.spaceBtnInputFields),
              SizedBox(
                child: TextButton.icon(
                  label: Text(
                    btn2Txt,
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: isDarkTheme ? CColors.white : CColors.rBrown,
                    ),
                  ),
                  icon: btn2Icon,
                  onPressed: btn2NavAction,
                ),
              ),
              SizedBox(
                width: includeRefundBtn ? CSizes.spaceBtnInputFields : 0,
              ),
              includeRefundBtn
                  ? SizedBox(
                      child: TextButton.icon(
                        icon: Icon(
                          CAppIcons.refundIcon,
                          size: CSizes.iconSm,
                          color: Colors.red,
                        ),
                        label: Text(
                          'refund',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium!.apply(color: Colors.red),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(30, 20),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: refundBtnAction,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
