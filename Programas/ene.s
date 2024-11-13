// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: ene.s
// Descripción: (Búsqueda en arreglos) Búsqueda lineal
// Versión: 1.1
// ====================================================
// Código en C#
//
// int LinearSearch(int[] arr, int target) {
//     for (int i = 0; i < arr.Length; i++) {
//         if (arr[i] == target) {
//             return i; // Índice donde se encuentra el elemento
//         }
//     }
//     return -1; // Elemento no encontrado
// }
//
// ====================================================


.section .data
array:      .word 5, 3, 9, 2, 8, 7       // Valores del arreglo de ejemplo
size:       .word 6                      // Tamaño del arreglo
target:     .word 9                      // Elemento que se busca

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección base
    ldr x1, =size              // Cargar el tamaño del arreglo en x1 (64-bit)
    ldr w1, [x1]               // Desreferenciar para obtener el valor real (32-bit)
    ldr x2, =array             // Dirección base del arreglo en x2
    ldr x3, =target            // Cargar la dirección de la variable "target" en x3
    ldr w3, [x3]               // Desreferenciar para obtener el valor de "target" en w3
    
    mov w4, #0                 // Inicializar el índice en w4

loop:
    cbz w1, not_found          // Si el tamaño es cero, termina el bucle (no encontrado)
    ldr w5, [x2], #4           // Cargar el elemento actual y avanzar el puntero
    cmp w5, w3                 // Comparar el elemento actual con el target
    beq found                  // Si es igual, hemos encontrado el elemento
    subs w1, w1, #1            // Decrementar el tamaño en 1
    add w4, w4, #1             // Incrementar el índice en 1
    b loop                     // Repetir el ciclo

not_found:
    mov w0, #-1                // Valor de retorno -1 para indicar "no encontrado"
    b end

found:
    mov w0, w4                 // Mover el índice encontrado a w0

end:
    // Preparar para salir
    mov x8, #93                // Código de sistema para salida en Linux
    svc #0                     // Llamada al sistema para terminar el programa