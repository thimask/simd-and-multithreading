////////////////////////////////////////////////////////////////////////////////
// You're implementing the following function in ARM Assembly
//! C = A * B
//! @param C          result matrix
//! @param A          matrix A 
//! @param B          matrix B
//! @param hA         height of matrix A
//! @param wA         width of matrix A
//! @param wB         width of matrix B
//
//void matmul(int* C, const int* A, const int* B, unsigned int hA, 
//    unsigned int wA, unsigned int wB)
//{
//  for (unsigned int i = 0; i < hA; ++i)
//    for (unsigned int j = 0; j < wB; ++j) {
//      int sum = 0;
//      for (unsigned int k = 0; k < wA; ++k) {
//        sum += A[i * wA + k] * B[j * wB + k];
//      }
//      C[i * wB + j] = sum;
//    }
//}
////////////////////////////////////////////////////////////////////////////////

.arch armv8-a
.global matmul

/*
 * Assumptions needed to make for this program to work:
 *    1. Matrix M is in row major order
 *    2. Matrix N is in column major order
 *    3. Both M and N have equal heights and widths i.e. Square Matrix
 *    4. Both M and N have a total size that is divisible by 4
 *
 * Argument Registers:
 * x0: Return matrix address
 * x1: Matrix A address
 * x2: Matrix B address
 * x3: hA
 * x4: wA
 * x5: wB
 */

matmul:
stp x29, x30, [sp, -96]! 
add x29, sp, 0
stp x19, x20, [sp, 16]
stp x21, x22, [sp, 32]
stp x23, x24, [sp, 48]
stp x25, x26, [sp, 64]
stp x27, x28, [sp, 80]

cbz x3, exit
cbz x4, exit
cbz x5, exit

mov x19, x0 
mov x20, x1 
mov x21, x2 
mov x22, x3 

mov x25, 0 
stp x1, x2, [sp, #-16]! 

outer:
cbz x22, skip_middle

mov x26, 0 
middle:
cbz x22, skip_inner
ldr x20, [sp, 0] 
mul x0, x22, x25
lsl x0, x0, #2
add x20, x20, x0
mov x28, 0 
mov x27, 0 
ldr x21, [sp, 8]
mul x0, x22, x26
lsl x0, x0, #2
add x21, x21, x0

inner:
ld1 {v0.4S}, [x21], 16 
ld1 {v1.4s}, [x20], 16 

mov x0, 0
mul v2.4s, v0.4s, v1.4s

bl summation 
add x28, x28, x0
add x27, x27, 4
cmp x22, x27
bne inner
skip_inner:
str x28, [x19], 4
add x26, x26, 1
cmp x22, x26
bne middle
skip_middle:
add x25, x25, 1 
cmp x22, x25
bne outer
exit:
/* Pop off stack */
ldp x19, x20, [sp], 16
ldp x19, x20, [sp, 16]
ldp x21, x22, [sp, 32]
ldp x23, x24, [sp, 48]
ldp x25, x26, [sp, 64]
ldp x27, x28, [sp, 80]
ldp x29, x30, [sp], 96
ret

summation:
mov w1, v2.s[0]
add x0, x0, x1
mov w1, v2.s[1]
add x0, x0, x1
mov w1, v2.s[2]
add x0, x0, x1
mov w1, v2.s[3]
add x0, x0, x1
ret

