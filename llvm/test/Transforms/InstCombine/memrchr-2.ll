; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
;
; Verify that memrchr calls with an out of bounds size are folded to null.

declare i8* @memrchr(i8*, i32, i64)

@ax = external global [0 x i8]
@ax1 = external global [1 x i8]
@a12345 = constant [5 x i8] c"\01\02\03\04\05"


; Fold memrchr(a12345, 1, UINT32_MAX + 1LU) to null (and not to a12345
; as might happen if the size were to be truncated to int32_t).

define i8* @fold_memrchr_a12345_1_ui32max_p1(i32 %0) {
; CHECK-LABEL: @fold_memrchr_a12345_1_ui32max_p1(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 [[TMP0:%.*]], i64 4294967296)
; CHECK-NEXT:    ret i8* [[RET]]
;
; CHECK   :      ret i8* null

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i64 0, i64 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %0, i64 4294967296)
  ret i8* %ret
}


; Fold memrchr(ax1, 1, UINT32_MAX + 2LU) to null (and not to *ax1 == 1).

define i8* @fold_memrchr_ax1_1_ui32max_p2(i32 %0) {
; CHECK-LABEL: @fold_memrchr_ax1_1_ui32max_p2(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([1 x i8], [1 x i8]* @ax1, i64 0, i64 0), i32 [[TMP0:%.*]], i64 4294967297)
; CHECK-NEXT:    ret i8* [[RET]]
;
; CHECK   :      ret i8* null

  %ptr = getelementptr [1 x i8], [1 x i8]* @ax1, i64 0, i64 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %0, i64 4294967297)
  ret i8* %ret
}


; But don't fold memrchr(ax, 1, UINT32_MAX + 2LU) to *ax == 1.

define i8* @fold_memrchr_ax_1_ui32max_p2(i32 %0) {
; CHECK-LABEL: @fold_memrchr_ax_1_ui32max_p2(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 [[TMP0:%.*]], i64 4294967297)
; CHECK-NEXT:    ret i8* [[RET]]
;

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i64 0, i64 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %0, i64 4294967297)
  ret i8* %ret
}


; Fold memrchr(a12345, c, 6) to null.

define i8* @fold_memrchr_a12345_c_6(i32 %0) {
; CHECK-LABEL: @fold_memrchr_a12345_c_6(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 [[TMP0:%.*]], i64 6)
; CHECK-NEXT:    ret i8* [[RET]]
;
; CHECK   :      ret i8* null

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i64 0, i64 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %0, i64 6)
  ret i8* %ret
}


; Fold memrchr(a12345, c, SIZE_MAX) to null.

define i8* @fold_memrchr_a12345_c_szmax(i32 %0) {
; CHECK-LABEL: @fold_memrchr_a12345_c_szmax(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @memrchr(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @a12345, i64 0, i64 0), i32 [[TMP0:%.*]], i64 -1)
; CHECK-NEXT:    ret i8* [[RET]]
;
; CHECK   :      ret i8* null

  %ptr = getelementptr [5 x i8], [5 x i8]* @a12345, i64 0, i64 0
  %ret = call i8* @memrchr(i8* %ptr, i32 %0, i64 18446744073709551615)
  ret i8* %ret
}
