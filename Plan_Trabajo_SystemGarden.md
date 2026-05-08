# Plan de Trabajo: systemgarden (Gestión de Invernadero)

Este documento detalla la distribución de responsabilidades y el flujo de trabajo para el desarrollo del proyecto **systemgarden** en Lenguaje Ensamblador (Emu8086).

## 1. Información General
* **Nombre del Proyecto:** systemgarden
* **Líder de Proyecto:** Fernando Saúl Haro Candelario
* **Equipo:** Daniel, Enciso, Víctor
* **Plataforma:** Lenguaje Ensamblador 8086 (Emu8086)
* **Entorno de Colaboración:** GitHub

## 2. Reglas de Desarrollo
* **Arquitectura:** El sistema será modular, utilizando la directiva `INCLUDE` para integrar los archivos de cada integrante al núcleo `systemgarden.asm`.
* **Biblioteca:** Es obligatorio el uso de las macros definidas en `biblioteca.txt`.
* **Código:** Uso estricto de Macros y Procedimientos para la organización de la lógica.
* **Control de Versiones:** Cada integrante trabajará en su propia rama en GitHub y solo hará *merge* a la rama `main` tras validar la compilación en Emu8086.

## 3. Distribución de Módulos y Hardware
Cada integrante es responsable del manejo de hardware virtual específico y la manipulación de **mínimo dos archivos** (lectura/escritura).

### Fernando (Seguridad y Acceso)
* **Hardware:** `Thermometer` (Lectura base del entorno).
* **Archivos:**
    1. `usuarios.txt`: Base de datos para el Login.
    2. `access.txt`: Log de ingresos al sistema (escritura).
* **Responsabilidades:** Implementación del Login, validación de credenciales y creación de la estructura de directorios inicial.

### Daniel (Gestión de Inventario)
* **Hardware:** `Stepper_motor` (Simulación de ventilación mecánica o dosificadores).
* **Archivos:**
    1. `stock.txt`: Registro de fertilizantes y semillas (lectura/escritura).
    2. `notas.txt`: Procedimientos de mantenimiento de herramientas.
* **Responsabilidades:** Interfaz de captura de inventario y control del motor paso a paso.

### Enciso (Monitoreo Climático)
* **Hardware:** `Traffic_Lights` y `LED_Display`.
* **Archivos:**
    1. `clima.txt`: Historial de registros térmicos diarios.
    2. `alertas.txt`: Registro de eventos fuera de rango (rojo/amarillo).
* **Responsabilidades:** Visualización de datos en tiempo real y sistema de semáforo para alertas críticas.

### Víctor (Automatización Robótica)
* **Hardware:** `Robot` y `Printer`.
* **Archivos:**
    1. `rutas.txt`: Coordenadas de movimiento para riego programado.
    2. `reporte.txt`: Resumen de actividad generado para impresión.
* **Responsabilidades:** Lógica de movimiento del robot para mantenimiento y generación de reportes físicos.

## 4. Estructura de Directorios (en C:)
El sistema montará automáticamente la siguiente estructura para almacenamiento de datos:
* `C:\SYSTGARD` (Raíz)
    * `\FERNANDO` (Seguridad)
    * `\DANIEL` (Inventario)
    * `\ENCISO` (Clima)
    * `\VICTOR` (Robótica)

## 5. Cronograma de Fases
1. **Fase 1 (Inicial):** Configuración de GitHub, `main.asm` y `biblioteca.lib`.
2. **Fase 2 (Base):** Implementación del Login y creación de carpetas (Fernando).
3. **Fase 3 (Lógica Individual):** Desarrollo de módulos específicos y manejo de hardware virtual.
4. **Fase 4 (Integración):** Unificación de módulos en el menú principal y pruebas de flujo.
5. **Fase 5 (Entrega):** Depuración final y documentación.
