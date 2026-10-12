abstract class IBaseRepository {}

/// Raw row returned by mock repositories (giống body JSON của API). Service
/// map sang model bằng `fromJson` sau khi thêm các field theo người xem.
typedef JsonMap = Map<String, dynamic>;
