# Análisis Comparativo de Bacterias Asociadas a Resistencia Antimicrobiana e Infecciones Humanas
## Descripción del Script
En dicho Script tendra como principal función el automatizado las multi-muestras donde se compara las características genómicas de tres bacterias patógenas de alta prioridad clínica y creciente amenaza epidemiológica: *Mycobacterium tuberculosis*, *Staphylococcus aureus* y *Pseudomonas aeruginosa*.

El script procesa en bloques simultáneos los genomas en formato .fna de secuencias genomicas completas, utilizando una interfaz interactiva, expansión de variables, comparación en base de datos para extraer metadatos básicos de cada muestra en tiempo real, tales como:
*Registreción de los datos basicos del usuario
* Nombre del organismo.
* Longitud del genoma calculada en pares de bases (**bp**).
* identificaión de genes resistentes
* comprobación si el gen tiene operon que vuelve que permite que la resistencia ante dicho antibiotico se de
* identificación de genes de virulencia aqui si que no se bien uso el abrikate con base de daros vdbf supongo que es para genees de virulencia

* ### Shebang utilizado
```bash
#!/bin/bash

##Información General
* Autor: Tiare Garcia Prat
* Curso: Bioinformática

### Requisitos Previos
* Versión de Bash: Bash 4.0 o superior
* Sistema Operativo: Entorno Linux
####Dependencias Externas (Software y Bases de Datos):

Todos las depenencias externas que se mencione deveran ser movilizadas a carpeta Proyecto_Bioinf/Referencias, para correcto funcionamiento del scri
Abricate: Instalar entorno por medio de conda instlar su ultima actualización con su base de datos de virulencia actualizada VDBF
Bakta: Instalar entorno por medio de conda y si tienes la capacidad computacional su base de datos en caso que no puedas no hay problema
NCBI Entrez Direct (EDirect): En caso de no tener la base de bakta Paquete de utilidades bioinformáticas que provee la herramienta efetch

## Instalación
Pasos que se tiene que seguir en vuestra termina, para tener el entorno configurado
chmod +x ~/Proyecto_Bioinf/Script/Script_Bonus.fasta
conda activate bakta_env 
source ~/Proyecto_Bioinf/Script/Script_Bonus.fasta
ingresar los gen de resistencia que usted busca
y el codigo que se tenga en el nbci

## Explicación de Parámetros
El pipeline utiliza una interfaz dinámica que detecta automáticamente los archivos de entrada y solicita los siguientes parámetros:
Entrada de Genes: Nombre de los factores de resistencia a antibióticos específicos a buscar en cada especie (ej. mecA, blaPAO, katG).
Entrada de Códigos de Acceso: Identificadores NCBI oficiales (NCBI_ID) de las secuencias de referencia nucleotídica para realizar el alineamiento local.

## Vizualización del Scrip

### Ejemplo de Ejecución
(base) user@cloudshell:~$conda activate bakta_env 
(bakta_env) user@cloudshell:~$ source ~/Proyecto_Bioinf/Script/Script_Bonus.fasta
✔ ¡PATH activado
╔══════════════════════════════════════════╗
║          INFORMACIÓN DEL USUARIO         ║
╚══════════════════════════════════════════╝
.......................

### Entrada Esperada
No se requiere ingresar argumentos adicionales, pues es un scrip interactivo el cual este te solicita datos para el analisis; lo unico que se requiere son las herramientas previamente descargadas y activas como vuestro genoma que usted quiene analizar en la caperpeta de  Proyecto_Bioinf/Data

### Salida Esperada
El script centraliza y organiza los resultados de salida dentro de la carpeta asignada, evitando la dispersión de archivos

Opción 1: Reporte Comparativo Automatizado Multi-Muestra (Resultados/reporte_genes_resistencia.txt)
Una matriz final que consolida los hallazgos de todas las bacterias analizadas simultáneamente, imprimiendo el nombre de la bacteria, la posesión del gen de resistencia, la presencia intacta o mutada del promotor y el diagnóstico predictivo final (Sensible/Resistente).

Opción 2: Perfiles de Virulencia Separados (Resultados/reporte_vir_[bacteria].txt)
Archivos ordenados individualmente por cada muestra analizada, que contienen el filtrado exclusivo de los factores de virulencia identificados por Abricate cruzados contra la base de datos VDBF.

## Estructura del Proyecto
El árbol de directorios del espacio de trabajo se organiza de forma estricta bajo la siguiente jerarquía estructural para evitar la generación de archivos basura y que el scrip funcione corrctamente:

Proyecto_Bioinf/
├── Data/
│   ├── aeruginosa.fna       # Genoma de Pseudomonas aeruginosa
│   ├── s_aureus.fna         # Genoma de Staphylococcus aureus
│   └── tuberculosis.fna     # Genoma de Mycobacterium tuberculosis
├── Referencias/
│   ├── db_falsa/            # Base de datos híbrida de contingencia para Bakta
│   └── VDBF/                # Base de datos de factores de virulencia para Abricate
├── Resultados/
│   ├── reporte_genes_resistencia.txt  # Tabla maestra comparativa
│   ├── reporte_vir_aeruginosa.txt     # Factores de virulencia específicos
│   ├── reporte_vir_s_aureus.txt       # Factores de virulencia específicos
│   └── reporte_vir_tuberculosis.txt   # Factores de virulencia específicos
└── Script/
    └── Script_Bonus.fasta   # Script principal del pipeline en Bash
