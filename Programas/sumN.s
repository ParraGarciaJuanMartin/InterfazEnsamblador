// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: sumN.s
// Descripción:(Bucles y contadores) Suma de los N primeros números naturales
// Versión:4.11
// ====================================================
// Descripción en C# :
// 
// int SumarNumerosNaturales(int N) {
//    int suma = 0;
//    for (int i = 1; i <= N; i++) {
//        suma += i;
//  }
//  return suma;
//}
// ----------------------------------------------------

.section .data
N:     .word 10            // Valor de N (puedes cambiarlo para otras pruebas)
res:   .word 0             // Variable donde se guardará el resultado de la suma

.section .text
.global _start

_start:
    ldr x1, =N             // Cargar la dirección de N en x1
    ldr w0, [x1]           // Cargar el valor de N en w0 (ejemplo: N = 10)
    mov w1, 0              // Inicializar suma en 0 en w1
    mov w2, 1              // Inicializar contador en 1 en w2

loop:
    cmp w2, w0             // Comparar contador (w2) con N (w0)
    bgt end_loop           // Si w2 > w0, salir del bucle

    add w1, w1, w2         // Sumar contador a suma
    add w2, w2, 1          // Incrementar contador

    b loop                 // Repetir el bucle

end_loop:
    ldr x1, =res           // Cargar la dirección de res en x1
    str w1, [x1]           // Guardar la suma final en res

    // Terminar el programa
    mov w8, 93             // syscall número de "exit" en Linux
    mov x0, 0              // Código de salida 0 (éxito)
    svc 0                  // Llamar al sistema para terminar
