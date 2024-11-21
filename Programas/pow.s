// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: pow.s
// Descripción: (Recursión/bucles) Potencia (x^n)
// Versión: 1.1
// ====================================================
// Código en C
//
// int powerRecursive(int x, int n) {
//     if (n == 0) return 1;
//     return x * powerRecursive(x, n - 1);
// }
//
// int powerIterative(int x, int n) {
//     int result = 1;
//     for (int i = 0; i < n; i++) {
//         result *= x;
//     }
//     return result;
// }
//
// ====================================================

.section .data
x:      .word 2               // Base (x)
n:      .word 5               // Exponente (n)

.section .text
.global _start

_start:
    // Cargar x y n en registros
    ldr x0, =x                // Dirección de x
    ldr x1, =n                // Dirección de n
    ldr w0, [x0]              // Cargar el valor de x en w0
    ldr w1, [x1]              // Cargar el valor de n en w1

    // Llamar a la versión recursiva
    bl powerRecursive         // Llamar a powerRecursive
    mov w2, w0                // Guardar el resultado recursivo en w2

    // Llamar a la versión iterativa
    ldr x0, =x                // Recargar x en x0
    ldr x1, =n                // Recargar n en x1
    ldr w0, [x0]              // Cargar el valor de x en w0
    ldr w1, [x1]              // Cargar el valor de n en w1
    bl powerIterative         // Llamar a powerIterative
    mov w3, w0                // Guardar el resultado iterativo en w3

    // Salir del programa
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa

// powerRecursive(int x, int n)
powerRecursive:
    cmp w1, #0                // Si n == 0
    bne continue_recursion    // Si no, continuar
    mov w0, #1                // Si n == 0, devolver 1
    ret

continue_recursion:
    sub w1, w1, #1            // n = n - 1
    stp x29, x30, [sp, #-16]! // Guardar FP y LR en la pila
    mov x29, sp               // Actualizar el FP
    bl powerRecursive         // Llamar recursivamente
    ldp x29, x30, [sp], #16   // Restaurar FP y LR
    mul w0, w0, w2            // x * powerRecursive(x, n - 1)
    ret

// powerIterative(int x, int n)
powerIterative:
    mov w2, #1                // Inicializar resultado a 1
    mov w3, #0                // Inicializar contador i = 0

iterative_loop:
    cmp w3, w1                // Si i >= n
    bge end_iterative         // Terminar bucle
    mul w2, w2, w0            // resultado *= x
    add w3, w3, #1            // i++
    b iterative_loop          // Repetir el bucle

end_iterative:
    mov w0, w2                // Guardar el resultado en w0
    ret