<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminMenuController;
use App\Http\Controllers\Admin\AdminOrderController;
use App\Http\Controllers\Admin\AdminReportController;

Route::get('/', function () {
    return view('welcome');
});

// Admin Panel & Kitchen Display System Routes
Route::prefix('admin')->group(function () {
    Route::get('/', function () {
        return redirect()->route('admin.orders.index');
    });

    // Kitchen Display & Order Monitor
    Route::get('/orders', [AdminOrderController::class, 'index'])->name('admin.orders.index');
    Route::post('/orders/{id}/status', [AdminOrderController::class, 'updateStatus'])->name('admin.orders.update-status');

    // Menu Management & Stock Toggle
    Route::get('/menus', [AdminMenuController::class, 'index'])->name('admin.menus.index');
    Route::post('/menus', [AdminMenuController::class, 'store'])->name('admin.menus.store');
    Route::post('/menus/{id}/toggle-stock', [AdminMenuController::class, 'toggleStock'])->name('admin.menus.toggle-stock');

    // Reports & Sales Analytics
    Route::get('/reports', [AdminReportController::class, 'index'])->name('admin.reports.index');
});
