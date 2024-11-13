// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: multiMat.s
// Descripción: (Bucles anidados, operaciones en memoria) Multiplicación de matrices
// Versión: 1.0
// ====================================================
// Código en C#
//
// void MultiplicaMatrices(int[,] A, int[,] B, int[,] C, int filasA, int colsA, int colsB) {
//     for (int i = 0; i < filasA; i++) {
//         for (int j = 0; j < colsB; j++) {
//             C[i, j] = 0;
//             for (int k = 0; k < colsA; k++) {
//                 C[i, j] += A[i, k] * B[k, j];
//             }
//         }
//     }
// }
//
// ====================================================

.section .data
matA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9       // Matriz A 3x3
matB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1       // Matriz B 3x3
matC: .space 36                             // Matriz C (resultado) 3x3

.size: .word 3                              // Tamaño de las matrices (3x3)

.section .text
.global _start

_start:
    // Cargar el tamaño de la matriz
    ldr x1, =.size           // Dirección del tamaño de la matriz
    ldr w1, [x1]             // Cargar el tamaño en w1 (n = 3)

    // Cargar las direcciones base de las matrices A, B y C
    ldr x2, =matA            // Dirección base de matA
    ldr x3, =matB            // Dirección base de matB
    ldr x4, =matC            // Dirección base de matC

    mov w5, #0               // Inicializar índice de filas i = 0

outer_loop:
    cmp w5, w1               // Comparar i con el tamaño de la matriz
    bge end                  // Si i >= n, salir del bucle

    mov w6, #0               // Inicializar índice de columnas j = 0

inner_loop:
    cmp w6, w1               // Comparar j con el tamaño de la matriz
    bge next_row             // Si j >= n, ir a la siguiente fila

    // Inicializar C[i][j] a 0
    mov w7, #0               // w7 es el acumulador para C[i][j]

    // Inicializar el índice k para el bucle interno
    mov w8, #0               // k = 0

product_loop:
    cmp w8, w1               // Comparar k con el tamaño de la matriz
    bge store_result         // Si k >= n, almacenar el resultado en C[i][j]

    // Calcular los índices lineales para A[i][k] y B[k][j]
    // Índice de A[i][k] = (i * n + k) * 4
    mov x9, x5               // x9 = i
    mul x9, x9, x1           // x9 = i * n
    add x9, x9, x8           // x9 = i * n + k
    lsl x9, x9, #2           // x9 = (i * n + k) * 4
    ldr w9, [x2, x9]         // Cargar A[i][k] en w9

    // Índice de B[k][j] = (k * n + j) * 4
    mov x10, x8              // x10 = k
    mul x10, x10, x1         // x10 = k * n
    add x10, x10, x6         // x10 = k * n + j
    lsl x10, x10, #2         // x10 = (k * n + j) * 4
    ldr w10, [x3, x10]       // Cargar B[k][j] en w10

    // Multiplicar A[i][k] * B[k][j] y sumar al acumulador
    mul w11, w9, w10         // w11 = A[i][k] * B[k][j]
    add w7, w7, w11          // C[i][j] += A[i][k] * B[k][j]

    // Incrementar k
    add w8, w8, #1           // k++
    b product_loop           // Repetir el ciclo product_loop

store_result:
    // Guardar el valor acumulado en C[i][j]
    mov x11, x5              // x11 = i
    mul x11, x11, x1         // x11 = i * n
    add x11, x11, x6         // x11 = i * n + j
    lsl x11, x11, #2         // x11 *= 4 (calcular el índice de C[i][j])
    str w7, [x4, x11]        // C[i][j] = w7

    // Incrementar j
    add w6, w6, #1           // j++
    b inner_loop             // Repetir el ciclo inner_loop

next_row:
    // Incrementar i
    add w5, w5, #1           // i++
    b outer_loop             // Repetir el ciclo outer_loop

end:
    // Salir del programa
    mov x8, #93              // Código de sistema para salida en Linux
    svc #0                   // Llamada al sistema para terminar el programa