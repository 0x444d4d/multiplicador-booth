# Actividad Previa - Diseño de Procesadores

## Multiplicador de Booth

---

### Índice

* [Diseño](#disenno)

* [Compilación](#compilacion)

---

<a name="disenno"> </a>

## Diseño:

El circuito representa un multiplicador de Booth de 3 bits donde los registros A y Q han sido extendidos en 1 bit para evitar errores de overflow.

- uc.v - unidad de control

- datapath.v - camino de datos

- mult.v - circuito multiplicador de booth

La unidad de control hace uso de 9 estados **[[Figura 1](#figura1)]** incluyendo el inicial y final. El diseño de estos permite que se reduzca el número de estados visitados saltando directamente a los estados de desplazamiento cuando la suma o resta no sean necesarias.

<a name="figura1"> </a>

![Figura 1: Estados de la unidad de control](/home/david/Documents/ULL/3/Diseño/actividad-previa-mejorada/proyecto.jpg "Figura 1: Estados de la unidad de control")

<p style="text-align: center;"> <i><b>Figura 1:</b> Estados de la unidad de control </i></p>

Al ser los registros de carga síncrona es necesario dejar un estado intermedio entre el estado de desplazamiento y el de selección del siguiente estado (suma/resta o desplazamiento) de forma que estos se actualicen, esto añade dos estados en el circuito que no se pueden evitar sin modificar la estructura. La solución aportada para evitar dichos estados es, además de usar *q[0]* y *q[-1]*, para la comprobar si es necesaria la suma/resta, añadir *q[1]* de forma que se pueda realizar el desplazamiento y la comprobación en el mismo estado usando *q[1:0]* en vez de *q[0:-1]*.

Con este cambio se obtiene una aceleración de ***1.235*** en las pruebas aunque la aceleración real es mayor ya que el tetsbench envía la señal ***Reset*** con retardo de forma que el estado ***S8*** repite un salto hacia sí mismo en cada multiplicación.

<a name="compilacion"> </a>

### Compilación:

Los ficheros contienen los includes necesarios (Aquellos ficheros de los que dependen, ie. componentes.v) para compilarlos sin tener que especificar todos los ficheros.

Compilar testbench:

```
iverilog <-o booth> multiplicador_tb.v
```

Compilar multiplicador:

```
iverilog <-o mult> mult.v
```
