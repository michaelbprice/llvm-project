; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zbt -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32ZBT

define i32 @cmix_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmix_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    and a0, a1, a0
; RV32I-NEXT:    not a1, a1
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %and = and i32 %b, %a
  %neg = xor i32 %b, -1
  %and1 = and i32 %neg, %c
  %or = or i32 %and1, %and
  ret i32 %or
}

define i32 @cmix_i32_2(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmix_i32_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    xor a0, a0, a2
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    xor a0, a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i32_2:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %xor = xor i32 %a, %c
  %and = and i32 %xor, %b
  %xor1 = xor i32 %and, %c
  ret i32 %xor1
}

define i64 @cmix_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmix_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    and a1, a3, a1
; RV32I-NEXT:    and a0, a2, a0
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    not a3, a3
; RV32I-NEXT:    and a3, a3, a5
; RV32I-NEXT:    and a2, a2, a4
; RV32I-NEXT:    or a0, a2, a0
; RV32I-NEXT:    or a1, a3, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a2, a0, a4
; RV32ZBT-NEXT:    cmix a1, a3, a1, a5
; RV32ZBT-NEXT:    ret
  %and = and i64 %b, %a
  %neg = xor i64 %b, -1
  %and1 = and i64 %neg, %c
  %or = or i64 %and1, %and
  ret i64 %or
}

define i64 @cmix_i64_2(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmix_i64_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    xor a0, a0, a4
; RV32I-NEXT:    xor a1, a1, a5
; RV32I-NEXT:    and a1, a1, a3
; RV32I-NEXT:    and a0, a0, a2
; RV32I-NEXT:    xor a0, a0, a4
; RV32I-NEXT:    xor a1, a1, a5
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmix_i64_2:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmix a0, a2, a0, a4
; RV32ZBT-NEXT:    cmix a1, a3, a1, a5
; RV32ZBT-NEXT:    ret
  %xor = xor i64 %a, %c
  %and = and i64 %xor, %b
  %xor1 = xor i64 %and, %c
  ret i64 %xor1
}

define i32 @cmov_eq_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_eq_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a1, a2, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_eq_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, %c
  %cond = select i1 %tobool.not, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_eq_i32_constant_zero(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_eq_i32_constant_zero:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beqz a1, .LBB5_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB5_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_eq_i32_constant_zero:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmov a0, a1, a2, a0
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, 0
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_eq_i32_constant_2048(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_eq_i32_constant_2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1
; RV32I-NEXT:    addi a3, a3, -2048
; RV32I-NEXT:    beq a1, a3, .LBB6_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB6_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_eq_i32_constant_2048:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    addi a1, a1, -2048
; RV32ZBT-NEXT:    cmov a0, a1, a2, a0
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, 2048
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_eq_i32_constant_neg_2047(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_eq_i32_constant_neg_2047:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, -2047
; RV32I-NEXT:    beq a1, a3, .LBB7_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB7_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_eq_i32_constant_neg_2047:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    addi a1, a1, 2047
; RV32ZBT-NEXT:    cmov a0, a1, a2, a0
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i32 %b, -2047
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ne_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_ne_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bne a1, a2, .LBB8_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB8_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ne_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a0, a3
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp ne i32 %b, %c
  %cond = select i1 %tobool.not, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_ne_i32_constant_zero(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ne_i32_constant_zero:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bnez a1, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ne_i32_constant_zero:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp ne i32 %b, 0
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ne_i32_constant_2048(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ne_i32_constant_2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1
; RV32I-NEXT:    addi a3, a3, -2048
; RV32I-NEXT:    bne a1, a3, .LBB10_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB10_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ne_i32_constant_2048:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    addi a1, a1, -2048
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp ne i32 %b, 2048
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ne_i32_constant_neg_2047(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ne_i32_constant_neg_2047:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, -2047
; RV32I-NEXT:    bne a1, a3, .LBB11_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB11_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ne_i32_constant_neg_2047:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    addi a1, a1, 2047
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp ne i32 %b, -2047
  %cond = select i1 %tobool.not, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sle_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_sle_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bge a2, a1, .LBB12_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB12_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slt a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_sle_i32_constant_2046(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sle_i32_constant_2046:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, 2047
; RV32I-NEXT:    blt a1, a3, .LBB13_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB13_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i32_constant_2046:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, 2047
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i32 %b, 2046
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sle_i32_constant_neg_2049(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sle_i32_constant_neg_2049:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, -2048
; RV32I-NEXT:    blt a1, a3, .LBB14_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB14_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i32_constant_neg_2049:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, -2048
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i32 %b, -2049
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sgt_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_sgt_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    blt a2, a1, .LBB15_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB15_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sgt_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slt a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a3
; RV32ZBT-NEXT:    ret
  %tobool = icmp sgt i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_sgt_i32_constant_2046(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sgt_i32_constant_2046:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, 2046
; RV32I-NEXT:    blt a3, a1, .LBB16_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB16_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sgt_i32_constant_2046:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, 2047
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sgt i32 %b, 2046
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sgt_i32_constant_neg_2049(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sgt_i32_constant_neg_2049:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1048575
; RV32I-NEXT:    addi a3, a3, 2047
; RV32I-NEXT:    blt a3, a1, .LBB17_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB17_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sgt_i32_constant_neg_2049:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, -2048
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sgt i32 %b, -2049
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sge_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_sge_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bge a1, a2, .LBB18_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB18_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slt a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_sge_i32_constant_2047(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sge_i32_constant_2047:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, 2046
; RV32I-NEXT:    blt a3, a1, .LBB19_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB19_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i32_constant_2047:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, 2047
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i32 %b, 2047
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_sge_i32_constant_neg_2048(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_sge_i32_constant_neg_2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1048575
; RV32I-NEXT:    addi a3, a3, 2047
; RV32I-NEXT:    blt a3, a1, .LBB20_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB20_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i32_constant_neg_2048:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    slti a1, a1, -2048
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i32 %b, -2048
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ule_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_ule_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgeu a2, a1, .LBB21_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB21_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltu a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_ule_i32_constant_2047(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ule_i32_constant_2047:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a1, 11
; RV32I-NEXT:    beqz a1, .LBB22_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB22_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i32_constant_2047:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    srli a1, a1, 11
; RV32ZBT-NEXT:    cmov a0, a1, a2, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i32 %b, 2047
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ule_i32_constant_neg_2049(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ule_i32_constant_neg_2049:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, -2048
; RV32I-NEXT:    bltu a1, a3, .LBB23_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB23_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i32_constant_neg_2049:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltiu a1, a1, -2048
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i32 %b, 4294965247
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ugt_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_ugt_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bltu a2, a1, .LBB24_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB24_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ugt_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltu a1, a2, a1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a3
; RV32ZBT-NEXT:    ret
  %tobool = icmp ugt i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_ugt_i32_constant_2046(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ugt_i32_constant_2046:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, 2046
; RV32I-NEXT:    bltu a3, a1, .LBB25_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB25_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ugt_i32_constant_2046:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltiu a1, a1, 2047
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp ugt i32 %b, 2046
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_ugt_i32_constant_neg_2049(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_ugt_i32_constant_neg_2049:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1048575
; RV32I-NEXT:    addi a3, a3, 2047
; RV32I-NEXT:    bltu a3, a1, .LBB26_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB26_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ugt_i32_constant_neg_2049:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltiu a1, a1, -2048
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp ugt i32 %b, 4294965247
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_uge_i32(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; RV32I-LABEL: cmov_uge_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgeu a1, a2, .LBB27_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB27_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltu a1, a1, a2
; RV32ZBT-NEXT:    cmov a0, a1, a3, a0
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i32 %b, %c
  %cond = select i1 %tobool, i32 %a, i32 %d
  ret i32 %cond
}

define i32 @cmov_uge_i32_constant_2047(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_uge_i32_constant_2047:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a3, 2046
; RV32I-NEXT:    bltu a3, a1, .LBB28_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB28_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i32_constant_2047:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltiu a1, a1, 2047
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i32 %b, 2047
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i32 @cmov_uge_i32_constant_neg_2048(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: cmov_uge_i32_constant_neg_2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 1048575
; RV32I-NEXT:    addi a3, a3, 2047
; RV32I-NEXT:    bltu a3, a1, .LBB29_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:  .LBB29_2:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i32_constant_neg_2048:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    sltiu a1, a1, -2048
; RV32ZBT-NEXT:    xori a1, a1, 1
; RV32ZBT-NEXT:    cmov a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i32 %b, 4294965248
  %cond = select i1 %tobool, i32 %a, i32 %c
  ret i32 %cond
}

define i64 @cmov_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: cmov_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    or a2, a2, a3
; RV32I-NEXT:    beqz a2, .LBB30_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a4, a0
; RV32I-NEXT:    mv a5, a1
; RV32I-NEXT:  .LBB30_2:
; RV32I-NEXT:    mv a0, a4
; RV32I-NEXT:    mv a1, a5
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    or a2, a2, a3
; RV32ZBT-NEXT:    cmov a0, a2, a0, a4
; RV32ZBT-NEXT:    cmov a1, a2, a1, a5
; RV32ZBT-NEXT:    ret
  %tobool.not = icmp eq i64 %b, 0
  %cond = select i1 %tobool.not, i64 %c, i64 %a
  ret i64 %cond
}

define i64 @cmov_sle_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_sle_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB31_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a2, a5, a3
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB31_3
; RV32I-NEXT:    j .LBB31_4
; RV32I-NEXT:  .LBB31_2:
; RV32I-NEXT:    sltu a2, a4, a2
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB31_4
; RV32I-NEXT:  .LBB31_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB31_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sle_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a4, a2
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    slt a3, a5, a3
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp sle i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_sge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_sge_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB32_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    slt a2, a3, a5
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB32_3
; RV32I-NEXT:    j .LBB32_4
; RV32I-NEXT:  .LBB32_2:
; RV32I-NEXT:    sltu a2, a2, a4
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB32_4
; RV32I-NEXT:  .LBB32_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB32_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_sge_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a2, a4
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    slt a3, a3, a5
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp sge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_ule_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_ule_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB33_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a2, a5, a3
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB33_3
; RV32I-NEXT:    j .LBB33_4
; RV32I-NEXT:  .LBB33_2:
; RV32I-NEXT:    sltu a2, a4, a2
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB33_4
; RV32I-NEXT:  .LBB33_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB33_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_ule_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a4, a2
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    sltu a3, a5, a3
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp ule i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

define i64 @cmov_uge_i64(i64 %a, i64 %b, i64 %c, i64 %d) nounwind {
; RV32I-LABEL: cmov_uge_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    beq a3, a5, .LBB34_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a2, a3, a5
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    beqz a2, .LBB34_3
; RV32I-NEXT:    j .LBB34_4
; RV32I-NEXT:  .LBB34_2:
; RV32I-NEXT:    sltu a2, a2, a4
; RV32I-NEXT:    xori a2, a2, 1
; RV32I-NEXT:    bnez a2, .LBB34_4
; RV32I-NEXT:  .LBB34_3:
; RV32I-NEXT:    mv a0, a6
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB34_4:
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: cmov_uge_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    xor t0, a3, a5
; RV32ZBT-NEXT:    sltu a2, a2, a4
; RV32ZBT-NEXT:    xori a2, a2, 1
; RV32ZBT-NEXT:    sltu a3, a3, a5
; RV32ZBT-NEXT:    xori a3, a3, 1
; RV32ZBT-NEXT:    cmov a2, t0, a3, a2
; RV32ZBT-NEXT:    cmov a0, a2, a0, a6
; RV32ZBT-NEXT:    cmov a1, a2, a1, a7
; RV32ZBT-NEXT:    ret
  %tobool = icmp uge i64 %b, %c
  %cond = select i1 %tobool, i64 %a, i64 %d
  ret i64 %cond
}

declare i32 @llvm.fshl.i32(i32, i32, i32)

define i32 @fshl_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: fshl_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshl_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    andi a2, a2, 31
; RV32ZBT-NEXT:    fsl a0, a0, a1, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet an efficient pattern-matching with bit manipulation
; instructions on RV32.
; This test is presented here in case future expansions of the Bitmanip
; extensions introduce instructions that can match more efficiently this pattern.

declare i64 @llvm.fshl.i64(i64, i64, i64)

define i64 @fshl_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: fshl_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a5, a4, 5
; RV32I-NEXT:    andi a6, a5, 1
; RV32I-NEXT:    mv a5, a3
; RV32I-NEXT:    bnez a6, .LBB36_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a5, a0
; RV32I-NEXT:  .LBB36_2:
; RV32I-NEXT:    sll a7, a5, a4
; RV32I-NEXT:    bnez a6, .LBB36_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a2, a3
; RV32I-NEXT:  .LBB36_4:
; RV32I-NEXT:    srli a2, a2, 1
; RV32I-NEXT:    not a3, a4
; RV32I-NEXT:    srl a2, a2, a3
; RV32I-NEXT:    or a2, a7, a2
; RV32I-NEXT:    bnez a6, .LBB36_6
; RV32I-NEXT:  # %bb.5:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB36_6:
; RV32I-NEXT:    sll a0, a0, a4
; RV32I-NEXT:    srli a1, a5, 1
; RV32I-NEXT:    srl a1, a1, a3
; RV32I-NEXT:    or a1, a0, a1
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshl_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    srli a5, a4, 5
; RV32ZBT-NEXT:    andi a5, a5, 1
; RV32ZBT-NEXT:    cmov a2, a5, a2, a3
; RV32ZBT-NEXT:    cmov a3, a5, a3, a0
; RV32ZBT-NEXT:    andi a4, a4, 31
; RV32ZBT-NEXT:    fsl a2, a3, a2, a4
; RV32ZBT-NEXT:    cmov a0, a5, a0, a1
; RV32ZBT-NEXT:    fsl a1, a0, a3, a4
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

declare i32 @llvm.fshr.i32(i32, i32, i32)

define i32 @fshr_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV32I-LABEL: fshr_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    not a2, a2
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshr_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    andi a2, a2, 31
; RV32ZBT-NEXT:    fsr a0, a1, a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

; As we are not matching directly i64 code patterns on RV32 some i64 patterns
; don't have yet an efficient pattern-matching with bit manipulation
; instructions on RV32.
; This test is presented here in case future expansions of the Bitmanip
; extensions introduce instructions that can match more efficiently this pattern.

declare i64 @llvm.fshr.i64(i64, i64, i64)

define i64 @fshr_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV32I-LABEL: fshr_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a5, a4, 32
; RV32I-NEXT:    beqz a5, .LBB38_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a2, a3
; RV32I-NEXT:  .LBB38_2:
; RV32I-NEXT:    srl a2, a2, a4
; RV32I-NEXT:    beqz a5, .LBB38_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a3, a0
; RV32I-NEXT:  .LBB38_4:
; RV32I-NEXT:    slli a7, a3, 1
; RV32I-NEXT:    not a6, a4
; RV32I-NEXT:    sll a7, a7, a6
; RV32I-NEXT:    or a2, a7, a2
; RV32I-NEXT:    srl a3, a3, a4
; RV32I-NEXT:    beqz a5, .LBB38_6
; RV32I-NEXT:  # %bb.5:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB38_6:
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    sll a0, a0, a6
; RV32I-NEXT:    or a1, a0, a3
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshr_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    andi a5, a4, 32
; RV32ZBT-NEXT:    cmov a6, a5, a0, a3
; RV32ZBT-NEXT:    cmov a2, a5, a3, a2
; RV32ZBT-NEXT:    andi a3, a4, 31
; RV32ZBT-NEXT:    fsr a2, a2, a6, a3
; RV32ZBT-NEXT:    cmov a0, a5, a1, a0
; RV32ZBT-NEXT:    fsr a1, a6, a0, a3
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

define i32 @fshri_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fshri_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a1, 5
; RV32I-NEXT:    slli a0, a0, 27
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshri_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a0, a1, a0, 5
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshr.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

define i64 @fshri_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: fshri_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a2, 5
; RV32I-NEXT:    slli a2, a3, 27
; RV32I-NEXT:    or a2, a2, a1
; RV32I-NEXT:    srli a1, a3, 5
; RV32I-NEXT:    slli a0, a0, 27
; RV32I-NEXT:    or a1, a0, a1
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshri_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a2, a2, a3, 5
; RV32ZBT-NEXT:    fsri a1, a3, a0, 5
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshr.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}

define i32 @fshli_i32(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fshli_i32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a1, a1, 27
; RV32I-NEXT:    slli a0, a0, 5
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshli_i32:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a0, a1, a0, 27
; RV32ZBT-NEXT:    ret
  %1 = tail call i32 @llvm.fshl.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

define i64 @fshli_i64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: fshli_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a2, a3, 27
; RV32I-NEXT:    slli a3, a0, 5
; RV32I-NEXT:    or a2, a3, a2
; RV32I-NEXT:    srli a0, a0, 27
; RV32I-NEXT:    slli a1, a1, 5
; RV32I-NEXT:    or a1, a1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    ret
;
; RV32ZBT-LABEL: fshli_i64:
; RV32ZBT:       # %bb.0:
; RV32ZBT-NEXT:    fsri a2, a3, a0, 27
; RV32ZBT-NEXT:    fsri a1, a0, a1, 27
; RV32ZBT-NEXT:    mv a0, a2
; RV32ZBT-NEXT:    ret
  %1 = tail call i64 @llvm.fshl.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}

