# Sistema de curvas VI para la medicion de celdas solares y semiconductores nanoestructurados
El presente codigo constituye la interfaz de usuario para la medicion de parametros de corriente y voltaje sobre celdas solres y semiconductores nanoestructurados.

## Descripcion del sistema
El sistema se compone de los siguientes equipos:
* _Fuente de poder 20V, 5A KEITHLEY 2200_
* _Multimetro KEITHLEY 2701_
* _Multimetro HP 34401A_

Todos ellos controlados a traves de la interfaz de usuario programada en matlab

## Descripcion de la interfaz de usuario
![](https://github.com/NinoRataDeCMasMas/CIMAV-VI-System/blob/master/images/GUI.png)

### Conexion de instrumentos
<p align="center">
  <img src="https://github.com/NinoRataDeCMasMas/CIMAV-VI-System/blob/master/images/instrumentsAndComs.png">
</p>

Mediante los botones _conectar_ y _desconectar_ podremos conectar y desconectar los instrumentos. Los puertos COM correspondientes a cada instrumento seran tomados de los campos _voltimetro_ y _amperimetro_. Se exhorta al usuario proporcionar al sistemas los puertos COM correspondientes.

### Parametros de barrido
<p align="center">
  <img src="https://github.com/NinoRataDeCMasMas/CIMAV-VI-System/blob/master/images/sweep.png">
</p>

Se pide al usuario proporcionar tanto los voltajes maximo y minimo a generar por la fuente de poder, ademas del numero de divisiones que hara el barrido. Mientras la marca de _abortar_ este seleccionada el barrido actual sera detenido.

### Guardado de los datos
<p align="center">
  <img src="https://github.com/NinoRataDeCMasMas/CIMAV-VI-System/blob/master/images/dataValues.png">
</p>

Los datos generados por el barrido pueden ser guardados en un archivo de texto mediante el uso del boton _guardar datos_.