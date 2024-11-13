// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: min.s
// Descripción: (Recorrido de arreglos) Encontrar el mínimo en un arreglo
// Versión: 1.0
// ====================================================
// Código en C#
//
// int FindMin(int[] arr) {
//     int min = arr[0];
//     for (int i = 1; i < arr.Length; i++) {
//         if (arr[i] < min) {
//             min = arr[i];
//         }
//     }
//     return min;
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

    // Inicializar el mínimo con el primer elemento
    ldr w0, [x2]               // Cargar el primer elemento en w0 (mínimo provisional)
    add x2, x2, #4             // Avanzar al siguiente elemento
    subs w1, w1, #1            // Decrementar el contador de tamaño

loop:
    cbz w1, end                // Si el tamaño es cero, termina el bucle
    ldr w3, [x2], #4           // Cargar el siguiente elemento y avanzar el puntero
    subs w1, w1, #1            // Decrementar el tamaño en 1
    cmp w3, w0                 // Comparar el elemento actual con el mínimo
    csel w0, w3, w0, lt        // Si el elemento es menor, actualizar el mínimo
    b loop                     // Repetir el ciclo

end:
    // Preparar para salir y pasar el resultado a x0
    mov w0, w0                 // Asegurar que el valor mínimo esté en w0

    // Salida en GDB
    mov x8, #93                // Código de sistema para salida en Linux
    svc #0                     // Llamada al sistema para terminar el programa