// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 07/Nov/2024
// Programa: atoi.s
// Descripción: Conversión de ASCII a entero
// Versión: 1.8
// ====================================================

// Descripción en C# : 
// int result = 0;
// string input = "12345";
// for (int i = 0; i < input.Length; i++) {
//     int digit = input[i] - '0';
//     result = result * 10 + digit;
// }
// Console.WriteLine(result);
// ----------------------------------------------------

.global _start

.section .data
input_string: .asciz "12345"      // Cadena ASCII a convertir
string_len: .int 5                 // Longitud de la cadena de entrada
decimal_base: .int 10              // Valor 10 para multiplicación

.section .bss
output_buffer: .space 12           // Espacio para almacenar el número convertido a ASCII

.section .text
_start:
    // Inicialización
    ldr x0, =input_string           // Dirección del string ASCII de entrada
    ldr w1, =5                      // Longitud de la cadena (literalmente 5 en este caso)
    mov x2, #0                      // Acumulador de resultado (entero)
    mov w3, #0                      // Índice del string (usar w3 para 32 bits)
    ldr w5, =decimal_base           // Cargar el valor 10 desde la sección de datos

convert_loop:
    ldrb w4, [x0, x3]               // Cargar el byte actual del string en w4
    sub w4, w4, #'0'                // Convertir ASCII a valor numérico en w4
    mul x2, x2, x5                  // Multiplicar resultado parcial (x2) por el valor en x5 (10)
    add x2, x2, x4                  // Agregar el dígito convertido al resultado acumulado
    add w3, w3, #1                  // Incrementar índice
    cmp w3, w1                      // Comparar índice con la longitud
    b.lt convert_loop               // Repetir hasta el final del string

    // Convertir entero a ASCII para mostrar en la consola
    ldr x6, =output_buffer          // Dirección del buffer de salida
    add x6, x6, #11                 // Comenzar desde el final del buffer
    mov w7, #0x30                   // ASCII '0'

convert_to_ascii:
    udiv x4, x2, x5                 // x4 = x2 / 10 (usar el valor en x5)
    msub x3, x4, x5, x2             // x3 = x2 - (x4 * 10) (remainder)
    add w3, w3, w7                  // Convertir dígito a ASCII
    strb w3, [x6, #-1]!             // Almacenar dígito en el buffer
    mov x2, x4                      // Actualizar x2 con cociente
    cbnz x2, convert_to_ascii       // Repetir si el cociente no es cero

    // Mostrar resultado en consola
    mov x1, x6                      // Dirección de la cadena en x1
    mov x2, #12                     // Longitud estimada del número convertido
    mov x8, #64                     // Syscall write
    mov x0, #1                      // Descriptor de archivo (1 para stdout)
    svc #0                          // Llamar al sistema para escribir en la consola

exit:
    mov x8, #93                     // Syscall exit
    svc #0                          // Llamar al sistema para salir
