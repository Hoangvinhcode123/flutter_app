import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart';
import '../screens/AddressSelectionScreen.dart' as AddressSelectionScreenAlias;
import '../models/address.dart';

class OrderConfirmationScreen extends StatefulWidget {
  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  Address? selectedAddress;
  String? selectedPaymentMethod;

  void _selectAddress() async {
    final result = await showModalBottomSheet<Address>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => AddressSelectionScreenAlias.AddressSelectionScreen(),
    );

    if (result != null) {
      setState(() {
        selectedAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    const deliveryFee = 15000;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Xác nhận đơn hàng",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GIAO HÀNG
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "GIAO HÀNG",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: _selectAddress,
                    child: Text(
                      "Thay đổi",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // ĐỊA CHỈ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Địa chỉ nhận hàng",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    if (selectedAddress == null)
                      Text(
                        "Vui lòng chọn địa chỉ nhận hàng",
                        style: TextStyle(color: Colors.red),
                      )
                    else ...[
                      Text(
                        selectedAddress!.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        selectedAddress!.phoneNumber ??
                            "Số điện thoại không khả dụng",
                      ),
                      Text(selectedAddress!.detail),
                    ],
                    SizedBox(height: 4),
                    Text(
                      "Thêm hướng dẫn giao hàng",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            // CỬA HÀNG
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cửa hàng giao hàng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_drop_down, color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Không có cửa hàng gần địa chỉ đã chọn",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // TÓM TẮT ĐƠN HÀNG
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tóm tắt đơn hàng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Thêm", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Lưu ý: Ứng dụng chưa thể đáp ứng đơn hàng >12 ly. Vui lòng liên hệ Hotline hoặc Fanpage để đặt Big Order.",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),

            // DANH SÁCH SẢN PHẨM
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                String productId = cart.items.keys.elementAt(index);
                CartItem item = cart.items[productId]!;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF7F9FB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(item.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Đá vừa, Không topping",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "${item.price.toStringAsFixed(0)}đ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "218,000đ",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // SỐ LƯỢNG + EDIT
                      Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  cart.updateQuantity(
                                    productId,
                                    item.quantity - 1,
                                  );
                                },
                              ),
                              Text("${item.quantity}"),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  cart.addToCart(
                                    item.productId,
                                    item.title,
                                    item.price,
                                    item.image,
                                  );
                                },
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              // TODO: Chỉnh sửa sản phẩm
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            // PHƯƠNG THỨC THANH TOÁN
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "Phương thức thanh toán",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // TIỀN MẶT - Đưa lên đầu
                  RadioListTile<String>(
                    value: "Tiền mặt",
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    title: Text("Tiền mặt khi nhận hàng"),
                    secondary: Image.asset(
                      'assets/images/tienmat.jpg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  // ZALOPAY
                  RadioListTile<String>(
                    value: "ZaloPay",
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    title: Text("Ví ZaloPay"),
                    secondary: Image.asset(
                      'assets/images/zalo.jpg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  // MOMO
                  RadioListTile<String>(
                    value: "MoMo",
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    title: Text("Ví MoMo"),
                    secondary: Image.asset(
                      'assets/images/momo.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  // ATM
                  RadioListTile<String>(
                    value: "ATM",
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    title: Text("Thẻ ATM / Tài khoản ngân hàng"),
                    secondary: Image.asset(
                      'assets/images/atm.jpg',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  // VISA / MASTER / JCB
                  RadioListTile<String>(
                    value: "Visa/Master/JCB",
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                    title: Text("Thẻ thanh toán quốc tế (Visa, Master, JCB)"),
                    secondary: Image.asset(
                      'assets/images/visa.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
            ),

            // TỔNG CỘNG - THANH TOÁN
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tổng cộng (${cart.totalItems} món)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E2D3D),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Thành tiền",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "${cart.totalPrice.toStringAsFixed(0)}đ",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phí giao hàng",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "$deliveryFeeđ",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Số tiền thanh toán",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2D3D),
                          ),
                        ),
                        Text(
                          "${(cart.totalPrice + deliveryFee).toStringAsFixed(0)}đ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E2D3D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Đã bao gồm thuế",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Chức năng xuất hóa đơn VAT chưa khả dụng",
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Yêu cầu xuất hóa đơn VAT",
                        style: TextStyle(
                          color: Color(0xFFB48C5E),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // FOOTER - NÚT ĐẶT HÀNG
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${cart.totalItems} sản phẩm"),
                      Text(
                        "${(cart.totalPrice + deliveryFee).toStringAsFixed(0)}đ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đặt hàng thành công!")),
                      );
                      cart.clearCart();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC49B6C),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Đặt hàng",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
