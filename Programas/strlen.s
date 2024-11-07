// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 07/Nov/2024
// Programa: .s
// Descripción: Este programa calcula la longitud de una cadena terminada en '\0'
// Versión:3.16
// ====================================================
// Descripción en C :
// int string_length(char *str) {
//     int length = 0;
//     while (str[length] != '\0') {
//         length++;
//     }
//     return length;
// }
// ----------------------------------------------------


// Sección de datos
.section .data
mensaje: .asciz "Longitud de la cadena: "       // Mensaje de salida
cadena: .asciz "Cadena de prueba ARM64"         // Cadena de 21 caracteres terminada en '\0'
newline: .asciz "\n"                            // Salto de línea

// Sección de bss para almacenar longitud en ASCII
.section .bss
.balign 4
buffer: .skip 10                                // Buffer para almacenar la longitud convertida a ASCII

// Sección de código
.section .text
.global _start

_start:
    // Preparar el puntero a la cadena
    ADRP x1, cadena                        // Cargar la dirección base de 'cadena'
    ADD x1, x1, :lo12:cadena               // Dirección completa de la cadena en x1

    // Calcular la longitud de la cadena
    MOV x2, #0                             // Inicializar contador de longitud en x2

loop:
    LDRB w3, [x1, x2]                      // Leer un byte de la cadena
    CBZ w3, fin                            // Si es nulo ('\0'), salir del bucle
    ADD x2, x2, #1                         // Incrementar contador de longitud
    B loop                                 // Repetir el bucle

fin:
    // Mostrar el mensaje "Longitud de la cadena: "
    MOV x0, #1                             // Descriptor de archivo (1 = salida estándar)
    ADRP x1, mensaje                       // Dirección base de 'mensaje'
    ADD x1, x1, :lo12:mensaje              // Dirección completa de 'mensaje' en x1
    MOV x2, #22                            // Longitud del mensaje (incluye espacio final)
    MOV x8, #64                            // Código de llamada para write
    SVC #0                                 // Llamada al sistema para escribir el mensaje

    // Convertir longitud (x2) a ASCII y mostrarlo
    MOV x0, x2                             // Pasar la longitud a x0 para la conversión
    ADRP x1, buffer                        // Dirección base del buffer
    ADD x1, x1, :lo12:buffer               // Dirección completa de buffer en x1
    BL itoa                                // Llamar a la función de conversión

    // Imprimir la longitud convertida
    MOV x0, #1                             // Descriptor de archivo (1 = salida estándar)
    ADRP x1, buffer                        // Dirección del buffer con el número en ASCII
    ADD x1, x1, :lo12:buffer               // Dirección completa de buffer
    MOV x2, #10                            // Tamaño máximo del buffer
    MOV x8, #64                            // Código de llamada para write
    SVC #0                                 // Llamada al sistema para escribir el número

    // Salto de línea
    MOV x0, #1                             // Descriptor de archivo
    ADRP x1, newline                       // Dirección base de newline
    ADD x1, x1, :lo12:newline              // Dirección completa de newline
    MOV x2, #1                             // Longitud del salto de línea
    MOV x8, #64                            // Código de llamada para write
    SVC #0                                 // Llamada al sistema para escribir

    // Terminar el programa
    MOV x8, #93                            // Código de llamada para exit
    MOV x0, #0                             // Código de salida 0
    SVC #0                                 // Llamada al sistema para salir

// Función para convertir un número en x0 a cadena ASCII en buffer x1
// Usa una base de 10 (decimal) y almacena el resultado en x1
itoa:
    MOV x4, x0                             // Mueve el número a x4
    MOV x5, #10                            // Cargar el valor 10 en x5 para la división
    ADD x1, x1, #10                        // Ajusta el puntero al final del buffer
convert_loop:
    UDIV x6, x4, x5                        // Divide x4 entre 10 (cociente en x6)
    MADD x7, x6, x5, xzr                   // Calcula x6 * 10
    SUB x7, x4, x7                         // Obtiene el resto (x4 - (x6 * 10))
    ADD x7, x7, '0'                        // Convierte el dígito a ASCII
    SUB x1, x1, #1                         // Retrocede en el buffer
    STRB w7, [x1]                          // Almacena el dígito en el buffer
    MOV x4, x6                             // Actualiza x4 con el cociente
    CBNZ x4, convert_loop                  // Repite si x4 no es cero
    RET                                    // Regresa de la función
