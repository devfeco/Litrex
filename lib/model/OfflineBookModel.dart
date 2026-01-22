class OfflineBook {
  final String id;
  final String filePath; // Local encrypted file path
  final String downloadDate;

  OfflineBook({
    required this.id,
    required this.filePath,
    required this.downloadDate,
  });

  factory OfflineBook.fromJson(Map<String, dynamic> json) {
    return OfflineBook(
      id: json['id'],
      filePath: json['file_path'],
      downloadDate: json['download_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_path': filePath,
      'download_date': downloadDate,
    };
  }
}
