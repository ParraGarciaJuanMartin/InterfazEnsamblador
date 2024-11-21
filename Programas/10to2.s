// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: 10to2.s
// Descripción: (Conversión, bucles) Convertir un número decimal a binario
// Versión: 1.2
// ====================================================
// Código en C:
//
// void decimalToBinary(int decimal, int* binary) {
//     int i = 0;
//     while (decimal > 0) {
//         binary[i] = decimal % 2;
//         decimal = decimal / 2;
//         i++;
//     }
// }
//
// ====================================================

.section .data
decimal: .word 25             // Número decimal a convertir
binary:  .space 32            // Espacio para almacenar hasta 32 bits (1 palabra por bit)

.section .text
.global _start

_start:
    ldr x0, =decimal          // Cargar la dirección de `decimal` en x0
    ldr w0, [x0]              // Leer el valor decimal en w0
    ldr x1, =binary           // Cargar la dirección de `binary` en x1
    mov x2, #0                // Inicializar el índice i = 0 (en registro de 64 bits)

convert_loop:
    cmp w0, #0                // Comprobar si el decimal es 0
    beq end_conversion        // Si decimal == 0, terminar

    and w3, w0, #1            // w3 = decimal % 2
    str w3, [x1, x2, lsl #2]  // Almacenar el bit en binary[i]

    lsr w0, w0, #1            // decimal = decimal / 2 (desplazamiento lógico a la derecha)
    add x2, x2, #1            // Incrementar el índice (i++)

    b convert_loop            // Repetir el bucle

end_conversion:
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa