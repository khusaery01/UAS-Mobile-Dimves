@extends('admin.layouts.app')

@section('title', 'Kelola Menu & Stok')

@section('content')
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="fa-solid fa-book-open text-danger me-2"></i>Kelola Menu & Stok</h3>
        <p class="text-muted mb-0">Tambah menu baru, atur varian, dan toggle status ketersediaan stok.</p>
    </div>
    <button type="button" class="btn btn-danger fw-bold" data-bs-toggle="modal" data-bs-target="#addMenuModal">
        <i class="fa-solid fa-plus me-1"></i> Tambah Menu Baru
    </button>
</div>

<div class="card card-order">
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Menu</th>
                        <th>Kategori</th>
                        <th>Harga</th>
                        <th>Stok</th>
                        <th>Status Stok</th>
                        <th class="text-end pe-4">Aksi Toggle Stok</th>
                    </tr>
                </thead>
                <tbody>
                    @foreach($menus as $menu)
                    <tr>
                        <td class="ps-4">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-light rounded p-2 text-center" style="width:45px; height:45px;">
                                    <i class="fa-solid fa-utensils text-danger fs-5"></i>
                                </div>
                                <div>
                                    <strong class="d-block">{{ $menu->name }}</strong>
                                    <small class="text-muted">{{ Str::limit($menu->description, 40) }}</small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <span class="badge bg-secondary">{{ $menu->category->name ?? '-' }}</span>
                        </td>
                        <td class="fw-bold text-danger">
                            Rp {{ number_format($menu->price, 0, ',', '.') }}
                        </td>
                        <td>
                            <span class="fw-bold fs-6 {{ $menu->stock > 0 ? 'text-dark' : 'text-danger' }}">
                                {{ $menu->stock }} pcs
                            </span>
                        </td>
                        <td>
                            @if($menu->status && $menu->stock > 0)
                                <span class="badge bg-success rounded-pill px-3">Tersedia</span>
                            @else
                                <span class="badge bg-danger rounded-pill px-3">HABIS (Out of Stock)</span>
                            @endif
                        </td>
                        <td class="text-end pe-4">
                            <form action="{{ route('admin.menus.toggle-stock', $menu->id) }}" method="POST" class="d-inline">
                                @csrf
                                <button type="submit" class="btn btn-sm {{ $menu->status ? 'btn-outline-danger' : 'btn-success' }} fw-bold">
                                    @if($menu->status)
                                        <i class="fa-solid fa-ban me-1"></i> Set Habis
                                    @else
                                        <i class="fa-solid fa-check me-1"></i> Set Tersedia
                                    @endif
                                </button>
                            </form>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal Tambah Menu -->
<div class="modal fade" id="addMenuModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="{{ route('admin.menus.store') }}" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tambah Menu Baru</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Kategori</label>
                        <select name="category_id" class="form-select" required>
                            @foreach($categories as $cat)
                                <option value="{{ $cat->id }}">{{ $cat->name }}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Nama Menu</label>
                        <input type="text" name="name" class="form-control" required placeholder="misal: Dimsum Ayam Mozzarella">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Deskripsi</label>
                        <textarea name="description" class="form-control" rows="2" placeholder="Deskripsi singkat menu..."></textarea>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Harga (Rp)</label>
                            <input type="number" name="price" class="form-control" required placeholder="15000">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Stok Awal</label>
                            <input type="number" name="stock" class="form-control" required value="50">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-danger fw-bold">Simpan Menu</button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection
