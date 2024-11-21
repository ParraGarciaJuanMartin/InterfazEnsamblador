// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: 2to10.s
// Descripción: (Conversión, bucles) Convertir un número binario a decimal
// Versión: 1.2
// ====================================================
// Código en C#:
//
// int binaryToDecimal(int* binary, int bits) {
//     int decimal = 0;
//     int factor = 1;
//     for (int i = 0; i < bits; i++) {
//         decimal += binary[i] * factor;
//         factor *= 2;
//     }
//     return decimal;
// }
//
// ====================================================

.section .data
binary:  .word 1, 0, 1, 1     // Número binario: 1011 (11 en decimal)
bits:    .word 4              // Número de bits en el binario
result:  .word 0              // Variable para almacenar el resultado decimal

.section .text
.global _start

_start:
    // Inicializar registros y cargar datos
    ldr x0, =binary           // Dirección del arreglo binario
    ldr x1, =bits             // Dirección del número de bits
    ldr w1, [x1]              // Leer el número de bits en w1
    ldr x2, =result           // Dirección para almacenar el resultado
    mov w3, #0                // decimal = 0
    mov w4, #1                // factor = 1
    mov x5, #0                // Índice i = 0 (64 bits)

convert_loop:
    uxtw x6, w1               // Extender w1 a 64 bits en x6
    cmp x5, x6                // Comparar i con bits
    beq end_conversion        // Si i == bits, salir del bucle

    // Leer binary[i]
    ldr w7, [x0, x5, lsl #2]  // w7 = binary[i] (cada elemento ocupa 4 bytes)

    // Actualizar el valor decimal
    mul w7, w7, w4            // w7 = binary[i] * factor
    add w3, w3, w7            // decimal += binary[i] * factor

    // Actualizar factor
    lsl w4, w4, #1            // factor *= 2

    // Incrementar el índice
    add x5, x5, #1            // i++

    b convert_loop            // Repetir el bucle

end_conversion:
    // Guardar el resultado decimal en memoria
    str w3, [x2]              // Guardar decimal en result

    // Salida del programa
    mov x8, #93               // Código de salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa