import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HistoryController extends ChangeNotifier {
  List<dynamic> platforms = [];
  bool isLoading = false;
  String? errorMessage;

  /// Lấy danh sách platforms từ API
  Future<void> fetchPlatforms() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Thử đổi thành https:// nếu server của bạn bắt buộc dùng HTTPS
      final url = Uri.parse('http://10.0.2.2/api/c/platforms'); 
      
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'PostmanRuntime/7.32.3', 
          'Host': 'acme.com',
        },
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        
        // Xử lý dữ liệu trả về tùy thuộc vào cấu trúc JSON của API
        if (decodedData is List) {
           platforms = decodedData;
        } else if (decodedData is Map<String, dynamic>) {
           if (decodedData.containsKey('data') && decodedData['data'] is List) {
             platforms = decodedData['data'];
           } else {
             platforms = [decodedData];
           }
        }
      } else {
        // In ra thêm nội dung response.body để biết server đang báo lỗi cụ thể là gì
        errorMessage = 'Lỗi máy chủ: Mã trạng thái ${response.statusCode}\nChi tiết: ${response.body}';
      }
    } catch (e) {
      errorMessage = 'Có lỗi xảy ra trong quá trình kết nối: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
