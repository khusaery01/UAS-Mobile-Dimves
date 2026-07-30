@extends('admin.layouts.app')

@section('title', 'Laporan Omzet & Penjualan')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="fa-solid fa-chart-line text-danger me-2"></i>Laporan Rekap Omzet</h3>
        <p class="text-muted mb-0">Statistik omzet penjualan dan menu terlaris resto DIMVES.</p>
    </div>
</div>

<!-- Filter Tanggal -->
<div class="card card-order mb-4">
    <div class="card-body">
        <form action="{{ route('admin.reports.index') }}" method="GET" class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label fw-bold">Dari Tanggal</label>
                <input type="date" name="start_date" class="form-control" value="{{ $startDate }}">
            </div>
            <div class="col-md-4">
                <label class="form-label fw-bold">Sampai Tanggal</label>
                <input type="date" name="end_date" class="form-control" value="{{ $endDate }}">
            </div>
            <div class="col-md-4">
                <button type="submit" class="btn btn-danger w-100 fw-bold">
                    <i class="fa-solid fa-filter me-1"></i> Filter Laporan
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Summary Cards -->
<div class="row g-3 mb-4">
    <div class="col-md-6">
        <div class="card card-order bg-primary text-white p-3">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-white-50 text-uppercase fw-bold mb-1">Total Omzet Penjualan</h6>
                    <h2 class="fw-bold mb-0">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</h2>
                </div>
                <i class="fa-solid fa-wallet fs-1 text-white-50"></i>
            </div>
        </div>
    </div>
    <div class="col-md-6">
        <div class="card card-order bg-success text-white p-3">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="text-white-50 text-uppercase fw-bold mb-1">Total Pesanan Sukses</h6>
                    <h2 class="fw-bold mb-0">{{ $totalOrders }} Pesanan</h2>
                </div>
                <i class="fa-solid fa-receipt fs-1 text-white-50"></i>
            </div>
        </div>
    </div>
</div>

<!-- Top Menu Table -->
<div class="card card-order">
    <div class="card-header bg-white pt-3 border-0">
        <h5 class="fw-bold mb-0"><i class="fa-solid fa-crown text-warning me-2"></i>Top 5 Menu Terlaris</h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">No</th>
                        <th>Nama Menu</th>
                        <th>Kategori</th>
                        <th>Jumlah Terjual</th>
                        <th class="text-end pe-4">Total Pendapatan</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($topMenus as $index => $item)
                    <tr>
                        <td class="ps-4 fw-bold">{{ $index + 1 }}</td>
                        <td class="fw-bold">{{ $item->menu->name ?? 'Menu' }}</td>
                        <td><span class="badge bg-secondary">{{ $item->menu->category->name ?? '-' }}</span></td>
                        <td><span class="badge bg-danger rounded-pill px-3">{{ $item->total_sold }} porsi</span></td>
                        <td class="text-end pe-4 fw-bold text-success">
                            Rp {{ number_format($item->total_amount, 0, ',', '.') }}
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="text-center py-4 text-muted">Belum ada data penjualan pada periode ini.</td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</div>
@endsection
