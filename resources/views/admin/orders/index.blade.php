@extends('admin.layouts.app')

@section('title', 'Layar Dapur - Real-time Order')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="fa-solid fa-fire text-danger me-2"></i>Layar Pesanan Dapur</h3>
        <p class="text-muted mb-0">Monitor pesanan masuk real-time dan ubah status memasak.</p>
    </div>
    <div class="d-flex align-items-center gap-2">
        <span class="text-muted fs-7"><i class="fa-solid fa-sync fa-spin text-primary me-1"></i>Auto-Refresh 5 detik</span>
    </div>
</div>

<div class="row g-3">
    @forelse($orders as $order)
    <div class="col-md-6 col-lg-4">
        <div class="card card-order h-100 border-start border-4 
            @if($order->kitchen_status == 'waiting') border-warning 
            @elseif($order->kitchen_status == 'preparing') border-primary 
            @elseif($order->kitchen_status == 'ready') border-success 
            @else border-secondary @endif">
            <div class="card-header bg-white border-0 pt-3 d-flex justify-content-between align-items-center">
                <div>
                    <span class="fw-bold text-dark fs-5">#{{ $order->order_code }}</span>
                    <span class="badge bg-light text-dark ms-2">{{ strtoupper($order->order_type) }}</span>
                    @if($order->table_number)
                        <span class="badge bg-danger ms-1">Meja {{ $order->table_number }}</span>
                    @endif
                </div>
                <small class="text-muted">{{ $order->created_at->diffForHumans() }}</small>
            </div>
            <div class="card-body py-2">
                <div class="mb-2">
                    <span class="text-muted small">Customer:</span> <strong>{{ $order->user->name ?? 'Guest' }}</strong>
                </div>

                <hr class="my-2">
                <ul class="list-group list-group-flush mb-3">
                    @foreach($order->items as $item)
                    <li class="list-group-item px-0 py-2 bg-transparent">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong class="fs-6">{{ $item->quantity }}x {{ $item->menu->name ?? 'Menu' }}</strong>
                                @if($item->variants && count($item->variants) > 0)
                                    <div class="small text-danger ms-2">
                                        @foreach($item->variants as $var)
                                            • {{ $var->variant_name }}: <strong>{{ $var->option_name }}</strong><br>
                                        @endforeach
                                    </div>
                                @endif
                                @if($item->note)
                                    <div class="small text-muted fst-italic ms-2">Catatan: "{{ $item->note }}"</div>
                                @endif
                            </div>
                            <span class="fw-bold">Rp {{ number_format($item->subtotal, 0, ',', '.') }}</span>
                        </div>
                    </li>
                    @endforeach
                </ul>

                @if($order->notes)
                    <div class="alert alert-warning py-1 px-2 small mb-3">
                        <i class="fa-solid fa-comment-dots me-1"></i> <strong>Note Order:</strong> {{ $order->notes }}
                    </div>
                @endif

                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span class="text-muted">Metode Pembayaran:</span>
                    <span class="badge bg-info text-dark">{{ $order->payment_method }}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <span class="fw-bold">Total Pembayaran:</span>
                    <span class="fw-bold fs-5 text-danger">Rp {{ number_format($order->grand_total > 0 ? $order->grand_total : $order->total_price, 0, ',', '.') }}</span>
                </div>
            </div>
            <div class="card-footer bg-light border-0 pb-3">
                <form action="{{ route('admin.orders.update-status', $order->id) }}" method="POST" class="d-flex gap-2">
                    @csrf
                    @if($order->kitchen_status == 'waiting')
                        <button type="submit" name="kitchen_status" value="preparing" class="btn btn-primary btn-sm flex-fill fw-bold">
                            <i class="fa-solid fa-fire me-1"></i> Mulai Dimasak
                        </button>
                    @elseif($order->kitchen_status == 'preparing')
                        <button type="submit" name="kitchen_status" value="ready" class="btn btn-warning btn-sm flex-fill fw-bold text-dark">
                            <i class="fa-solid fa-bell me-1"></i> Siap Disajikan
                        </button>
                    @elseif($order->kitchen_status == 'ready')
                        <button type="submit" name="kitchen_status" value="served" class="btn btn-success btn-sm flex-fill fw-bold">
                            <i class="fa-solid fa-circle-check me-1"></i> Selesai / Disajikan
                        </button>
                    @else
                        <button type="button" class="btn btn-secondary btn-sm flex-fill disabled">
                            <i class="fa-solid fa-check-double me-1"></i> Selesai
                        </button>
                    @endif

                    <button type="submit" name="status" value="Dibatalkan" class="btn btn-outline-danger btn-sm" onclick="return confirm('Yakin batalkan pesanan?')">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
    @empty
    <div class="col-12 text-center py-5">
        <i class="fa-solid fa-utensils fs-1 text-muted mb-3 d-block"></i>
        <h5 class="text-muted">Belum ada pesanan masuk.</h5>
    </div>
    @endforelse
</div>

<div class="d-flex justify-content-center mt-4">
    {{ $orders->links() }}
</div>
@endsection

@section('scripts')
<script>
    // Auto-refresh layar dapur setiap 10 detik agar realtime
    setTimeout(function() {
        window.location.reload();
    }, 10000);
</script>
@endsection
