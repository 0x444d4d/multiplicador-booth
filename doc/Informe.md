# Actividad Previa - Diseño de Procesadores

# Multiplicador de Booth

---

## Índice

* [Diseño](#disenno)
  
  * [Diseño base](#disennobase)
  
  * [Primera iteración](#primeraiteracion)
  
  * [Segunda iteración](#segundaiteracion)
  
  * [Tercera iteración](#terceraiteracion)
  
  * [Aceleración](#aceleracion)

* [Compilación](#compilacion)

---

<a name="disenno"> </a>

## Diseño:

El circuito representa un multiplicador de Booth de 3 bits donde los registros A y Q han sido extendidos en 1 bit para evitar errores de overflow.

- uc.v - unidad de control

- datapath.v - camino de datos

- mult.v - circuito multiplicador de Booth

La unidad de control en su diseño final hace uso de 8 estados **[[Figura 4](#figura4)]** incluyendo el inicial y final. El diseño de estos permite que se reduzca el número de estados visitados saltando directamente a los estados de desplazamiento cuando la suma o resta no sean necesarias.

 <a name="disennobase"> </a>

### Diseño base

El diseño base propuesto se conforma de 8 estados los cuales se ejecutan de forma secuencial por lo tanto realizar la operación de multiplicación sobre todas las combinaciones posibles de números en complemento 2 de 3 bits tardaría ***512* ciclos**. Estos se podrían reducir si evitáramos realizar saltos a estados de suma o resta cuando no sean necesarios.

| ![](/home/david/Documents/ULL/3/Diseño/actividad-previa-mejorada/doc/disenno-base.jpg)           |
| ------------------------------------------------------------------------------------------------ |
| <p style="text-align: center;"> <i><b>Figura 1:</b> Estados de la unidad de control base</i></p> |

<a name="primeraiteracion"> </a>

### Primera iteración

Partiendo de la suposición de que evitar las sumas y restas produce una mejora se creó una nueva máquina de estados. Como se puede observar ya no es secuencial sino que podemos evitar las sumas/restas. Sin embargo la modificación requiere añadir estados donde se selecciona el siguiente salto. 

Debido a esto el nuevo número de estados es 11 y niegan la posible mejora al tener que ejecutarse los nuevos estados en cada iteración dando como resultado un total de ***544*** **ciclos** y una **aceleración de *0.94*** respecto al diseño base.

| ![](/home/david/Documents/ULL/3/Diseño/actividad-previa-mejorada/doc/primera-iteracion.jpg)                           |
| --------------------------------------------------------------------------------------------------------------------- |
| <p style="text-align: center;"> <i><b>Figura 2:</b> Estados de la unidad de control tras la primera iteración</i></p> |

<a name="segundaiteracion"> </a>

### Segunda iteración

La única solución a la regresión de la primera iteración del diseño es realizar el desplazamiento y la selección del siguiente estado en el propio estado de desplazamiento. 

A pesar de ello esto resulta imposible ya que los registros son de carga síncrona y no estarán actualizados hasta la siguiente señal de reloj. La solución es predecir el siguiente estado antes de que los registros se actualicen. Para ello la unidad de control recive los bits ***q[1:0]*** y ***q[-1]*** y usa ***q[1:0]***.

***q[-1]*** sigue siendo necesario para la elección de estado en ***S1***.

<a name="figura3"> </a>

| ![Figura 1: Estados de la unidad de control](/home/david/Documents/ULL/3/Diseño/actividad-previa-mejorada/doc/proyecto.jpg "Figura 1: Estados de la unidad de control") |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <p style="text-align: center;"> <i><b>Figura 3:</b> Estados de la unidad de control tras la segunda iteración</i></p>                                                   |

Con estos cambios se elimina el overhead de los estados extra y obtenemos la ventaja que intentábamos obtener. Los nuevos ciclos para terminar las pruebas son ***416*** lo que supone una aceleración de ***1.231*** respecto al diseño base y ***1.307*** respecto a la primera iteración.

<a name="terceraiteracion"> </a>

### Tercera iteración

Si bien ya se ha conseguido una mejora mayor a 1 aún se puede mejorar el diseño eliminando el estado ***S1*** de la iteración previa. Para ello sería necesario obtener ***q[0]*** desde el testbench (***q[-1]*** en este caso es insignificante ya que siempre será 0) cuando el estado actual sea ***S0***. Podemos reutilizar la señal ***init*** de la *UC* para realizar esta tarea.

```verilog
//fichero mult.v
//Q_mult: numero recibido desde el testbench
//q_uc: señal que recibe la UC
//q: q[1:-1] Salida del registro Q
assign q_uc = init ? {Q_mult[1:0], 1'b0} : q;
```

| ![](/home/david/Documents/ULL/3/Diseño/actividad-previa-mejorada/doc/tercera-iteracion.jpg)                           |
| --------------------------------------------------------------------------------------------------------------------- |
| <p style="text-align: center;"> <i><b>Figura 4:</b> Estados de la unidad de control tras la tercera iteración</i></p> |

<a name="figura4"> </a>

Tras estos cambios se tarda ***352*** **ciclos** en completar las pruebas y la aceleración es ***1.454***.

<a name="aceleracion"> </a>

### Aceleración

Los cálculos de la aceleración se han realizado con los ciclos de reloj al no tener una medida de tiempo disponible.

$$
Aceleración = (Ciclos Base / Ciclos Mejora)

$$

```vega-lite
{
  "$schema": "https://vega.github.io/schema/vega/v5.json",
  "width": 400,
  "height": 200,
  "padding": 5,

  "data": [
    {
      "name": "table",
      "values": [
        {"category": "Diseño Base", "amount": 1},
        {"category": "Primera Iteracion", "amount": 0.94},
        {"category": "Segunda Iteración", "amount": 1.231},
        {"category": "Tercera Iteración", "amount": 1.454}
      ]
    }
  ],

  "signals": [
    {
      "name": "tooltip",
      "value": {},
      "on": [
        {"events": "rect:mouseover", "update": "datum"},
        {"events": "rect:mouseout",  "update": "{}"}
      ]
    }
  ],

  "scales": [
    {
      "name": "xscale",
      "type": "band",
      "domain": {"data": "table", "field": "category"},
      "range": "width",
      "padding": 0.05,
      "round": true
    },
    {
      "name": "yscale",
      "domain": {"data": "table", "field": "amount"},
      "nice": true,
      "range": "height"
    }
  ],

  "axes": [
    { "orient": "bottom", "scale": "xscale", "title": "Iteración" },
    { "orient": "left", "scale": "yscale", "title": "Aceleración" }
  ],

  "marks": [
    {
      "type": "rect",
      "from": {"data":"table"},
      "encode": {
        "enter": {
          "x": {"scale": "xscale", "field": "category"},
          "width": {"scale": "xscale", "band": 1},
          "y": {"scale": "yscale", "field": "amount"},
          "y2": {"scale": "yscale", "value": 0}
        },
        "update": {
          "fill": {"value": "gray"}
        },
        "hover": {
          "fill": {"value": "red"}
        }
      }
    },
    {
      "type": "text",
      "encode": {
        "enter": {
          "align": {"value": "center"},
          "baseline": {"value": "bottom"},
          "fill": {"value": "#333"}
        },
        "update": {
          "x": {"scale": "xscale", "signal": "tooltip.category", "band": 0.5},
          "y": {"scale": "yscale", "signal": "tooltip.amount", "offset": -2},
          "text": {"signal": "tooltip.amount"},
          "fillOpacity": [
            {"test": "isNaN(tooltip.amount)", "value": 0},
            {"value": 1}
          ]
        }
      }
    }
  ]
}
```

<a name="compilacion"> </a>

## Compilación:

Los ficheros contienen los includes necesarios (Aquellos ficheros de los que dependen, ie. componentes.v) para compilarlos sin tener que especificar todos los ficheros.

Compilar testbench:

```bash
iverilog <-o booth> multiplicador_tb.v
```
