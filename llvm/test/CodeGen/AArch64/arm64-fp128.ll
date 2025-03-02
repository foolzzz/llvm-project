; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64-linux-gnu -verify-machineinstrs -mcpu=cyclone -aarch64-enable-atomic-cfg-tidy=0 < %s | FileCheck -enable-var-scope %s

@lhs = dso_local global fp128 zeroinitializer, align 16
@rhs = dso_local global fp128 zeroinitializer, align 16

define fp128 @test_add() {
; CHECK-LABEL: test_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    b __addtf3

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fadd fp128 %lhs, %rhs
  ret fp128 %val
}

define fp128 @test_sub() {
; CHECK-LABEL: test_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    b __subtf3

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fsub fp128 %lhs, %rhs
  ret fp128 %val
}

define fp128 @test_mul() {
; CHECK-LABEL: test_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    b __multf3

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fmul fp128 %lhs, %rhs
  ret fp128 %val
}

define fp128 @test_div() {
; CHECK-LABEL: test_div:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    b __divtf3

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fdiv fp128 %lhs, %rhs
  ret fp128 %val
}

@var32 = dso_local global i32 0
@var64 = dso_local global i64 0

define dso_local void @test_fptosi() {
; CHECK-LABEL: test_fptosi:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl __fixtfsi
; CHECK-NEXT:    adrp x8, var32
; CHECK-NEXT:    str w0, [x8, :lo12:var32]
; CHECK-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    bl __fixtfdi
; CHECK-NEXT:    adrp x8, var64
; CHECK-NEXT:    str x0, [x8, :lo12:var64]
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret
  %val = load fp128, fp128* @lhs, align 16

  %val32 = fptosi fp128 %val to i32
  store i32 %val32, i32* @var32

  %val64 = fptosi fp128 %val to i64
  store i64 %val64, i64* @var64

  ret void
}

define dso_local void @test_fptoui() {
; CHECK-LABEL: test_fptoui:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl __fixunstfsi
; CHECK-NEXT:    adrp x8, var32
; CHECK-NEXT:    str w0, [x8, :lo12:var32]
; CHECK-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    bl __fixunstfdi
; CHECK-NEXT:    adrp x8, var64
; CHECK-NEXT:    str x0, [x8, :lo12:var64]
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret
  %val = load fp128, fp128* @lhs, align 16

  %val32 = fptoui fp128 %val to i32
  store i32 %val32, i32* @var32

  %val64 = fptoui fp128 %val to i64
  store i64 %val64, i64* @var64

  ret void
}

define dso_local void @test_sitofp() {
; CHECK-LABEL: test_sitofp:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, var32
; CHECK-NEXT:    ldr w0, [x8, :lo12:var32]
; CHECK-NEXT:    bl __floatsitf
; CHECK-NEXT:    adrp x19, lhs
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    adrp x8, var64
; CHECK-NEXT:    ldr x0, [x8, :lo12:var64]
; CHECK-NEXT:    bl __floatditf
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret

  %src32 = load i32, i32* @var32
  %val32 = sitofp i32 %src32 to fp128
  store volatile fp128 %val32, fp128* @lhs

  %src64 = load i64, i64* @var64
  %val64 = sitofp i64 %src64 to fp128
  store volatile fp128 %val64, fp128* @lhs

  ret void
}

define dso_local void @test_uitofp() {
; CHECK-LABEL: test_uitofp:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, var32
; CHECK-NEXT:    ldr w0, [x8, :lo12:var32]
; CHECK-NEXT:    bl __floatunsitf
; CHECK-NEXT:    adrp x19, lhs
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    adrp x8, var64
; CHECK-NEXT:    ldr x0, [x8, :lo12:var64]
; CHECK-NEXT:    bl __floatunditf
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret

  %src32 = load i32, i32* @var32
  %val32 = uitofp i32 %src32 to fp128
  store volatile fp128 %val32, fp128* @lhs

  %src64 = load i64, i64* @var64
  %val64 = uitofp i64 %src64 to fp128
  store volatile fp128 %val64, fp128* @lhs

  ret void
}

define dso_local i1 @test_setcc1() {
; CHECK-LABEL: test_setcc1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    bl __letf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cset w0, le
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

; Technically, everything after the call to __letf2 is redundant, but we'll let
; LLVM have its fun for now.
  %val = fcmp ole fp128 %lhs, %rhs

  ret i1 %val
}

define dso_local i1 @test_setcc2() {
; CHECK-LABEL: test_setcc2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    bl __letf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    cset w0, gt
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fcmp ugt fp128 %lhs, %rhs

  ret i1 %val
}

define dso_local i1 @test_setcc3() {
; CHECK-LABEL: test_setcc3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #48
; CHECK-NEXT:    .cfi_def_cfa_offset 48
; CHECK-NEXT:    stp x30, x19, [sp, #32] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    stp q1, q0, [sp] // 32-byte Folded Spill
; CHECK-NEXT:    bl __eqtf2
; CHECK-NEXT:    mov x19, x0
; CHECK-NEXT:    ldp q1, q0, [sp] // 32-byte Folded Reload
; CHECK-NEXT:    bl __unordtf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    ccmp w19, #0, #4, eq
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ldp x30, x19, [sp, #32] // 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #48
; CHECK-NEXT:    ret

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  %val = fcmp ueq fp128 %lhs, %rhs

  ret i1 %val
}


define dso_local i32 @test_br_cc() uwtable {
; CHECK-LABEL: test_br_cc:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    .cfi_remember_state
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    adrp x8, rhs
; CHECK-NEXT:    ldr q1, [x8, :lo12:rhs]
; CHECK-NEXT:    bl __lttf2
; CHECK-NEXT:    cmp w0, #0
; CHECK-NEXT:    b.ge .LBB11_2
; CHECK-NEXT:  // %bb.1: // %iftrue
; CHECK-NEXT:    mov w0, #42
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    .cfi_restore w30
; CHECK-NEXT:    ret
; CHECK-NEXT:  .LBB11_2: // %iffalse
; CHECK-NEXT:    .cfi_restore_state
; CHECK-NEXT:    mov w0, #29
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    .cfi_restore w30
; CHECK-NEXT:    ret

  %lhs = load fp128, fp128* @lhs, align 16
  %rhs = load fp128, fp128* @rhs, align 16

  ; olt == !uge, which LLVM optimizes this to.
  %cond = fcmp olt fp128 %lhs, %rhs
  br i1 %cond, label %iftrue, label %iffalse

iftrue:
  ret i32 42
iffalse:
  ret i32 29
}

define dso_local void @test_select(i1 %cond, fp128 %lhs, fp128 %rhs) {
; CHECK-LABEL: test_select:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tst w0, #0x1
; CHECK-NEXT:    b.eq .LBB12_2
; CHECK-NEXT:  // %bb.1:
; CHECK-NEXT:    mov v1.16b, v0.16b
; CHECK-NEXT:  .LBB12_2:
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    str q1, [x8, :lo12:lhs]
; CHECK-NEXT:    ret

  %val = select i1 %cond, fp128 %lhs, fp128 %rhs
  store fp128 %val, fp128* @lhs, align 16
  ret void
}

@varhalf = dso_local global half 0.0, align 2
@varfloat = dso_local global float 0.0, align 4
@vardouble = dso_local global double 0.0, align 8

define dso_local void @test_round() {
; CHECK-LABEL: test_round:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    str x30, [sp, #16] // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x8, lhs
; CHECK-NEXT:    ldr q0, [x8, :lo12:lhs]
; CHECK-NEXT:    str q0, [sp] // 16-byte Folded Spill
; CHECK-NEXT:    bl __trunctfhf2
; CHECK-NEXT:    adrp x8, varhalf
; CHECK-NEXT:    str h0, [x8, :lo12:varhalf]
; CHECK-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    bl __trunctfsf2
; CHECK-NEXT:    adrp x8, varfloat
; CHECK-NEXT:    str s0, [x8, :lo12:varfloat]
; CHECK-NEXT:    ldr q0, [sp] // 16-byte Folded Reload
; CHECK-NEXT:    bl __trunctfdf2
; CHECK-NEXT:    adrp x8, vardouble
; CHECK-NEXT:    str d0, [x8, :lo12:vardouble]
; CHECK-NEXT:    ldr x30, [sp, #16] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret

  %val = load fp128, fp128* @lhs, align 16

  %half = fptrunc fp128 %val to half
  store half %half, half* @varhalf, align 2

  %float = fptrunc fp128 %val to float
  store float %float, float* @varfloat, align 4

  %double = fptrunc fp128 %val to double
  store double %double, double* @vardouble, align 8

  ret void
}

define dso_local void @test_extend() {
; CHECK-LABEL: test_extend:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, x19, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    adrp x19, lhs
; CHECK-NEXT:    adrp x8, varhalf
; CHECK-NEXT:    ldr h0, [x8, :lo12:varhalf]
; CHECK-NEXT:    bl __extendhftf2
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    adrp x8, varfloat
; CHECK-NEXT:    ldr s0, [x8, :lo12:varfloat]
; CHECK-NEXT:    bl __extendsftf2
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    adrp x8, vardouble
; CHECK-NEXT:    ldr d0, [x8, :lo12:vardouble]
; CHECK-NEXT:    bl __extenddftf2
; CHECK-NEXT:    str q0, [x19, :lo12:lhs]
; CHECK-NEXT:    ldp x30, x19, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret

  %val = load fp128, fp128* @lhs, align 16

  %half = load half, half* @varhalf
  %fromhalf = fpext half %half to fp128
  store volatile fp128 %fromhalf, fp128* @lhs, align 16

  %float = load float, float* @varfloat
  %fromfloat = fpext float %float to fp128
  store volatile fp128 %fromfloat, fp128* @lhs, align 16

  %double = load double, double* @vardouble
  %fromdouble = fpext double %double to fp128
  store volatile fp128 %fromdouble, fp128* @lhs, align 16

  ret void
}

define fp128 @test_neg(fp128 %in) {
; CHECK-LABEL: test_neg:
; CHECK:       // %bb.0:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str q0, [sp, #-16]!
; CHECK-NEXT:    ldrb w8, [sp, #15]
; CHECK-NEXT:    eor w8, w8, #0x80
; CHECK-NEXT:    strb w8, [sp, #15]
; CHECK-NEXT:    ldr q0, [sp], #16
; CHECK-NEXT:    ret

;; We convert this to fneg, and target-independent code expands it with
;; integer operations.
  %ret = fsub fp128 0xL00000000000000008000000000000000, %in
  ret fp128 %ret

}
