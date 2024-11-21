// ====================================================
// Programador: Parra García Juan Martín
// Fecha: 19/Nov/2024
// Programa: profiling.s
// Descripción: Medir el tiempo de ejecución de una función
// Versión: 1.1
// ====================================================
// static void MedirTiempoEjecucion()  
// {
    // Creamos un objeto Stopwatch para medir el tiempo
    // System.Diagnostics.Stopwatch stopwatch = new System.Diagnostics.Stopwatch();

    // Iniciamos el temporizador
    // stopwatch.Start();

    // Llamamos a la función que queremos medir. Aquí se puede sustituir por cualquier función.
    // EjecutarFuncion();  // Esta es la función cuyo tiempo de ejecución deseamos medir.

    // Detenemos el temporizador después de que la función haya terminado de ejecutarse
    // stopwatch.Stop();

    // Mostramos el tiempo transcurrido en milisegundos
    // Console.WriteLine($"Tiempo de ejecución: {stopwatch.ElapsedMilliseconds} ms");
    
    // Si deseas mostrar el tiempo en un formato más preciso (como segundos, milisegundos y ticks):
    // Console.WriteLine($"Tiempo de ejecución: {stopwatch.Elapsed.TotalSeconds} segundos");
    // Console.WriteLine($"Tiempo de ejecución en ticks: {stopwatch.ElapsedTicks} ticks");
// }
// ====================================================
    .data
result:         .word 0            // Almacena el resultado de la función
start_time:     .quad 0            // Tiempo de inicio
end_time:       .quad 0            // Tiempo de fin
elapsed_time:   .quad 0            // Tiempo transcurrido en ciclos
freq:           .quad 0            // Frecuencia del contador

    .text
    .global _start

// Punto de entrada principal
_start:
    // Leer frecuencia del contador
    mrs x0, CNTFRQ_EL0            // Leer frecuencia del temporizador
    ldr x1, =freq
    str x0, [x1]                  // Guardar la frecuencia

    // Leer el tiempo de inicio
    mrs x0, CNTVCT_EL0            // Leer el contador del sistema
    ldr x1, =start_time
    str x0, [x1]                  // Guardar tiempo inicial

    // Llamar a la función a medir
    bl example_function           // Función de ejemplo

    // Leer el tiempo de fin
    mrs x0, CNTVCT_EL0            // Leer el contador del sistema
    ldr x1, =end_time
    str x0, [x1]                  // Guardar tiempo final

    // Calcular tiempo transcurrido
    ldr x2, =start_time
    ldr x3, [x2]                  // Cargar tiempo inicial
    ldr x2, =end_time
    ldr x4, [x2]                  // Cargar tiempo final
    sub x5, x4, x3                // end_time - start_time
    ldr x2, =elapsed_time
    str x