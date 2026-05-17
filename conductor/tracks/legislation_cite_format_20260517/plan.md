# Plan: Formato corto de citas en texto para @legislation

## Phase 1: Red Phase — Failing Tests [checkpoint: cd8945b]

- [x] Task 1: Crear fixtures LaTeX para los tests de citas inline
  - [x] Crear `tests/latex/test_legislation_cite.tex` con `\parencite` y
        `\textcite` sobre una entrada `@legislation`
  - [x] Crear `tests/latex/test_legislation_cite.bib` con un título estándar
        (con número y fecha)
  - [x] Crear `tests/latex/test_legislation_cite_fallback.bib` con un título
        sin patrón numérico reconocible

- [x] Task 2: Escribir tests BATS en `tests/shell/legislation_cite.bats`
  - [x] Test: el PDF con `\parencite` NO contiene el número de ley (ej. `16/1987`)
  - [x] Test: el PDF con `\parencite` SÍ contiene el título descriptivo corto
  - [x] Test: el PDF con `\textcite` muestra el título corto
  - [x] Test: la sección de bibliografía sigue mostrando el título completo
  - [x] Test: fallback — título sin patrón numérico → cita muestra título completo

- [x] Task 3: Ejecutar tests y confirmar fase Red (tests fallando)
  - [x] Ejecutar: `bash tests/run_tests.sh tests/shell/legislation_cite.bats`
  - [x] Confirmar que todos los tests nuevos fallan

- [ ] Task: Conductor - User Manual Verification 'Phase 1: Red Phase'
      (Protocol in workflow.md)

## Phase 2: Green Phase — Implement Short Title

- [ ] Task 4: Implementar biber sourcemap para auto-derivar `shorttitle`
  - [ ] Añadir `\DeclareSourcemap` en `ui1activity.cls` con regex Perl que
        detecte el patrón `número/año` + expresión de fecha y derive `shorttitle`
  - [ ] Cubrir variantes: `Ley`, `Ley Orgánica`, `Real Decreto`, `Real Decreto-ley`
  - [ ] Garantizar que si el título no encaja, `shorttitle` no se establece
        (fallback silencioso)

- [ ] Task 5: Modificar el driver de cita de `@legislation`
  - [ ] Localizar el citation driver de `@legislation` en `ui1activity.cls`
  - [ ] Cambiar el renderizado del título en citas para usar `shorttitle` si
        está presente, o `title` como fallback
  - [ ] Verificar que el bibliography driver permanece inalterado

- [ ] Task 6: Ejecutar tests y confirmar fase Green (tests pasando)
  - [ ] Ejecutar: `bash tests/run_tests.sh tests/shell/legislation_cite.bats`
  - [ ] Confirmar que todos los tests nuevos pasan
  - [ ] Ejecutar suite completa: `bash tests/run_tests.sh tests/shell/*.bats`
  - [ ] Confirmar que no hay regresiones

- [ ] Task 7: Commit de la implementación
  - [ ] Stage: `ui1activity.cls`, fixtures de test, `legislation_cite.bats`
  - [ ] Commit: `feat(legislation): Use short title in @legislation in-text citations`
  - [ ] Adjuntar git note con resumen de tarea

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Green Phase'
      (Protocol in workflow.md)
