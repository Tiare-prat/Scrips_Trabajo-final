# Análisis Comparativo de Bacterias Asociadas a Resistencia Antimicrobiana e Infecciones Humanas

## Información General

| Campo | Información |
|--------|-------------|
| **Autor** | Tiare Garcia Prat |
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

- Registro de datos básicos del usuario.
- Nombre del organismo.
- Longitud del genoma calculada en pares de bases (bp).
- Identificación de genes de resistencia.
- Comprobación de operones o regiones promotoras que activen o permitan la expresión de dicha resistencia ante el antibiótico.
- Identificación de genes de virulencia mediante **Abricate** utilizando la base de datos **VFDB (Virulence Factor Database)**.

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

A continuación se detalla una simulación de ejecución real interactiva del pipeline corriendo sobre el entorno Google Cloud Shell con las respuestas ingresadas por el usuario:

```text
(base) user@cloudshell:~$ conda activate bakta_env
(bakta_env) pratgarciatiare@cloudshell:~$ source ~/Proyecto_Bioinf/Script/Script_2.sh

✔ ¡PATH activado

╔══════════════════════════════════════════╗
║          INFORMACIÓN DEL USUARIO         ║
╚══════════════════════════════════════════╝

👤 Usuario         : tiare
🖥️  Máquina         : cs-259715350871-default
🐚 Shell           : /bin/bash
📂 Directorio HOME : /home/pratgarciatiare
📍 Directorio actual: /home/pratgarciatiare
🌐 Idioma          : en_US.UTF-8
🔢 PID del script  : 712
📊 Estructura usada: tree /home/pratgarciatiare/Proyecto_Bioinf

╔══════════════════════════════════════════╗
║          Archivos a analizar             ║
╚══════════════════════════════════════════╝
-/home/pratgarciatiare/Proyecto_Bioinf/Data/aeruginosa.fna
-/home/pratgarciatiare/Proyecto_Bioinf/Data/s_aureus.fna
-/home/pratgarciatiare/Proyecto_Bioinf/Data/tuberculosis.fna


╔══════════════════════════════════════════╗
║                Analisis                  ║
╚══════════════════════════════════════════╝
Nombre de los encabezados y su longitud
secuencia 1:
Encabezado: NC_002516.2 Pseudomonas aeruginosa PAO1, complete genome
longitud total: 6264404 bp
secuencia 2:
Encabezado: NC_007795.1 Staphylococcus aureus subsp. aureus NCTC 8325 chromosome, complete genome
longitud total: 2821361 bp
secuencia 3:
Encabezado: NC_000962.3 Mycobacterium tuberculosis H37Rv, complete genome
longitud total: 4411532 bp


Calificador de calidad de secuencia
Secuencias cortas(<100 bp): 0
Secuencias medias(100-900): 0
Secuencias largas(>900 bp): 3


=========================================================================
     Comprobando dependencias del sistema
=========================================================================
No se halla base de datos, script funcionará con alternativa alterna, buscando vía NCBI.
✔ Bakta detectado correctamente.
✔ Comprobación del entorno finalizada


=========================================================================
        Tabla de condiciones del genoma analizado
=========================================================================
Ingresar nombre del gen de resistencia que buscas para Pseudomonas: blaPAO 
Ingresar el código NCBI de ese gen de resistencia: NG_049187.1 
Ingresar nombre del gen de resistencia que buscas para S. aureus: mecA 
Ingresar el código NCBI de ese gen de resistencia: NG_047938.1 
Ingresar nombre del gen de resistencia que buscas para Tuberculosis: katG 
Ingresar el código NCBI de ese gen de resistencia: NC_000962.3

✔ Tabla generada con éxito respuestas y diagnósticos en:
/home/pratgarciatiare/Proyecto_Bioinf/Resultados/reporte_genes_resistencia.txt

╔══════════════════════════════════════════╗
║      FACTORES GENES DE VIRULENCIA        ║
╚══════════════════════════════════════════╝
 Sistema Abricate detectado y listo para usar.
 Reporte de virulencia limpio generado en:
/home/pratgarciatiare/Proyecto_Bioinf/Resultados/reporte_vir_aeruginosa.txt
 Reporte de virulencia limpio generado en:
/home/pratgarciatiare/Proyecto_Bioinf/Resultados/reporte_vir_s_aureus.txt
 Reporte de virulencia limpio generado en:
/home/pratgarciatiare/Proyecto_Bioinf/Resultados/reporte_vir_tuberculosis.txt

---
```

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

## Autor



Curso de **Bioinformática**.
