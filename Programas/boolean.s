// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 07/Nov/2024
// Programa: .s
// Descripción: Realizar operaciones AND, OR y XOR a nivel de bits en ARM64 Assembly y mostrar los resultados
// Versión: 1.0
// ====================================================
// Descripción en C# :
using System;

class Program
{
    static void Main()
    {
        // Definimos dos números
        int a = 5;  // En binario: 0101
        int b = 3;  // En binario: 0011
        
        // Operación AND
        int resultadoAnd = a & b;
        Console.WriteLine($"Resultado de AND (a & b): {resultadoAnd}");  // Imprime 1 (0001 en binario)

        // Operación OR
        int resultadoOr = a | b;
        Console.WriteLine($"Resultado de OR (a | b): {resultadoOr}");  // Imprime 7 (0111 en binario)

        // Operación XOR
        int resultadoXor = a ^ b;
        Console.WriteLine($"Resultado de XOR (a ^ b): {resultadoXor}");  // Imprime 6 (0110 en binario)
    }
}
// ----------------------------------------------------

.section .data
and_msg: .asciz "AND result: 0x"      // Mensaje para resultado de AND
or_msg:  .asciz "OR result:  0x"      // Mensaje para resultado de OR
xor_msg: .asciz "XOR result: 0x"      // Mensaje para resultado de XOR
newline: .asciz "\n"                  // Nueva línea para imprimir

.section .bss
buffer: .skip 16                      // Espacio para el resultado hexadecimal (64 bits)

.section .text
.global _start

_start:
    // Valores de entrada
    mov x0, 0x0F0F0F0F0F0F0F0F       // Valor 'a'
    mov x1, 0x00FF00FF00FF00FF       // Valor 'b'

    // Operación AND y mostrar resultado
    and x2, x0, x1                   // x2 = x0 & x1 (AND)
    ldr x1, =and_msg                 // Mensaje AND
    mov x2, 14                       // Longitud del mensaje "AND result: 0x"
    bl print_msg                     // Imprimir mensaje de AND
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Operación OR y mostrar resultado
    orr x2, x0, x1                   // x2 = x0 | x1 (OR)
    ldr x1, =or_msg                  // Mensaje OR
    mov x2, 14                       // Longitud del mensaje "OR result:  0x"
    bl print_msg                     // Imprimir mensaje de OR
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Operación XOR y mostrar resultado
    eor x2, x0, x1                   // x2 = x0 ^ x1 (XOR)
    ldr x1, =xor_msg                 // Mensaje XOR
    mov x2, 14                       // Longitud del mensaje "XOR result: 0x"
    bl print_msg                     // Imprimir mensaje de XOR
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Terminar programa
    mov x8, 93                       // syscall: exit
    mov x0, 0                        // Código de salida
    svc 0                            // Llamada al sistema para salir

// Subrutina para imprimir un mensaje
print_msg:
    mov x8, 64                       // syscall: write
    mov x0, 1                        // Descriptor de archivo: stdout
    svc 0
    ret

// Subrutina para convertir un número en hexadecimal y mostrarlo
print_hex:
    mov x3, 15                       // Contador de dígitos (64 bits en hexadecimal)
    ldr x5, =buffer                  // Cargar la dirección de 'buffer' en x5
convert_loop:
    and x4, x1, 0xF                  // Extraer los últimos 4 bits
    cmp x4, 9                        // Comparar si el valor está entre 0 y 9
    add x4, x4, '0'                  // Convertir a carácter (0-9)
    ble store_digit
    add x4, x4, 7                    // Convertir a letra (A-F)
store_digit:
    strb w4, [x5, x3]                // Guardar carácter en el buffer
    lsr x1, x1, 4                    // Desplazar número 4 bits a la derecha
    sub x3, x3, 1                    // Mover al siguiente dígito
    cbnz x3, convert_loop            // Repetir hasta completar
    mov x8, 64                       // syscall: write
    mov x0, 1                        // Descriptor de archivo: stdout
    mov x2, 16                       // Longitud de los 16 dígitos en el buffer
    svc 0
    ret


// Nombre: Parra García Juan Martín
// Fecha: 07/Nov/24
// Versión: 2.9
// Objetivo: Mostrar resultados simples en hexadecimal
// Descripción en C:
// uint64_t a = 0x47;
// uint64_t b = 0x24;
// uint64_t and_result = a & b;
// uint64_t or_result = a | b;
// uint64_t xor_result = a ^ b;
// Mostrar resultados en hexadecimal.

.section .data
and_msg: .asciz "AND result: 0x"      // Mensaje para resultado de AND
or_msg:  .asciz "OR result:  0x"      // Mensaje para resultado de OR
xor_msg: .asciz "XOR result: 0x"      // Mensaje para resultado de XOR
newline: .asciz "\n"                  // Nueva línea para imprimir
a_val: .quad 0x47                     // Valor 'a' simple en hexadecimal
b_val: .quad 0x24                     // Valor 'b' simple en hexadecimal

.section .bss
buffer: .skip 16                      // Espacio para el resultado hexadecimal (64 bits)

.section .text
.global _start

_start:
    // Cargar valores desde la memoria
    ldr x0, =a_val                    // Cargar dirección de 'a' en x0
    ldr x0, [x0]                      // Cargar valor de 'a' en x0
    ldr x1, =b_val                    // Cargar dirección de 'b' en x1
    ldr x1, [x1]                      // Cargar valor de 'b' en x1

    // Operación AND y mostrar resultado
    and x2, x0, x1                   // x2 = x0 & x1 (AND)
    ldr x1, =and_msg                 // Mensaje AND
    mov x2, 14                       // Longitud del mensaje "AND result: 0x"
    bl print_msg                     // Imprimir mensaje de AND
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Operación OR y mostrar resultado
    orr x2, x0, x1                   // x2 = x0 | x1 (OR)
    ldr x1, =or_msg                  // Mensaje OR
    mov x2, 14                       // Longitud del mensaje "OR result:  0x"
    bl print_msg                     // Imprimir mensaje de OR
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Operación XOR y mostrar resultado
    eor x2, x0, x1                   // x2 = x0 ^ x1 (XOR)
    ldr x1, =xor_msg                 // Mensaje XOR
    mov x2, 14                       // Longitud del mensaje "XOR result: 0x"
    bl print_msg                     // Imprimir mensaje de XOR
    mov x1, x2                       // Pasar valor a convertir en hexadecimal
    bl print_hex                     // Convertir y mostrar valor hexadecimal
    ldr x1, =newline
    mov x2, 1                        // Longitud de "\n"
    bl print_msg                     // Nueva línea

    // Terminar programa
    mov x8, 93                       // syscall: exit
    mov x0, 0                        // Código de salida
    svc 0                            // Llamada al sistema para salir

// Subrutina para imprimir un mensaje
print_msg:
    mov x8, 64                       // syscall: write
    mov x0, 1                        // Descriptor de archivo: stdout
    svc 0
    ret

// Subrutina para convertir un número en hexadecimal y mostrarlo
print_hex:
    mov x3, 15                       // Posición en el buffer (64 bits en hexadecimal)
    ldr x5, =buffer                  // Cargar la dirección de 'buffer' en x5
convert_loop:
    and x4, x1, 0xF                  // Extraer los últimos 4 bits
    cmp x4, 9                        // Comparar si el valor está entre 0 y 9
    add x4, x4, '0'                  // Convertir a carácter (0-9)
    ble store_digit
    add x4, x4, 7                    // Convertir a letra (A-F)
store_digit:
    strb w4, [x5, x3]                // Guardar carácter en el buffer
    lsr x1, x1, 4                    // Desplazar número 4 bits a la derecha
    sub x3, x3, 1                    // Mover al siguiente dígito
    cbnz x3, convert_loop            // Repetir hasta completar
    mov x8, 64                       // syscall: write
    mov x0, 1                        // Descriptor de archivo: stdout
    mov x2, 16                       // Longitud de los 16 dígitos en el buffer
    svc 0
    ret
