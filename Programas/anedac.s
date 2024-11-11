// ==================================================== 
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: anedac.s
// Descripción: Invertir una cadena
// Versión: 1.0
// ==================================================== 
// Descripción en C# :
// string InvertirCadena(string cadena) {
//     char[] caracteres = cadena.ToCharArray();
//     Array.Reverse(caracteres);
//     return new string(caracteres);
// }
// ----------------------------------------------------

    .data
cadena:    .asciz "Hola ARM64"        // Cadena original
longitud:  .word 10                   // Longitud de la cadena (sin incluir null)

    .text
    .global _start
    .global invertir_cadena

_start:
    ldr x0, =cadena                   // Dirección de la cadena en x0
    ldr x1, =longitud                 // Dirección de la longitud en x1
    ldr w1, [x1]                      // Carga la longitud en w1
    bl invertir_cadena                // Llama a la función invertir_cadena

    // Terminar el programa
    mov x8, #93                       // syscall: exit
    svc #0                            // Llama al sistema para salir

// Función invertir_cadena
// Entrada: x0 = dirección de la cadena, w1 = longitud de la cadena
// Salida: La cadena en x0 se invierte en su lugar
invertir_cadena:
    mov w2, #0                        // Índice inicial i = 0
    sub w1, w1, #1                    // Último índice j = longitud - 1

invertir_loop:
    cmp w2, w1                        // Compara i y j
    bge end_invertir                  // Si i >= j, terminar

    ldrb w3, [x0, w2]                 // Cargar el carácter en posición i
    ldrb w4, [x0, w1]                 // Cargar el carácter en posición j
    strb w4, [x0, w2]                 // Escribir el carácter en j en i
    strb w3, [x0, w1]                 // Escribir el carácter en i en j

    add w2, w2, #1                    // i++
    sub w1, w1, #1                    // j--
    b invertir_loop                   // Repite el ciclo

end_invertir:
    ret                               // Regresa
