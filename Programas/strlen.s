// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: 	
// Descripción: (Manipulación de cadenas) Calcular la longitud de una cadena
// Versión: 1.1
// ====================================================
// Código en C
//
// int strlen(const char* str) {
//     int length = 0;
//     while (str[length] != '\0') {
//         length++;
//     }
//     return length;
// }
//
// ====================================================


.section .data
string: .asciz "Hola, ARM64!"    // Cadena de ejemplo terminada en '\0'

.section .text
.global _start

_start:
    // Cargar la dirección de la cadena en x0
    ldr x0, =string               // Dirección de la cadena en x0

    // Llamar a strlen
    bl strlen                     // Llamar a strlen

    // Salir del programa
    mov x8, #93                   // Código de sistema para salida en Linux
    svc #0                        // Llamada al sistema para terminar el programa

// strlen(const char *str)
strlen:
    mov w1, #0                    // Inicializar el contador de longitud (length = 0)

strlen_loop:
    ldrb w2, [x0, x1]             // Leer el byte actual de la cadena en w2 (usando x1 como offset)
    cmp w2, #0                    // Comparar con '\0'
    beq end_strlen                // Si es '\0', fin de la cadena
    add w1, w1, #1                // Incrementar contador (length++)
    add x1, x1, #1                // Incrementar x1 como offset para el siguiente byte
    b strlen_loop                 // Repetir el ciclo

end_strlen:
    mov w0, w1                    // Guardar la longitud en w0 como valor de retorno
    ret                           // Retornar al llamador