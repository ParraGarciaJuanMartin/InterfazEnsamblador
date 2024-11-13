// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: mcd.s
// Descripción: (Aritmética) Algoritmo de Euclides para calcular el Máximo Común Divisor (MCD)
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
// ====================================================

.section .data
num1:   .word 48            // Primer número para calcular el MCD
num2:   .word 18            // Segundo número para calcular el MCD

.section .text
.global _start

_start:
    // Cargar num1 y num2 desde memoria en w0 y w1
    ldr x0, =num1           // Cargar la dirección de num1 en x0
    ldr x1, =num2           // Cargar la dirección de num2 en x1
    ldr w0, [x0]            // Cargar el valor de num1 en w0
    ldr w1, [x1]            // Cargar el valor de num2 en w1

gcd_loop:
    // Comprobar si b (w1) es 0, en cuyo caso terminamos
    cbz w1, end_gcd         // Si w1 es 0, salir del bucle

    // Calcular a % b y almacenar en w2
    udiv w2, w0, w1         // División entera: w2 = w0 / w1
    msub w2, w2, w1, w0     // Resto: w2 = w0 - (w2 * w1), es decir, w2 = w0 % w1

    // Asignar a = b y b = a % b
    mov w0, w1              // a = b (mover el valor de w1 a w0)
    mov w1, w2              // b = a % b (mover el valor de w2 a w1)

    // Repetir el bucle
    b gcd_loop

end_gcd:
    // Al final, w0 contiene el MCD

    // Salida del programa
    mov x8, #93             // Código de sistema para salida en Linux
    svc #0                  // Llamada al sistema para terminar el programa
