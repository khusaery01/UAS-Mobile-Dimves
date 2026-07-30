import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../services/api_service.dart';
import '../main/main_page.dart';
import '../auth/login_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController tableController = TextEditingController();
  final TextEditingController voucherController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String paymentMethod = "Cash"; // Cash/COD, QRIS, Transfer
  String orderType = "delivery"; // dine_in, takeaway, delivery

  bool isLoading = false;
  bool isCheckingVoucher = false;
  String? voucherMessage;

  @override
  void initState() {
    super.initState();
    addressController.text = "Jl. Kedai Dimves No. 12, Outlet Utama";
  }

  Future<void> checkVoucher() async {
    final code = voucherController.text.trim();
    if (code.isEmpty) return;

    final cart = context.read<CartProvider>();

    setState(() {
      isCheckingVoucher = true;
      voucherMessage = null;
    });

    final res = await ApiService().checkVoucher(code, cart.subtotalPrice);

    setState(() {
      isCheckingVoucher = false;
    });

    if (res["success"] == true) {
      cart.applyVoucher(code.toUpperCase(), res["discount_amount"]);
      setState(() {
        voucherMessage = "Voucher berhasil dipasang! Diskon: Rp ${res["discount_amount"]}";
      });
    } else {
      cart.removeVoucher();
      setState(() {
        voucherMessage = res["message"] ?? "Voucher tidak valid";
      });
    }
  }

  Future<void> checkout() async {
    final cart = context.read<CartProvider>();

    final loggedIn = await ApiService().isLoggedIn();
    if (!loggedIn) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    if (orderType == "delivery" && addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Alamat pengiriman wajib diisi untuk delivery")),
      );
      return;
    }

    if (orderType == "dine_in" && tableController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor meja wajib diisi untuk Dine-In")),
      );
      return;
    }

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Keranjang masih kosong")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> items = cart.items.map((e) {
      List<Map<String, dynamic>> variants = e.selectedVariants.map((v) => {
        "variant_id": v.variant.id,
        "option_id": v.option.id,
      }).toList();

      return {
        "menu_id": e.menu.id,
        "quantity": e.quantity,
        "price": e.unitPrice,
        "note": e.note,
        "variants": variants,
      };
    }).toList();

    final res = await ApiService().checkout(
      paymentMethod: paymentMethod,
      shippingAddress: addressController.text.trim(),
      orderType: orderType,
      tableNumber: tableController.text.trim(),
      voucherCode: cart.voucherCode,
      deliveryFee: cart.deliveryFee,
      notes: noteController.text.trim(),
      items: items,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (res["success"] == true) {
      cart.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(res["message"] ?? "Pesanan berhasil dibuat!"),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(res["message"] ?? "Checkout gagal"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    final subtotal = cart.subtotalPrice;
    final discount = cart.discountAmount;
    final deliveryFee = orderType == "delivery" ? 10000.0 : 0.0;
    final grandTotal = (subtotal - discount + deliveryFee) > 0
        ? (subtotal - discount + deliveryFee)
        : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipe Pesanan (Dine-in, Takeaway, Delivery)
            const Text(
              "Tipe Pesanan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text("Pesan Antar\n(Delivery)", textAlign: TextAlign.center),
                    selected: orderType == "delivery",
                    selectedColor: const Color(0xFFE53935),
                    labelStyle: TextStyle(
                      color: orderType == "delivery" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => orderType = "delivery");
                        cart.setOrderType("delivery");
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text("Dine-In\n(Scan Meja)", textAlign: TextAlign.center),
                    selected: orderType == "dine_in",
                    selectedColor: const Color(0xFFE53935),
                    labelStyle: TextStyle(
                      color: orderType == "dine_in" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => orderType = "dine_in");
                        cart.setOrderType("dine_in");
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text("Takeaway\n(Bawa Pulang)", textAlign: TextAlign.center),
                    selected: orderType == "takeaway",
                    selectedColor: const Color(0xFFE53935),
                    labelStyle: TextStyle(
                      color: orderType == "takeaway" ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() => orderType = "takeaway");
                        cart.setOrderType("takeaway");
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Input No Meja jika Dine-In
            if (orderType == "dine_in") ...[
              const Text(
                "Nomor Meja",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: tableController,
                decoration: InputDecoration(
                  hintText: "Masukkan Nomor Meja (Contoh: A04)",
                  prefixIcon: const Icon(Icons.table_restaurant),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Input Alamat jika Delivery
            if (orderType == "delivery") ...[
              const Text(
                "Alamat Pengiriman",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Masukkan alamat lengkap...",
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Voucher & Promo Input
            const Text(
              "Voucher Diskon",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: voucherController,
                    decoration: InputDecoration(
                      hintText: "Kode Voucher (Contoh: DIMVES50)",
                      prefixIcon: const Icon(Icons.local_offer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: isCheckingVoucher ? null : checkVoucher,
                  child: isCheckingVoucher
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Pasang"),
                ),
              ],
            ),
            if (voucherMessage != null) ...[
              const SizedBox(height: 6),
              Text(
                voucherMessage!,
                style: TextStyle(
                  color: cart.voucherCode != null ? Colors.green : Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Metode Pembayaran (Cash, QRIS, Transfer)
            const Text(
              "Metode Pembayaran",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              value: "Cash",
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value!),
              title: const Text("Tunai / COD (Kasir / Bayar di Tempat)"),
            ),
            RadioListTile(
              value: "QRIS",
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value!),
              title: const Text("QRIS (Scan QR Code Kasir)"),
            ),

            // Tampilkan QR image saat QRIS dipilih
            if (paymentMethod == "QRIS") ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE53935), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Scan QR Berikut untuk Pembayaran",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/qr.jpeg',
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tunjukkan bukti pembayaran kepada kasir",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            RadioListTile(
              value: "Transfer",
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value!),
              title: const Text("Transfer Bank"),
            ),
            const SizedBox(height: 20),

            // Catatan Pesanan
            const Text(
              "Catatan Pesanan Khusus",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: "Contoh: Posisikan pesanan dekat gerbang...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subtotal Menu"),
                        Text("Rp ${subtotal.toStringAsFixed(0)}"),
                      ],
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Diskon Voucher", style: TextStyle(color: Colors.green)),
                          Text("- Rp ${discount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Ongkos Kirim"),
                        Text(orderType == "delivery" ? "Rp ${deliveryFee.toStringAsFixed(0)}" : "GRATIS"),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Bayar",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          "Rp ${grandTotal.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: isLoading ? null : checkout,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Buat Pesanan Sekarang",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
