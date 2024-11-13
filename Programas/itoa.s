// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: itoa.s
// Descripción: (Conversión de tipos de datos) Conversión de entero a ASCII
// Versión: 1.0
// ====================================================
// Código en C
//
// void itoa(int num, char* buffer) {
//     int i = 0;
//     int isNegative = 0;
//
//     // Manejo de números negativos
//     if (num < 0) {
//         isNegative = 1;
//         num = -num;
//     }
//
//     // Extraer dígitos
//     do {
//         buffer[i++] = (num % 10) + '0';
//         num /= 10;
//     } while (num > 0);
//
//     // Agregar signo si es negativo
//     if (isNegative) {
//         buffer[i++] = '-';
//     }
//
//     // Terminar cadena con \0 y revertirla
//     buffer[i] = '\0';
//     strrev(buffer);  // Función para invertir la cadena
// }
//
// ====================================================


.section .data
num:     .word -12345          // Número de ejemplo a convertir
buffer:  .space 12             // Espacio para la cadena ASCII (incluye \0 y signo)

.section .text
.global _start

_start:
    // Cargar el número en w0
    ldr w0, =num               // Cargar el número en w0

    // Llamar a itoa
    ldr x1, =buffer            // Dirección del buffer de salida en x1
    bl itoa                    // Llamar a itoa

    // Salir del programa
    mov x8, #93                // Código de sistema para salida en Linux
    svc #0                     // Llamada al sistema para terminar el programa

// itoa(int num, char* buffer)
itoa:
    // Inicializar puntero al buffer
    mov x2, x1                 // x2 es el puntero de escritura en buffer
    mov w3, #0                 // i = 0, índice inicial para el buffer

    // Manejo de números negativos
    cmp w0, #0                 // Comprobar si el número es negativo
    bge skip_negative          // Si num >= 0, saltar
    neg w0, w0                 // Si es negativo, convertir num a positivo
    mov w4, #1                 // isNegative = 1
    b positive_done

skip_negative:
    mov w4, #0                 // isNegative = 0

positive_done:
    // Cargar el valor 10 en un registro para divisiones
    mov w10, #10               // Preparar constante 10 en w10

extract_digits:
    udiv w5, w0, w10           // Dividir num entre 10, w5 = num / 10
    msub w6, w5, w10, w0       // Resto: w6 = num - (w5 * 10)
    add w6, w6, #'0'           // Convertir el dígito a ASCII: w6 = (num % 10) + '0'
    strb w6, [x2, x3, lsl #0]  // Almacenar dígito en buffer[i] usando x3 como offset
    add x3, x3, #1             // Incrementar índice i
    mov w0, w5                 // num = num / 10
    cbnz w0, extract_digits    // Repetir si num != 0

    // Agregar signo si es negativo
    cmp w4, #0                 // Comprobar si el número era negativo
    beq skip_sign              // Si no es negativo, saltar
    mov w6, #'-'               // Cargar '-' en w6
    strb w6, [x2, x3, lsl #0]  // Almacenar '-' en buffer[i]
    add x3, x3, #1             // Incrementar índice i

skip_sign:
    // Terminar la cadena con '\0'
    mov w6, #0                 // '\0' en w6
    strb w6, [x2, x3, lsl #0]  // buffer[i] = '\0'

    // Invertir la cadena en el buffer
    mov x4, #0                 // Índice inicial para el inicio de la cadena
    sub x3, x3, #1             // Ajustar x3 al último carácter de la cadena

reverse_loop:
    cmp x4, x3                 // Comparar índices x4 y x3
    bge end_itoa               // Si se cruzan, terminar inversión

    // Intercambiar buffer[x4] y buffer[x3]
    ldrb w8, [x2, x4, lsl #0]  // Leer buffer[x4] en w8
    ldrb w9, [x2, x3, lsl #0]  // Leer buffer[x3] en w9
    strb w9, [x2, x4, lsl #0]  // Almacenar buffer[x3] en buffer[x4]
    strb w8, [x2, x3, lsl #0]  // Almacenar buffer[x4] en buffer[x3]

    // Incrementar y decrementar índices
    add x4, x4, #1             // x4++
    sub x3, x3, #1             // x3--
    b reverse_loop             // Repetir el ciclo

end_itoa:
    ret                        // Retornar al llamador