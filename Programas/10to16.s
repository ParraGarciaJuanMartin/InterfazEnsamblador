// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: 10to16.s
// Descripción: (Conversión de datos) Convertir un número decimal a hexadecimal
// Versión: 1.1
// ====================================================
// Código en C#:
//
// void decimalToHex(int decimal, char* hex) {
//     int i = 0;
//     while (decimal > 0) {
//         int digit = decimal % 16;
//         hex[i] = digit < 10 ? '0' + digit : 'A' + (digit - 10);
//         decimal = decimal / 16;
//         i++;
//     }
//     hex[i] = '\0'; // Null-terminar el string
// }
//
// ====================================================

.section .data
decimal: .word 4567              // Número decimal a convertir
hex:     .space 16               // Espacio para el resultado hexadecimal (máximo 16 dígitos)
null:    .byte 0                 // Carácter nulo para terminar la cadena

.section .text
.global _start

_start:
    // Inicialización
    ldr x0, =decimal             // Dirección del número decimal
    ldr w0, [x0]                 // Leer el número decimal en w0
    ldr x1, =hex                 // Dirección para almacenar la representación hexadecimal
    mov w2, #0                   // Índice i = 0
    mov x2, xzr                  // Asegurar x2 está en cero para el uso del índice

convert_loop:
    // Comprobar si decimal es 0
    cmp w0, #0
    beq end_conversion           // Si decimal == 0, salir del bucle

    // Calcular el dígito menos significativo (decimal % 16)
    and w3, w0, #15              // w3 = decimal % 16

    // Convertir el dígito en carácter ASCII
    cmp w3, #10                  // Comparar dígito con 10
    add w4, w3, #'0'             // Si dígito < 10, convertirlo a carácter
    add w4, w4, #'A' - '0'       // Si dígito >= 10, ajustarlo a letra
    csel w4, w4, w3, hs          // Elegir entre carácter '0'-'9' o 'A'-'F'

    // Almacenar el carácter en hex[i]
    strb w4, [x1, x2]            // Guardar el carácter en la dirección hex[i]

    // Actualizar decimal (decimal = decimal / 16)
    lsr w0, w0, #4               // w0 >>= 4 (división entre 16)

    // Incrementar el índice i++
    add x2, x2, #1               // i++

    // Repetir el bucle
    b convert_loop

end_conversion:
    // Null-terminar el string
    ldr w3, =0                   // Cargar el carácter nulo
    strb w3, [x1, x2]            // Guardar el carácter nulo al final del string

    // Salir del programa
    mov x8, #93                  // Código de sistema para salida en Linux
    svc #0                       // Llamada al sistema para terminar el programa