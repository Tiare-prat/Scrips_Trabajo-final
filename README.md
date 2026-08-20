# Análisis Comparativo de Bacterias Asociadas a Resistencia Antimicrobiana e Infecciones Humanas

## Información General

| Campo | Información |
|--------|-------------|
| **Autor** | Tiare  Prat / Evethsy Nuñez |
| **Curso** | Bioinformática |
| **Docentes** | Frank Guzmán Escudero / Manuel Ramírez Sáenz |
| **Universidad** | Universidad Peruana de Ciencias Aplicadas (UPC) |
| **Semestre** | 2026-1 |
| **Lenguaje** | Bash |
| **Shebang** | `#!/bin/bash` |

---

## Descripción del Script

La función principal de este script en Bash es la automatización del procesamiento de múltiples muestras para comparar las características genómicas de tres bacterias patógenas de alta prioridad clínica y creciente amenaza epidemiológica:

- *Mycobacterium tuberculosis*
- *Staphylococcus aureus*
- *Pseudomonas aeruginosa*

El script procesa de forma simultánea y en bloques los genomas en formato **.fna** (secuencias genómicas completas). Mediante una interfaz interactiva, expansión de variables y consultas en bases de datos locales, extrae metadatos básicos de cada muestra en tiempo real, tales como:

- Registro de datos básicos del usuario e identificación del entorno.
- Perfil genómico: control de calidad, porcentaje de GC, validación de la Regla de Chargaff y anotación génica (CDS, rRNA, tRNA) mediante NCBI.
- Detección de motivos de secuencia específicos (gen *blaZ* + promotor AMR o motivo personalizado).
- Diagnóstico preciso de genes de resistencia y comprobación de sus regiones promotoras (-10/-35) usando Bakta o NCBI.
- Identificación de factores de virulencia mediante **Abricate** con la base de datos **VFDB**.
- Detección complementaria de resistencia antimicrobiana (AMR) y mutaciones mediante **Abricate** con la base de datos **CARD**.
---
## Estructura del Proyecto

```text
Proyecto_Bioinf/
├── Data/
│   ├── aeruginosa.fna
│   ├── s_aureus.fna
│   └── tuberculosis.fna
│
├── Referencias/
│   ├── db_falsa/
│   └── VFDB/
│
├── Resultados/
│   ├── reporte_genes_resistencia.txt
│   ├── reporte_vir_aeruginosa.txt
│   ├── reporte_vir_s_aureus.txt
│   └── reporte_vir_tuberculosis.txt
│
└── Script/
    └── Script_2.sh
```

---

## Requisitos Previos

### Sistema

- Bash 4.0 o superior.
- Sistema operativo Linux/ WSL / Google Cloud Shell.
- Calculadora en consola (bc) para operaciones matemáticas.

### Dependencias Externas

Todas las dependencias deben encontrarse disponibles dentro del proyecto para el correcto funcionamiento del pipeline.

#### Abricate & Base de Datos CARD / VFDB

- Instalar mediante Conda.
- Entorno Conda dedicado (entorno_abricate).
- Actualizar la base de datos **VFDB (virulencia) y CARD (resistencia)**.

#### Bakta

- Instalar mediante Conda.
- Se recomienda descargar la base de datos completa.

#### NCBI Entrez Direct (EDirect)

En caso de no utilizar la base de datos local de Bakta, este paquete proporciona la utilidad **efetch** para consultar secuencias directamente desde NCBI.

---

## Instalación y Configuración

Ejecutar los siguientes comandos:

```bash
# Asignar permisos de ejecución al script
chmod +x ~/Proyecto_Bioinf/Script/Script_2.sh

# Activar el entorno de Conda
conda activate bakta_env

# Ejecutar el script
source ~/Proyecto_Bioinf/Script/Script_2.sh
```

> **Nota:** Durante la ejecución el programa solicitará ingresar los genes de resistencia y los códigos de acceso correspondientes del NCBI.

---

## Parámetros de Entrada

El pipeline funciona mediante una interfaz interactiva.

### Genes de resistencia

El usuario deberá ingresar los genes de resistencia que desea buscar, por ejemplo:

- `mecA`
- `katG`
- `blaPAO`

### Códigos de acceso del NCBI

Se solicitarán los identificadores oficiales (**NCBI_ID**) de las secuencias de referencia para realizar el alineamiento local, por ejemplo:

- `NG_049187.1`
- `NG_047938.1`
- `NC_000962.3`
  
---

## Ejemplo de Ejecución

A continuación se ejemplificara la ejecución interactiva del pipeline corriendo sobre el entorno Google Cloud Shell con las respuestas ingresadas por el usuario:

```text
(base) user@cloudshell:~$ conda activate entorno_abricate
(entorno_abricate) pratgarciatiare@cloudshell:~$ bash ~/Proyecto_Bioinf/Script/Script_2.sh

✔ ¡PATH activado!

╔══════════════════════════════════════════════════════════════╗
║       SUITE BIOINFORMÁTICA UNIFICADA - ANALIZADOR AMR        ║
║                   Bioinformática UPC 2026                    ║
╚══════════════════════════════════════════════════════════════╝

╔══════════════════════════════════════════╗
║          INFORMACIÓN DEL USUARIO         ║
╚══════════════════════════════════════════╝

👤 Nombre del Investigador: Tiare Garcia
🖥️  Máquina                   : cs-259715350871-default
🐚 Shell                     : /bin/bash
📂 Directorio HOME           : /home/pratgarciatiare
📍 Directorio actual         : /home/pratgarciatiare
🌐 Idioma                    : en_US.UTF-8
🔢 PID del script            : 712

╔══════════════════════════════════════════╗
║          Archivos a analizar             ║
╚══════════════════════════════════════════╝
-/home/pratgarciatiare/Proyecto_Bioinf/Data/aeruginosa.fna
-/home/pratgarciatiare/Proyecto_Bioinf/Data/s_aureus.fna
-/home/pratgarciatiare/Proyecto_Bioinf/Data/tuberculosis.fna


==============================================================
                 MENÚ DE ANÁLISIS GENÓMICO                    
  [1] Información general, Control de Calidad, %GC y Chargaff
  [2] Búsqueda de motivos de secuencia (blaZ / Personalizado)
  [3] Diagnóstico preciso de gen + promotor (Bakta / NCBI)
  [4] Identificación de factores de virulencia (Abricate / VFDB)
  [5] Búsqueda complementaria de AMR y Mutaciones (CARD / AMRFinder)
  [6] Salir
==============================================================
Elige una opción: 1

------------------------------------------------------------
  ANÁLISIS 1: PERFIL GENÓMICO GENERAL Y %GC
------------------------------------------------------------
Calificador de calidad de secuencia
Secuencias cortas (<100 bp): 0
Secuencias medias (100-900 bp): 0
Secuencias largas (>900 bp): 3

Analizando muestra: /home/pratgarciatiare/Proyecto_Bioinf/Data/aeruginosa.fna
Investigador      : Tiare Garcia
Bacteria          : Pseudomonas aeruginosa PAO1
Nº de contigs     : 1
Tamaño total      : 6.26 Mb (6264404 bp)
Nucleótidos N     : 0
--- Anotación génica (NCBI) ---
CDS: 5572 | rRNA: 12 | tRNA: 63
%A = 16.7%  %T = 16.7%  Diferencia: 0%
%G = 33.3%  %C = 33.3%  Diferencia: 0%
%GC               : 66.60%
Chargaff          : SÍ cumple la Regla de Chargaff → Genoma de doble cadena íntegro y bien ensamblado

✔ Resultado acumulado guardado en /home/pratgarciatiare/Proyecto_Bioinf/Resultados/opcion1_resultado.txt

Presiona [Enter] para volver al menú principal...

==============================================================
                 MENÚ DE ANÁLISIS GENÓMICO                    
  [1] Información general, Control de Calidad, %GC y Chargaff
  [2] Búsqueda de motivos de secuencia (blaZ / Personalizado)
  [3] Diagnóstico preciso de gen + promotor (Bakta / NCBI)
  [4] Identificación de factores de virulencia (Abricate / VFDB)
  [5] Búsqueda complementaria de AMR y Mutaciones (CARD / AMRFinder)
  [6] Salir
==============================================================
Elige una opción: 6

Saliendo del analizador.

---
```

## Entrada Esperada

No es necesario proporcionar argumentos mediante la línea de comandos.

El usuario únicamente debe:

- Tener instaladas las dependencias.
- Activar el entorno bakta antes de la corrida
- Colocar los genomas en formato `.fna` dentro de:

```
Proyecto_Bioinf/Data/
```

---

## Salida Esperada
- Todas las salidas se organizan automáticamente dentro del directorio Resultados/:
  
| Campo | Información |
|--------|-------------|
| **Opción 1** | `opcion1_resultado.txt` — Conteo de contigs, %GC, validación de Chargaff y conteo CDS/rRNA/tRNA. |
| **Opción 2** | `opcion2_resultado.txt` — Frecuencias de motivos (*blaZ*, promotores o secuencias personalizadas). |
| **Opción 3** | `reporte_genes_resistencia.txt` — Tabla formateada con diagnóstico predictivo (Sensible/Resistente). |
| **Opción 4** | `reporte_vir_[muestra].txt` — Factores de virulencia detectados mediante VFDB por muestra. |
| **Opción 5** | `reporte_amr_[muestra].txt` — Determinantes AMR, % de identidad, cobertura y mecanismos (CARD). |


## Flujo de ejecución

1. **Activación del entorno Conda.**
2. **Ejecución del script interactivo.**
3. **Registro de metadatos del usuario** y despliegue del menú interactivo (Opciones 1 a 6).
4. **Procesamiento automatizado de los genomas `.fna`** según la opción seleccionada:
   - **Opción 1:** Control de calidad de contigs, %GC, validación de la Regla de Chargaff y conteo de CDS/rRNA/tRNA vía NCBI.
   - **Opción 2:** Conteo de motivos de secuencia (gen *blaZ*, promotores o motivos personalizados).
   - **Opción 3:** Búsqueda de genes de resistencia y evaluación de regiones promotoras (-10/-35) mediante Bakta o NCBI.
   - **Opción 4:** Screening de factores de virulencia mediante Abricate + VFDB.
   - **Opción 5:** Screening de determinantes AMR y mutaciones mediante Abricate + CARD.
5. **Generación y exportación automática de los reportes correspondientes** dentro de `Resultados/`.

---

## Tecnologías Utilizadas

- Bash
- Conda
- Bakta
- Abricate
- VFDB
- Base de datos CARD (Comprehensive Antibiotic Resistance Database)
- NCBI Entrez Direct (efetch)
---

## Referencias

1. **NCBI RefSeq — Genoma de *Pseudomonas aeruginosa* PAO1:** Código de acceso: `NC_002516.2`  
   Enlace: [https://www.ncbi.nlm.nih.gov/nuccore/NC_002516.2](https://www.ncbi.nlm.nih.gov/nuccore/NC_002516.2)

2. **NCBI RefSeq — Genoma de *Staphylococcus aureus* NCTC 8325:** Código de acceso: `NC_007795.1`  
   Enlace: [https://www.ncbi.nlm.nih.gov/nuccore/NC_007795.1](https://www.ncbi.nlm.nih.gov/nuccore/NC_007795.1)

3. **NCBI RefSeq — Genoma de *Mycobacterium tuberculosis* H37Rv:** Código de acceso: `NC_000962.3`  
   Enlace: [https://www.ncbi.nlm.nih.gov/nuccore/NC_000962.3](https://www.ncbi.nlm.nih.gov/nuccore/NC_000962.3)

4. **Bakta (Genome Annotation Tool):** Repositorio oficial y manual de uso para anotación genómica y detección de AMR.  
   Enlace: [https://github.com/oschwengers/bakta](https://github.com/oschwengers/bakta)

5. **Abricate (Mass screening of contigs for antimicrobial and virulence genes):** Herramienta de software utilizada en el entorno Conda para el screening en bloque.  
   Enlace: [https://github.com/tseemann/abricate](https://github.com/tseemann/abricate)

6. **VFDB (Virulence Factor Database):** Base de datos especializada en factores de virulencia bacteriana integrada dentro del análisis de Abricate.  
   Enlace: [http://www.mgc.ac.cn/VFDbs/](http://www.mgc.ac.cn/VFDbs/)

---
