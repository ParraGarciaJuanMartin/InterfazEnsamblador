// ============================================
// Programador: Parra García Juan Martín
// Fecha: 07/Nov/2024
// Programa: celsius.s
// Descripción: Convertir temperatura de Celsius a Fahrenheit y mostrar en consola
// Versión: 1.02
// ============================================
// #include <stdio.h>
//
// int main() {
//     float celsius = 25.0;
//     float fahrenheit = (celsius * 9.0 / 5.0) + 32.0;
//     printf("Celsius: %.2f -> Fahrenheit: %.2f\n", celsius, fahrenheit);
//     return 0;
// }
// ----------------------------------------------------


.section .data
celsius_input:  .float 25.0                // Temperatura en Celsius
msg_celsius:    .asciz "Celsius: "
msg_fahrenheit: .asciz " Fahrenheit: "
newline:        .asciz "\n"

.section .bss
buffer: .space 32                          // Espacio para almacenar la salida

.section .text
.global _start

_start:
    // Cargar el valor de Celsius desde la memoria
    ldr x1, =celsius_input    // Usar un registro de propósito general
    ldr s0, [x1]              // Cargar el valor de Celsius en s0

    // Mostrar "Celsius: "
    adr x0, msg_celsius
    bl print_string

    // Convertir Celsius a cadena y mostrar
    bl float_to_string
    bl print_string

    // Mostrar " Fahrenheit: "
    adr x0, msg_fahrenheit
    bl print_string

    // Convertir de Celsius a Fahrenheit
    // Paso 1: Multiplicar Celsius por 9
    mov w1, #9               // w1 = 9
    scvtf s1, w1             // Convertir 9 a punto flotante (float)
    fmul s0, s0, s1          // s0 = s0 * 9 (Celsius * 9)

    // Paso 2: Dividir por 5
    mov w2, #5               // w2 = 5
    scvtf s2, w2             // Convertir 5 a punto flotante (float)
    fdiv s0, s0, s2          // s0 = s0 / 5

    // Paso 3: Sumar 32
    mov w3, #32              // w3 = 32
    scvtf s3, w3             // Convertir 32 a punto flotante (float)
    fadd s0, s0, s3          // s0 = s0 + 32 (resultado final)

    // Convertir Fahrenheit a cadena y mostrar
    bl float_to_string
    bl print_string

    // Imprimir salto de línea
    adr x0, newline
    bl print_string

    // Salir del programa
    mov x0, #0               // Código de salida 0
    mov x8, #93              // syscall exit
    svc #0

// --------------------------------------------
// Función para imprimir una cadena
// Entrada: x0 -> dirección de la cadena
// --------------------------------------------
print_string:
    mov x1, x0              // x1 = dirección de la cadena
    mov x2, #32             // Tamaño máximo a imprimir
    mov x8, #64             // syscall write
    mov x0, #1              // File descriptor (stdout)
    svc #0
    ret

// --------------------------------------------
// Función para convertir float en s0 a cadena
// Salida: buffer (en .bss)
// --------------------------------------------
float_to_string:
    // Usa la instrucción `fcvtzs` para convertir float a entero
    fcvtzs w0, s0           // Convertir float en s0 a entero (w0)
    
    // Convertir entero en w0 a cadena ASCII
    adr x1, buffer + 31     // Puntero al final del buffer
    mov w2, #0              // Contador de dígitos

convert_loop:
    mov w4, #10             // Divisor
    udiv w3, w0, w4         // w3 = w0 / 10
    msub w4, w0, w3, w4     // w4 = w0 - (w3 * 10)
    add w4, w4, #'0'        // Convertir dígito a ASCII
    strb w4, [x1, -1]!      // Almacenar carácter y mover puntero
    add w2, w2, #1          // Incrementar contador de dígitos
    mov w0, w3              // Actualizar w0 para el siguiente dígito
    cbnz w0, convert_loop   // Repetir mientras w0 != 0

    // Ajustar puntero para comenzar desde el primer dígito
    add x0, x1, #1
    ret


