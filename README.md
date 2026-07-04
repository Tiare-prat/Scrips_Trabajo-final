# Análisis Comparativo de Bacterias Asociadas a Resistencia Antimicrobiana e Infecciones Humanas

## Descripción del Script

La función principal de este script en Bash es la automatización del procesamiento de múltiples muestras para comparar las características genómicas de tres bacterias patógenas de alta prioridad clínica y creciente amenaza epidemiológica:

- *Mycobacterium tuberculosis*
- *Staphylococcus aureus*
- *Pseudomonas aeruginosa*

El script procesa de forma simultánea y en bloques los genomas en formato **.fna** (secuencias genómicas completas). Mediante una interfaz interactiva, expansión de variables y consultas en bases de datos locales, extrae metadatos básicos de cada muestra en tiempo real, tales como:

- Registro de datos básicos del usuario.
- Nombre del organismo.
- Longitud del genoma calculada en pares de bases (bp).
- Identificación de genes de resistencia.
- Comprobación de operones o regiones promotoras que activen o permitan la expresión de dicha resistencia ante el antibiótico.
- Identificación de genes de virulencia mediante **Abricate** utilizando la base de datos **VFDB (Virulence Factor Database)**.

---

## Información General

| Campo | Información |
|--------|-------------|
| **Autor** | Tiare Garcia Prat |
| **Curso** | Bioinformática |
| **Lenguaje** | Bash |
| **Shebang** | `#!/bin/bash` |

---

## Requisitos Previos

### Sistema

- Bash 4.0 o superior.
- Sistema operativo Linux.

### Dependencias Externas

Todas las dependencias deben encontrarse disponibles dentro del proyecto para el correcto funcionamiento del pipeline.

#### Abricate

- Instalar mediante Conda.
- Actualizar la base de datos **VFDB**.

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
chmod +x ~/Proyecto_Bioinf/Script/Script_Bonus.fasta

# Activar el entorno de Conda
conda activate bakta_env

# Ejecutar el script
source ~/Proyecto_Bioinf/Script/Script_Bonus.fasta
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

Se solicitarán los identificadores oficiales (**NCBI_ID**) de las secuencias de referencia para realizar el alineamiento local.

---

## Ejemplo de Ejecución

```bash
(base) user@cloudshell:~$ conda activate bakta_env
(bakta_env) user@cloudshell:~$ source ~/Proyecto_Bioinf/Script/Script_Bonus.fasta

✔ ¡PATH activado!

╔══════════════════════════════════════════╗
║          INFORMACIÓN DEL USUARIO         ║
╚══════════════════════════════════════════╝
...
```

---

## Entrada Esperada

No es necesario proporcionar argumentos mediante la línea de comandos.

El usuario únicamente debe:

- Tener instaladas las dependencias.
- Colocar los genomas en formato `.fna` dentro de:

```
Proyecto_Bioinf/Data/
```

---

## Salida Esperada

### Reporte Comparativo Automatizado Multi-Muestra

Archivo:

```
Resultados/reporte_genes_resistencia.txt
```

Incluye:

- Nombre de la bacteria.
- Gen de resistencia identificado.
- Estado del promotor (intacto o mutado).
- Diagnóstico predictivo (Sensible o Resistente).

### Perfiles de Virulencia

Se genera un archivo independiente para cada bacteria:

```
Resultados/reporte_vir_[bacteria].txt
```

Estos reportes contienen únicamente los factores de virulencia detectados por **Abricate** utilizando la base de datos **VFDB**.

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
    └── Script_Bonus.fasta
```

---

## Flujo General del Pipeline

1. Activación del entorno Conda.
2. Ejecución del script interactivo.
3. Registro de información del usuario.
4. Lectura automática de los archivos `.fna`.
5. Cálculo del tamaño del genoma.
6. Búsqueda de genes de resistencia.
7. Evaluación de promotores u operones asociados.
8. Identificación de factores de virulencia mediante Abricate + VFDB.
9. Generación automática de reportes comparativos y reportes individuales.

---

## Tecnologías Utilizadas

- Bash
- Conda
- Bakta
- Abricate
- VFDB
- NCBI Entrez Direct (EDirect)

---

## Autor

**Tiare Garcia Prat**

Curso de **Bioinformática**.
