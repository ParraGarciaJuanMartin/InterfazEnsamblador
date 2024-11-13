// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: nSquare.s
// Descripción: (Algoritmos de ordenamiento) Ordenamiento burbuja
// Versión: 1.1
// ====================================================
// Código en C#
//
// void BubbleSort(int[] arr) {
//     int n = arr.Length;
//     for (int i = 0; i < n - 1; i++) {
//         for (int j = 0; j < n - i - 1; j++) {
//             if (arr[j] > arr[j + 1]) {
//                 // Intercambia arr[j] y arr[j + 1]
//                 int temp = arr[j];
//                 arr[j] = arr[j + 1];
//                 arr[j + 1] = temp;
//             }
//         }
//     }
// }
//
// ====================================================


.section .data
array:      .word 7, 3, 5, 1, 9, 2        // Arreglo desordenado de ejemplo
size:       .word 6                       // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección base
    ldr x1, =size             // Cargar el tamaño del arreglo en x1 (64-bit)
    ldr w1, [x1]              // Desreferenciar para obtener el tamaño real (32-bit)
    ldr x2, =array            // Dirección base del arreglo en x2

    mov w8, w1                // Guardar el tamaño en w8 para el ciclo externo (n)
    sub w8, w8, #1            // n - 1 (límite superior del ciclo externo)

outer_loop:
    cbz w8, end               // Si w8 es cero, el arreglo está ordenado

    mov w9, w8                // Configurar límite del ciclo interno (n - i - 1)

inner_loop:
    cbz w9, decrement_outer   // Si w9 es cero, termina el ciclo interno

    // Calcular las direcciones de arr[j] y arr[j+1]
    mov x3, x2                // Copiar dirección base en x3
    mov x4, x2                // Copiar dirección base en x4
    add x3, x3, x9, lsl #2    // x3 = &arr[j] usando x9 en lugar de w9
    sub x10, x9, #1
    add x4, x4, x10, lsl #2   // x4 = &arr[j + 1] usando x10 en lugar de w10

    // Cargar arr[j] en w5 y arr[j+1] en w6
    ldr w5, [x3]              // arr[j]
    ldr w6, [x4]              // arr[j + 1]

    // Comparar y, si es necesario, intercambiar
    cmp w5, w6
    ble skip_swap             // Si arr[j] <= arr[j+1], no intercambiar

    // Intercambiar arr[j] y arr[j+1]
    str w6, [x3]              // arr[j] = arr[j + 1]
    str w5, [x4]              // arr[j + 1] = arr[j]

skip_swap:
    subs w9, w9, #1           // Decrementar el índice interno (j)
    b inner_loop              // Repetir ciclo interno

decrement_outer:
    subs w8, w8, #1           // Decrementar el índice externo (i)
    b outer_loop              // Repetir ciclo externo

end:
    // Preparar para salir
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa