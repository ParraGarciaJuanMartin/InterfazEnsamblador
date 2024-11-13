// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 12/Nov/2024
// Programa: bitCount.s
// Descripción: (Operaciones bit a bit) Contar los bits activados en un número
// Versión: 1.0
// ====================================================
// Código en C:
//
// int bitCount(int num) {
//     int count = 0;
//     while (num) {
//         count += num & 1;
//         num >>= 1;
//     }
//     return count;
// }
//
// ====================================================

.section .data
num:    .word 0b10101101       // Número de ejemplo para contar los bits activados (173 en decimal)

.section .text
.global _start

_start:
    // Cargar el número desde la memoria en el registro w0
    ldr x0, =num              // Cargar la dirección de 'num' en x0
    ldr w0, [x0]              // Cargar el valor de 'num' en w0

    // Inicializar el contador de bits activados en w1
    mov w1, #0                // w1 = 0 (contador de bits activados)

count_loop:
    // Comprobar si w0 es cero, en cuyo caso salir del bucle
    cbz w0, end_count         // Si w0 es 0, saltar a end_count

    // Sumar el bit menos significativo de w0 al contador
    and w2, w0, #1            // w2 = w0 & 1 (obtenemos el bit menos significativo)
    add w1, w1, w2            // w1 += w2 (sumar el bit al contador)

    // Desplazar a la derecha para analizar el siguiente bit
    lsr w0, w0, #1            // w0 >>= 1

    // Repetir el bucle
    b count_loop

end_count:
    // Ahora w1 contiene la cuenta de bits activados

    // Salida del programa
    mov x8, #93               // Código de sistema para salida en Linux
    svc #0                    // Llamada al sistema para terminar el programa
