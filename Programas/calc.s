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
a:       .word 20               // Primer operando
b:       .word 4                // Segundo operando
op:      .byte '+'              // Operación ('+', '-', '*', '/')
result:  .word 0                // Resultado

.section .text
.global _start

_start:
    // Inicialización
    ldr x0, =a                  // Dirección del primer operando
    ldr w0, [x0]                // Cargar el primer operando en w0
    ldr x1, =b                  // Dirección del segundo operando
    ldr w1, [x1]                // Cargar el segundo operando en w1
    ldr x2, =op                 // Dirección de la operación
    ldrb w2, [x2]               // Cargar la operación en w2
    ldr x3, =result             // Dirección del resultado

    // Control de flujo según la operación
    cmp w2, #'+'                // Comparar con '+'
    beq do_add                  // Si es '+', ir a la suma
    cmp w2, #'-'                // Comparar con '-'
    beq do_sub                  // Si es '-', ir a la resta
    cmp w2, #'*'                // Comparar con '*'
    beq do_mul                  // Si es '*', ir a la multiplicación
    cmp w2, #'/'                // Comparar con '/'
    beq do_div                  // Si es '/', ir a la división
    b default_case              // Si no coincide, ir al caso por defecto

do_add:
    add w4, w0, w1              // Resultado = a + b
    b save_result

do_sub:
    sub w4, w0, w1              // Resultado = a - b
    b save_result
do_mul:
    mul w4, w0, w1              // Resultado = a * b
    b save_result

do_div:
    cmp w1, #0                  // Verificar división por 0
    beq default_case            // Si b == 0, ir al caso por defecto
    udiv w4, w0, w1             // Resultado = a / b
    b save_result

default_case:
    mov w4, #0                  // Resultado = 0 (por defecto)

save_result:
    str w4, [x3]                // Guardar el resultado en memoria

    // Salir del programa
    mov x8, #93                 // Código de sistema para salida en Linux
    svc #0                      // Llamada al sistema para terminar el programa
