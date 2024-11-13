// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: mcm.s
// Descripción: (Operaciones aritméticas) Calcular el Mínimo Común Múltiplo (MCM)
// Versión: 1.0
// ====================================================
// Código en C:
//
// int gcd(int a, int b) {
//     while (b != 0) {
//         int temp = b;
//         b = a % b;
//         a = temp;
//     }
//     return a;
// }
//
// int lcm(int a, int b) {
//     return (a * b) / gcd(a, b);
// }
//
// ====================================================

.section .data
num1:   .word 12             // Primer número para el cálculo del MCM
num2:   .word 15             // Segundo número para el cálculo del MCM

.section .text
.global _start

_start:
    // Cargar num1 y num2 desde memoria en w0 y w1
    ldr x0, =num1           // Cargar la dirección de num1 en x0
    ldr x1, =num2           // Cargar la dirección de num2 en x1
    ldr w0, [x0]            // Cargar el valor de num1 en w0
    ldr w1, [x1]            // Cargar el valor de num2 en w1

    // Guardar copias de los valores originales para el cálculo del MCM
    mov w2, w0              // w2 = num1 (copia de a)
    mov w3, w1              // w3 = num2 (copia de b)

    // Llamar al cálculo del MCD usando el algoritmo de Euclides
gcd_loop:
    cbz w1, compute_lcm     // Si b (w1) es 0, salimos del bucle (MCD encontrado en w0)
    udiv w4, w0, w1         // División entera: w4 = w0 / w1
    msub w4, w4, w1, w0     // Resto: w4 = w0 - (w4 * w1), es decir, w4 = w0 % w1
    mov w0, w1              // a = b
    mov w1, w4              // b = a % b
    b gcd_loop              // Repetir el bucle

compute_lcm:
    // w0 ahora contiene el MCD de num1 y num2
    // Calcular (num1 * num2) / MCD

    mul w4, w2, w3          // Multiplicación: w4 = num1 * num2
    udiv w5, w4, w0         // División: w5 = (num1 * num2) / MCD

    // Ahora w5 contiene el MCM de num1 y num2

    // Salida del programa
    mov x8, #93             // Código de sistema para salida en Linux
    svc #0                  // Llamada al sistema para terminar el programa