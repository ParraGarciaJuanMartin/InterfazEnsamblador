// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: max.s
// Descripción: (Recorrido de arreglos) Encontrar el máximo en un arreglo
// Versión: 1.2
// ====================================================
// Código en C#
//
// int FindMax(int[] arr) {
//     int max = arr[0];
//     for (int i = 1; i < arr.Length; i++) {
//         if (arr[i] > max) {
//             max = arr[i];
//         }
//     }
//     return max;
// }
//
// ====================================================

.section .data
array:      .word 5, 3, 9, 2, 8, 7       // Valores del arreglo de ejemplo
size:       .word 6                      // Tamaño del arreglo

.section .text
.global _start

_start:
    // Cargar el tamaño del arreglo y la dirección base
    ldr x1, =size              // Cargar el tamaño del arreglo en x1 (64-bit)
    ldr w1, [x1]               // Desreferenciar para obtener el valor real (32-bit)
    ldr x2, =array             // Dirección base del arreglo en x2

    // Inicializar el máximo con el primer elemento
    ldr w0, [x2]               // Cargar el primer elemento en w0 (máximo provisional)
    add x2, x2, #4             // Avanzar al siguiente elemento
    subs w1, w1, #1            // Decrementar el contador de tamaño

loop:
    cbz w1, end                // Si el tamaño es cero, termina el bucle
    ldr w3, [x2], #4           // Cargar el siguiente elemento y avanzar el puntero
    subs w1, w1, #1            // Decrementar el tamaño en 1
    cmp w3, w0                 // Comparar el elemento actual con el máximo
    csel w0, w3, w0, gt        // Si el elemento es mayor, actualizar el máximo
    b loop                     // Repetir el ciclo

end:
    // Preparar para salir y pasar el resultado a x0
    mov w0, w0                 // Asegurar que el valor máximo esté en w0

    // Salida en GDB
    mov x8, #93                // Código de sistema para salida en Linux
    svc #0                     // Llamada al sistema para terminar el programa