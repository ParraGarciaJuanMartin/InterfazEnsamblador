// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: traMat.s
// Descripción: (Manipulación de arreglos) Transposición de una matriz
// Versión: 1.0
// ====================================================
// Código en C#
//
// void TransponerMatriz(int[,] A, int[,] AT, int n) {
//     for (int i = 0; i < n; i++) {
//         for (int j = 0; j < n; j++) {
//             AT[j, i] = A[i, j];
//         }
//     }
// }
//
// ====================================================

.section .data
matA: .word 1, 2, 3, 4, 5, 6, 7, 8, 9    // Matriz original 3x3
matAT: .space 36                         // Matriz transpuesta 3x3 (resultado)

.size: .word 3                           // Tamaño de la matriz (3x3)

.section .text
.global _start

_start:
    // Cargar el tamaño de la matriz
    ldr x1, =.size           // Dirección del tamaño de la matriz
    ldr w1, [x1]             // Cargar el tamaño en w1 (n = 3)

    // Cargar las direcciones base de las matrices A y AT
    ldr x2, =matA            // Dirección base de matA
    ldr x3, =matAT           // Dirección base de matAT

    mov w4, #0               // Inicializar índice de filas i = 0

outer_loop:
    cmp w4, w1               // Comparar i con el tamaño de la matriz
    bge end                  // Si i >= n, salir del bucle

    mov w5, #0               // Inicializar índice de columnas j = 0

inner_loop:
    cmp w5, w1               // Comparar j con el tamaño de la matriz
    bge next_row             // Si j >= n, ir a la siguiente fila

    // Calcular los índices lineales para A[i][j] y AT[j][i]
    // Índice de A[i][j] = (i * n + j) * 4
    mov x6, x4               // x6 = i
    mul x6, x6, x1           // x6 = i * n
    add x6, x6, x5           // x6 = i * n + j
    lsl x6, x6, #2           // x6 = (i * n + j) * 4
    ldr w6, [x2, x6]         // Cargar A[i][j] en w6

    // Índice de AT[j][i] = (j * n + i) * 4
    mov x7, x5               // x7 = j
    mul x7, x7, x1           // x7 = j * n
    add x7, x7, x4           // x7 = j * n + i
    lsl x7, x7, #2           // x7 *= 4 (calcular el índice de AT[j][i])
    str w6, [x3, x7]         // AT[j][i] = A[i][j]

    // Incrementar j
    add w5, w5, #1           // j++
    b inner_loop             // Repetir el ciclo inner_loop

next_row:
    // Incrementar i
    add w4, w4, #1           // i++
    b outer_loop             // Repetir el ciclo outer_loop

end:
    // Salir del programa
    mov x8, #93              // Código de sistema para salida en Linux
    svc #0                   // Llamada al sistema para terminar el programa