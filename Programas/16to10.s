// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: 16to10.s
// Descripción: (Conversión de datos) Convertir un número hexadecimal a decimal
// Versión: 1.0
// ====================================================
// Código en C#:
//
// int hexToDecimal(char* hex) {
//     int decimal = 0;
//     for (int i = 0; hex[i] != '\0'; i++) {
//         char digit = hex[i];
//         int value = (digit >= '0' && digit <= '9') ? (digit - '0') : (digit - 'A' + 10);
//         decimal = decimal * 16 + value;
//     }
//     return decimal;
// }
//
// ====================================================


.section .data
hex:     .asciz "11D7"           // Número hexadecimal a convertir (cadena terminada en null)
result:  .word 0                 // Almacenar el resultado decimal

.section .text
.global _start

_start:
    // Inicialización
    ldr x0, =hex                 // Dirección del número hexadecimal
    ldr x1, =result              // Dirección del resultado decimal
    mov w2, #0                   // decimal = 0
    mov x3, xzr                  // Índice i = 0
    mov w5, #16                  // Cargar 16 en w5 (para multiplicación)

convert_loop:
    // Leer el carácter actual hex[i]
    ldrb w4, [x0, x3]            // Cargar el carácter actual en w4
    cmp w4, #0                   // Comparar con '\0'
    beq end_conversion           // Si es '\0', terminar el bucle

    // Determinar el valor del carácter hexadecimal
    cmp w4, #'9'                 // Comparar con '9'
    ble is_digit                 // Si w4 <= '9', es un dígito numérico
    sub w4, w4, #'A'             // Restar 'A'
    add w4, w4, #10              // Ajustar a su valor numérico (A=10, B=11, ...)
    b process_digit

is_digit:
    sub w4, w4, #'0'             // Convertir dígito ('0'-'9') a su valor numérico

process_digit:
    // Actualizar el valor decimal
    mul w2, w2, w5               // decimal *= 16 (usando w5)
    add w2, w2, w4               // decimal += valor del carácter

    // Incrementar el índice i++
    add x3, x3, #1               // i++

    // Repetir el bucle
    b convert_loop

end_conversion:
    // Guardar el resultado decimal en memoria
    str w2, [x1]                 // Guardar el valor decimal en result

    // Salir del programa
    mov x8, #93                  // Código de sistema para salida en Linux
    svc #0                       // Llamada al sistema para terminar el programa