import 'dart:async';
import 'package:flutter/material.dart';

import '../../models/order_detail_model.dart';
import '../../services/api_service.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late Future<OrderDetailModel> orderFuture;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetail();
    // Real-time Polling: cek status pesanan tiap 5 detik
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _fetchOrderDetail();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _fetchOrderDetail() {
    setState(() {
      orderFuture = ApiService().getOrderDetail(widget.orderId);
    });
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
      case "menunggu":
        return Colors.orange;
      case "diproses":
      case "process":
      case "preparing":
        return Colors.blue;
      case "selesai":
      case "completed":
      case "ready":
      case "served":
        return Colors.green;
      case "dibatalkan":
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getKitchenStepText(String kitchenStatus) {
    switch (kitchenStatus.toLowerCase()) {
      case "waiting":
        return "Pesanan diterima, menunggu giliran dimasak...";
      case "preparing":
        return "Sedang dimasak di dapur restourant! 🍳";
      case "ready":
        return "Pesanan siap disajikan / diambil! 🛎️";
      case "served":
        return "Pesanan sudah selesai disajikan. Nikmati santapanmu! ✨";
      default:
        return "Memproses pesanan...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail & Tracking Pesanan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchOrderDetail,
          ),
        ],
      ),
      body: FutureBuilder<OrderDetailModel>(
        future: orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Real-time Status Banner Card
                Card(
                  elevation: 2,
                  color: Colors.red.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE53935),
                          child: Icon(Icons.outdoor_grill, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Status Dapur: ${data.kitchenStatus.toUpperCase()}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE53935)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                getKitchenStepText(data.kitchenStatus),
                                style: const TextStyle(fontSize: 13, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Main Info Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.orderCode,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor(data.status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data.status,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Text("Tipe Pesanan : ${data.orderType.toUpperCase()}"),
                        if (data.tableNumber != null)
                          Text("Nomor Meja : Meja ${data.tableNumber}"),
                        Text("Tanggal : ${data.createdAt.length >= 10 ? data.createdAt.substring(0, 10) : data.createdAt}"),
                        Text("Metode Pembayaran : ${data.paymentMethod}"),
                        Text("Alamat / Keterangan : ${data.shippingAddress}"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Daftar Menu Dipesan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ...data.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 18,
                                backgroundColor: Color(0xFFE53935),
                                child: Icon(Icons.restaurant, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Text(
                                      "${item.quantity}x @ Rp ${item.price.toStringAsFixed(0)}",
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "Rp ${item.subtotal.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFE53935),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          if (item.variants.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              children: item.variants
                                  .map((v) => Chip(
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: Colors.orange.shade50,
                                        label: Text(
                                          "${v.variantName}: ${v.optionName}",
                                          style: const TextStyle(fontSize: 11, color: Colors.deepOrange),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                          if (item.note != null && item.note!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              "Catatan: \"${item.note}\"",
                              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Financial Breakdown
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Subtotal"),
                            Text("Rp ${data.totalPrice.toStringAsFixed(0)}"),
                          ],
                        ),
                        if (data.discountAmount > 0) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Diskon Voucher", style: TextStyle(color: Colors.green)),
                              Text("- Rp ${data.discountAmount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Ongkos Kirim"),
                            Text("Rp ${data.deliveryFee.toStringAsFixed(0)}"),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "Rp ${data.grandTotal.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
