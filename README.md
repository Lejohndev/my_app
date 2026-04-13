Cấu trúc dự án Flutter 

lib/
├── core/                       # 1. CỐT LÕI (Dùng chung toàn hệ thống)
│   ├── constants/              # AppColors, AppTextStyles, ApiEndpoints
│   ├── network/                # ApiClient (Cấu hình Dio/http, tự động gắn JWT Token, hứng lỗi 401)
│   └── utils/                  # Helper (Format ngày tháng, ép kiểu, xử lý quyền Camera)
│
├── shared/                     # 2. GIAO DIỆN CHUNG (Tái sử dụng)
│   └── widgets/                # CustomButton, CustomTextField, LoadingOverlay, ErrorDialog
│
├── features/                   # 3. TÍNH NĂNG CHÍNH (Phân chia công việc tại đây)
│   │
│   ├── auth/                   # Tương ứng với AuthController (Backend)
│   │   ├── models/             # UserModel, LoginResponse
│   │   ├── screens/            # LoginScreen, RegisterScreen
│   │   └── controllers/        # AuthController (Gọi API, lưu Token vào FlutterSecureStorage)
│   │
│   ├── design_studio/          # Tương ứng với DesignController (Backend)
│   │   ├── models/             # DesignRequest, DesignResult
│   │   ├── screens/            # UploadPhotoScreen, ProcessingScreen, ResultScreen (Before/After)
│   │   ├── widgets/            # ImageSliderBeforeAfter (Component đặc thù cho tính năng này)
│   │   └── controllers/        # DesignController (Xử lý upload, gọi API tạo thiết kế, Short-polling)
│   │
│   └── project_history/        # Tương ứng với việc GET dữ liệu từ DB
│       ├── screens/            # HistoryScreen, ProjectDetailScreen
│       └── controllers/        # HistoryController (Quản lý danh sách các bản thiết kế cũ)
│
├── routes/                     # 4. QUẢN LÝ ĐIỀU HƯỚNG
│   └── app_routes.dart         # Cấu hình GoRouter hoặc GetX Routes
│
└── main.dart                   # Entry point (Khởi tạo App, cấu hình Theme)