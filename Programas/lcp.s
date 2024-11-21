// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: lcp.s
// Descripción: Encontrar el prefijo común más largo en cadenas
// Versión: 1.0
// ====================================================
// static string PrefijoComunMasLargo(string str1, string str2)  
// {
    // Inicializamos un índice para recorrer ambas cadenas
    // int i = 0;

    // Empezamos un bucle que se ejecutará mientras las cadenas tengan caracteres en esa posición y sean iguales
    // while (i < str1.Length && i < str2.Length && str1[i] == str2[i])
    // {
        // Incrementamos el índice para seguir comprobando el siguiente carácter
        // i++;
    // }

    // Devuelve la subcadena de str1 que contiene los primeros i caracteres, que es el prefijo común más largo
    // return str1.Substring(0, i);
// }
// ====================================================

    .data
string1:    .asciz "raspberry"     // Primera cadena
string2:    .asciz "raspberrian"   // Segunda cadena
lcp_result: .word 0                // Resultado: longitud del LCP

    .text
    .global _start

// Función principal
_start:
    ldr x0, =string1               // Cargar dirección de la primera cadena
    ldr x1, =string2               // Cargar dirección de la segunda cadena
    bl find_lcp                    // Llamar a la función find_lcp

    // Guardar resultado en lcp_result
    ldr x2, =lcp_result
    str w0, [x2]

    // Salida del programa
    mov x8, #93                   // syscall exit
    mov x0, #0                    // exit code
    svc #0

// Función: Encontrar LCP entre dos cadenas
// Entradas:
//   x0: Dirección de la primera cadena
//   x1: Dirección de la segunda cadena
// Salidas:
//   w0: Longitud del LCP
find_lcp:
    mov w2, #0                    // Inicializar longitud del LCP (contador)

compare_loop:
    ldrb w3, [x0], #1             // Leer un byte de string1 y avanzar x0
    ldrb w4, [x1], #1             // Leer un byte de string2 y avanzar x1
    cmp w3, w4                    // Comparar los bytes
    b.ne end_lcp                  // Si son diferentes, salir del bucle
    cbz w3, end_lcp               // Si es fin de cadena (byte nulo), salir
    add w2, w2, #1                // Incrementar el contador
    b compare_loop                // Repetir el bucle

end_lcp:
    mov w0, w2                    // Retornar longitud del LCP en w0
    ret