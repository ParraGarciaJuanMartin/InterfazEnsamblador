// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: log2.s
// Descripción: (Búsqueda en arreglos) Búsqueda binaria en un arreglo ordenado
// Versión: 1.0
// ====================================================
// Código en C#
//
// int BinarySearch(int[] arr, int target) {
//     int left = 0, right = arr.Length - 1;
//     while (left <= right) {
//         int mid = left + (right - left) / 2;
//         if (arr[mid] == target) {
//             return mid; // Índice donde se encuentra el elemento
//         } else if (arr[mid] < target) {
//             left = mid + 1;
//         } else {
//             right = mid - 1;
//         }
//     }
//     return -1; // Elemento no encontrado
// }
//
// ====================================================




.section .data
array:      .word 1, 3, 5, 7, 9, 11, 13  // Arreglo ordenado de ejemplo
size:       .word 7                      // Tamaño del arreglo
target:     .word 9                      // Elemento a buscar

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección base
    ldr x1, =size              // Cargar el tamaño del arreglo en x1 (64-bit)
    ldr w1, [x1]               // Desreferenciar para obtener el tamaño real (32-bit)
    ldr x2, =array             // Dirección base del arreglo en x2
    ldr x3, =target            // Cargar la dirección del "target" en x3
    ldr w3, [x3]               // Desreferenciar para obtener el valor del "target"

    // Inicializar los índices de los límites izquierdo y derecho
    mov w4, #0                 // Índice izquierdo (left) en w4
    sub w5, w1, #1             // Índice derecho (right) en w5, que es size - 1

binary_search_loop:
    cmp w4, w5                 // Comparar left y right
    bgt not_found              // Si left > right, terminar la búsqueda (no encontrado)

    // Calcular mid = left + (right - left) / 2
    add w6, w4, w5             // mid = left + right
    lsr w6, w6, #1             // mid = (left + right) / 2

    // Cargar array[mid] en w7
    mov x7, x2                 // Copiar la dirección base del arreglo en x7
    add x7, x7, x6, lsl #2     // x7 apunta a array[mid] (cada elemento es de 4 bytes)
    ldr w7, [x7]               // Cargar el valor de array[mid] en w7

    cmp w7, w3                 // Comparar array[mid] con target
    beq found                  // Si son iguales, encontramos el target

    // Si array[mid] < target, ajustar el índice izquierdo (left = mid + 1)
    blt adjust_left
    // Si array[mid] > target, ajustar el índice derecho (right = mid - 1)
    mov w5, w6
    sub w5, w5, #1
    b binary_search_loop

adjust_left:
    add w4, w6, #1             // Ajustar left = mid + 1
    b binary_search_loop       // Repetir el ciclo

not_found:
    mov w0, #-1                // Valor de retorno -1 para indicar "no encontrado"
    b end

found:
    mov w0, w6                 // Mover el índice encontrado a w0

end:
    // Preparar para salir
    mov x8, #93                // Código de sistema para salida en Linux
    svc #0                     // Llamada al sistema para terminar el programa

