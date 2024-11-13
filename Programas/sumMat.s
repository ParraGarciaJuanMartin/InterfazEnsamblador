// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: sumMat.s
// Descripción: (Operaciones con arreglos 2D) Suma de matrices
// Versión: 1.0
// ====================================================
// Código en C#
//
// void SumarMatrices(int[,] A, int[,] B, int[,] C) {
//     for (int i = 0; i < filas; i++) {
//         for (int j = 0; j < columnas; j++) {
//             C[i, j] = A[i, j] + B[i, j];
//         }
//     }
// }
//
// ====================================================


.section .data
matA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9   // Primera matriz 3x3
matB: .word 9, 8, 7, 6, 5, 4, 3, 2, 1   // Segunda matriz 3x3
matC: .space 36                         // Matriz resultado 3x3 (3 filas x 3 columnas x 4 bytes)

.rows: .word 3                          // Número de filas (3)
.cols: .word 3                          // Número de columnas (3)

.section .text
.global _start

_start:
    // Cargar el número de filas y columnas
    ldr x1, =.rows        // Dirección del número de filas
    ldr w1, [x1]          // Cargar el número de filas en w1
    ldr x2, =.cols        // Dirección del número de columnas
    ldr w2, [x2]          // Cargar el número de columnas en w2

    // Cargar las direcciones base de las matrices A, B y C
    ldr x3, =matA         // Dirección base de matA
    ldr x4, =matB         // Dirección base de matB
    ldr x5, =matC         // Dirección base de matC

    // Inicializar el índice de la fila en 0
    mov w6, #0            // i = 0

outer_loop:
    cmp w6, w1            // Comparar i con el número de filas
    bge end               // Si i >= filas, salir del bucle

    // Inicializar el índice de la columna en 0
    mov w7, #0            // j = 0

inner_loop:
    cmp w7, w2            // Comparar j con el número de columnas
    bge next_row          // Si j >= columnas, ir a la siguiente fila

    // Calcular el índice lineal para el elemento [i, j]
    mov x8, x6            // x8 = i
    mul x8, x8, x2        // x8 = i * columnas
    add x8, x8, x7        // x8 = i * columnas + j
    lsl x8, x8, #2        // x8 *= 4 (multiplicar por el tamaño del elemento)

    // Cargar A[i, j] y B[i, j] en w9 y w10
    ldr w9, [x3, x8]      // w9 = A[i, j]
    ldr w10, [x4, x8]     // w10 = B[i, j]

    // Sumar A[i, j] y B[i, j] y almacenar en C[i, j]
    add w11, w9, w10      // w11 = A[i, j] + B[i, j]
    str w11, [x5, x8]     // C[i, j] = A[i, j] + B[i, j]

    // Incrementar el índice de la columna
    add w7, w7, #1        // j++

    b inner_loop          // Repetir el ciclo de columnas

next_row:
    // Incrementar el índice de la fila
    add w6, w6, #1        // i++
    b outer_loop          // Repetir el ciclo de filas

end:
    // Salir del programa
    mov x8, #93           // Código de sistema para salida en Linux
    svc #0                // Llamada al sistema para terminar el programa