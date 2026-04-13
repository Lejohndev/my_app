# Cấu trúc dự án Flutter

## Thư mục chính (`lib/`)

### 1. **Core** - CỐT LÕI (Dùng chung toàn hệ thống)

- **constants/** - AppColors, AppTextStyles, ApiEndpoints
- **network/** - ApiClient (Cấu hình Dio/http, tự động gắn JWT Token, hứng lỗi 401)
- **utils/** - Helper (Format ngày tháng, ép kiểu, xử lý quyền Camera)

### 2. **Shared** - GIAO DIỆN CHUNG (Tái sử dụng)

- **widgets/** - CustomButton, CustomTextField, LoadingOverlay, ErrorDialog

### 3. **Features** - TÍNH NĂNG CHÍNH (Phân chia công việc)

#### 3.1 Auth

- **models/** - UserModel, LoginResponse
- **screens/** - LoginScreen, RegisterScreen
- **controllers/** - AuthController (Gọi API, lưu Token vào FlutterSecureStorage)

Tương ứng với AuthController (Backend)

#### 3.2 Design Studio

- **models/** - DesignRequest, DesignResult
- **screens/** - UploadPhotoScreen, ProcessingScreen, ResultScreen (Before/After)
- **widgets/** - ImageSliderBeforeAfter (Component đặc thù cho tính năng này)
- **controllers/** - DesignController (Xử lý upload, gọi API tạo thiết kế, Short-polling)

Tương ứng với DesignController (Backend)

#### 3.3 Project History

- **screens/** - HistoryScreen, ProjectDetailScreen
- **controllers/** - HistoryController (Quản lý danh sách các bản thiết kế cũ)

Tương ứng với việc GET dữ liệu từ DB

### 4. **Routes** - QUẢN LÝ ĐIỀU HƯỚNG

- **app_routes.dart** - Cấu hình GoRouter hoặc GetX Routes

### 5. **Main Entry Point**

- **main.dart** - Khởi tạo App, cấu hình Theme
