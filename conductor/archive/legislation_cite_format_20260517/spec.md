# Spec: Formato corto de citas en texto para @legislation

## Overview

Modificar el formato de presentación de las citas en texto de las entradas
`@legislation` para que muestren un título descriptivo corto en lugar del
título completo del campo `title`, que incluye número de ley y fecha.

**Comportamiento actual:**
```
(Ley 16/1987, de 30 de julio, de Ordenación de los Transportes Terrestres, 1987)
```

**Comportamiento deseado:**
```
(Ley de Ordenación de los Transportes Terrestres, 1987)
```

## Functional Requirements

1. Todos los comandos de cita (`\cite`, `\parencite`, `\textcite`, etc.)
   deben usar el título corto para entradas `@legislation`.
2. La transformación es automática: se deriva del campo `title` existente
   sin que el usuario deba añadir ningún campo nuevo en el `.bib`.
3. La lista de referencias bibliográficas al final del documento no cambia:
   sigue mostrando el campo `title` completo.
4. El formato de cita de otros tipos de entrada (`@jurisprudencia`,
   `@book`, etc.) no se ve afectado.

## Transformation Rules

La transformación elimina del `title` el número de ley y la expresión de
fecha, conservando el tipo normativo inicial (Ley, Real Decreto, etc.) y la
parte descriptiva final. Los patrones identificados son:

| Tipo               | Ejemplo título completo                                           | Título corto esperado                          |
|--------------------|-------------------------------------------------------------------|------------------------------------------------|
| Ley                | `Ley 16/1987, de 30 de julio, de Ordenación de los Transportes`  | `Ley de Ordenación de los Transportes`         |
| Ley Orgánica       | `Ley Orgánica 4/2000, de 11 de enero, sobre derechos...`         | `Ley Orgánica sobre derechos...`               |
| Real Decreto       | `Real Decreto 1/2020, de 14 de enero, por el que...`             | `Real Decreto por el que...`                   |
| Real Decreto-ley   | `Real Decreto-ley 8/2020, de 17 de marzo, de medidas urgentes`   | `Real Decreto-ley de medidas urgentes`         |

**Patrón general:** se elimina el fragmento que comienza en el primer token
que contenga `/` (número de ley) y termina antes de la preposición o
conjunción que inicia la parte descriptiva (`de`, `sobre`, `por el que`,
`por la que`, `relativo a`, etc.).

Dado que la variabilidad de los patrones hace inviable una transformación
100% automática solo con TeX, la implementación usará la funcionalidad
**sourcemap de biber** (expresiones regulares Perl aplicadas en tiempo de
procesado de bibliografía) para derivar automáticamente el campo `shorttitle`
a partir de `title`. El driver de cita de `@legislation` usará `shorttitle`
si está presente, y `title` como fallback.

## Non-Functional Requirements

- La transformación no debe romper la compilación cuando el título no sigue
  ningún patrón reconocido (fallback silencioso al `title` completo).
- El tiempo de compilación no debe aumentar de forma perceptible.

## Acceptance Criteria

- [ ] `\parencite{lott1987}` produce `(Ley de Ordenación de los Transportes
      Terrestres, 1987)` cuando el título sigue el patrón estándar.
- [ ] `\textcite{lott1987}` produce `Ley de Ordenación de los Transportes
      Terrestres (1987)`.
- [ ] La entrada en la lista de referencias muestra el título completo
      sin cambios.
- [ ] Cuando el `title` no sigue ningún patrón conocido, la cita muestra
      el `title` completo (sin errores ni texto vacío).
- [ ] Los tests BATS de citas de `@legislation` pasan.

## Out of Scope

- Cambios en el formato de cita de `@jurisprudencia`.
- Cambios en el formato de la bibliografía (lista de referencias).
- Soporte de directivas de la UE u otras normas supranacionales con formato
  de número distinto (se puede abordar en un track posterior).
- Modificación manual de archivos `.bib` por el usuario.
