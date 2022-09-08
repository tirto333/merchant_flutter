import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:winn_merchant_flutter/controllers/Cart/main.dart';
import 'package:winn_merchant_flutter/utilities/themes.dart';

class PriceQuantityWidget extends StatefulWidget {
  final int index;
  PriceQuantityWidget({Key? key, required this.index}) : super(key: key);

  @override
  State<PriceQuantityWidget> createState() => _PriceQuantityWidgetState();
}

class _PriceQuantityWidgetState extends State<PriceQuantityWidget> {
  final CartController controller = Get.put(CartController());
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    //controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        _textEditingController.text =
            controller.cartProduct[widget.index].quantity.toString();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  // ("${controller.qtyController.value} pcs"),
                  ("${controller.cartProduct[widget.index].quantity} Dus"),
                  //todo
                  //'${controller.qtyController.text} Pcs',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: (controller.cartProduct[widget.index].quantity! < 2)
                        ? null
                        : () {
                            controller.plusMinus(
                              section: 'minus',
                              cartId: controller.cartProduct[widget.index].id,
                            );
                          },
                    child: SvgPicture.asset(
                      'assets/icons/reduce-one.svg',
                      height: 20,
                      width: 20,
                      color: controller.cartProduct[widget.index].quantity! < 2
                          ? Colors.grey[400]
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: (value) {
                        //debugPrint("onChange value $value");
                        late int v;
                        if (value.isEmpty) {
                          v = 0;
                        } else {
                          v = int.parse(value);
                        }
                        controller.updateQty(
                            cartId: controller.cartProduct[widget.index].id,
                            quantity: v);
                      },
                      // onChanged: (value) {
                      //   //debugPrint("onChange value $value");
                      //   late int v;
                      //   if (value.isEmpty) {
                      //     v = 0;
                      //   } else {
                      //     v = int.parse(value);
                      //   }
                      //   controller.updateQty(
                      //       cartId: controller.cartProduct[widget.index].id,
                      //       quantity: v);
                      // },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (controller.cartProduct[widget.index].quantity! >
                                0) &&
                            (controller.cartProduct[widget.index].quantity ==
                                controller.cartProduct[widget.index].stock)
                        ? null
                        : () {
                            controller.plusMinus(
                              section: 'plus',
                              cartId: controller.cartProduct[widget.index].id,
                            );
                            // setState(() {
                            //   qty;
                            // });
                          },
                    child: SvgPicture.asset(
                      'assets/icons/add-one.svg',
                      height: 20,
                      width: 20,
                      color: (controller.cartProduct[widget.index].quantity! >
                                  0) &&
                              (controller.cartProduct[widget.index].quantity ==
                                  controller.cartProduct[widget.index].stock)
                          ? Colors.grey[400]
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
