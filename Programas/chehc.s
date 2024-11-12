// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 11/Nov/2024
// Programa: chehc.s
// Descripción: Verificar si una cadena es un palíndromo
// Versión: 1.0

// ----------------------------------------------------
//static void Main()
//    {
//        Console.WriteLine("Introduce una cadena para verificar si es un palíndromo:");
//        string input = Console.ReadLine();
//        
//        if (EsPalindromo(input))
//        {
//            Console.WriteLine("La cadena es un palíndromo.");
//        }
//        else
//        {
//            Console.WriteLine("La cadena no es un palíndromo.");
//        }
//    }
// static bool EsPalindromo(string texto)
//    {
//        string textoLimpio = texto.Replace(" ", "").ToLower(); // Limpiar espacios y convertir a minúsculas
//        char[] caracteres = textoLimpio.ToCharArray(); // Convertir a arreglo de caracteres
//        Array.Reverse(caracteres); // Invertir el arreglo
//        string textoInvertido = new string(caracteres); // Crear una cadena con los caracteres invertidos
//
//        return textoLimpio == textoInvertido; // Comparar la cadena original con la invertida
//    }
.section .data
cadena: .asciz "anitalavalatina" // Cambia esta cadena para probar

.section .text
.global _start

_start:
    // Inicializamos los registros
    ldr x0, =cadena        // Dirección de inicio de la cadena en x0
    mov x1, x0             // Copiamos la dirección de inicio en x1
    // Encontrar la longitud de la cadena
find_end:
    ldrb w2, [x1]          // Cargamos un byte de la cadena
    cbz w2, check_palindrome // Si encontramos NULL, pasamos a la verificación
    add x1, x1, 1          // Avanzamos al siguiente carácter
    b find_end

check_palindrome:
    sub x1, x1, 1          // Apuntamos al último carácter antes de NULL

compare_chars:
    // Cargamos los caracteres de inicio y fin
    ldrb w2, [x0]          // Cargamos el carácter desde el inicio
    ldrb w3, [x1]          // Cargamos el carácter desde el final
    cmp w2, w3             // Comparamos los caracteres
    bne not_palindrome     // Si son diferentes, no es palíndromo

    // Actualizamos punteros
    add x0, x0, 1          // Incrementamos el puntero al inicio
    sub x1, x1, 1          // Decrementamos el puntero al final
    cmp x0, x1             // Comparamos los punteros
    b.lo compare_chars     // Si x0 < x1, seguimos comparando

    // Si es palíndromo
is_palindrome:
    mov w0, 1              // 1 indica que es palíndromo
    b end_program

not_palindrome:
    mov w0, 0              // 0 indica que no es palíndromo

end_program:
    // Salir del programa
    mov x8, 93             // syscall exit
    svc 0
