#!/bin/bash

# Autor: Tiare Garcia & Evethsy Nuñez 
# Fecha: 25/07/2026
# Descripción: Suite Bioinformática Unificada - Analizador Genómico, AMR y Virulencia
# Bioinformática UPC 2026
# Fecha: 25/07/2026
# Descripción: Suite Bioinformática Unificada - Analizador Genómico, AMR y Virulencia
# Bioinformática UPC 2026


# =========================================================================
#              GENERALIDADES DEL ORDEN
# =========================================================================

VERDE=$'\e[32m'
ROJO=$'\e[31m'
AMARILLO=$'\e[33m'
AZUL=$'\e[34m'
MORADO=$'\e[35m'
CYAN=$'\e[36m'
NEGRITA=$'\e[1m'
RESET=$'\e[0m'

# =========================================================================
#             CONFIGURACIÓN ESTRUCTURADA DEL PROYECTO
# =========================================================================

#Generar arbol de directorios del proyecto
PROYECTO="$HOME/Proyecto_Bioinf"
DIR_SCRIPT="$PROYECTO/Script"
DIR_DATA="$PROYECTO/Data"
DIR_RESULTADOS="$PROYECTO/Resultados"
DIR_REFERENCIAS="$PROYECTO/Referencias"

mkdir -p "$DIR_SCRIPT" "$DIR_DATA" "$DIR_RESULTADOS" "$DIR_REFERENCIAS"

export PATH="$DIR_SCRIPT:$PATH"

echo -e "\e[32m✔ ¡PATH activado\e[0m"

clear
echo "${MORADO}${NEGRITA}╔══════════════════════════════════════════════════════════════╗${RESET}"
echo "${MORADO}${NEGRITA}║       SUITE BIOINFORMÁTICA UNIFICADA - ANALIZADOR AMR        ║${RESET}"
echo "${MORADO}${NEGRITA}║                   Bioinformática UPC 2026                    ║${RESET}"
echo "${MORADO}${NEGRITA}╚══════════════════════════════════════════════════════════════╝${RESET}"
echo ""


#Información basica del usuario

echo "${CYAN}${NEGRITA}╔══════════════════════════════════════════╗${RESET}"
echo "${CYAN}${NEGRITA}║          INFORMACIÓN DEL USUARIO         ║${RESET}"
echo "${CYAN}${NEGRITA}╚══════════════════════════════════════════╝${RESET}"
echo ""

read -p "👤 Nombre del Investigador: " investigador
echo "🖥️  Máquina                   : $HOSTNAME"
echo "🐚 Shell                     : $SHELL"
echo "📂 Directorio HOME           : $HOME"
echo "📍 Directorio actual         : $PWD"
echo "🌐 Idioma                    : $LANG"
echo "🔢 PID del script            : $$"

#Se iniciara con idetificar los archivos que se tienen en data

echo "${CYAN}${NEGRITA}╔══════════════════════════════════════════╗${RESET}"
echo "${CYAN}${NEGRITA}║          Archivos a analizar             ║${RESET}"
echo "${CYAN}${NEGRITA}╚══════════════════════════════════════════╝${RESET}"

#Se inserta como variable todos nuestros archivos .fna
for organismos in "$DIR_DATA"/*fna
do
	[ -e "$organismos" ] || continue
	echo "-$organismos"
done

echo ""
echo ""

# =========================================================================
#                            MENÚ PRINCIPAL
# =========================================================================

while true; do

    echo "${AZUL}${NEGRITA}==============================================================${RESET}"
    echo "${AZUL}${NEGRITA}                 MENÚ DE ANÁLISIS GENÓMICO                    ${RESET}"
    echo "${AZUL}  [1] Información general, Control de Calidad, %GC y Chargaff${RESET}"
    echo "${AZUL}  [2] Búsqueda de motivos de secuencia (blaZ / Personalizado)${RESET}"
    echo "${AZUL}  [3] Diagnóstico preciso de gen + promotor (Bakta / NCBI)${RESET}"
    echo "${AZUL}  [4] Identificación de factores de virulencia (Abricate / VFDB)${RESET}"
    echo "${AZUL}  [5] Búsqueda complementaria de AMR y Mutaciones (CARD / AMRFinder)${RESET}"
    echo "${AZUL}  [6] Salir${RESET}"
    echo "${AZUL}${NEGRITA}==============================================================${RESET}"
    read -p "${CYAN}Elige una opción: ${RESET}" opcion

    echo ""

    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 1: INFORMACIÓN GENERAL, CONTROL DE CALIDAD, %GC Y CHARGAFF
    # ─────────────────────────────────────────────────────────────────────
    if [ "$opcion" = "1" ]; then
	echo "${MORADO}${NEGRITA}------------------------------------------------------------${RESET}"
        echo "${MORADO}${NEGRITA}  ANÁLISIS 1: PERFIL GENÓMICO GENERAL Y %GC${RESET}"
        echo "${MORADO}${NEGRITA}------------------------------------------------------------${RESET}"
	corta=0
        mediana=0
        larga=0

        # Módulo de Calificador de calidad de secuencia
        echo -e "\e[32mCalificador de calidad de secuencia\e[0m"
        for calidad in "$DIR_DATA"/*fna
        do
            [ -e "$calidad" ] || continue
            longitud=0
            while read -r lineas
            do
                if [[ $lineas == ">"* ]]
                then
                    true
                else
                    longitud=$((longitud + ${#lineas}))
                fi
            done < "$calidad"

            if [ $longitud -lt 100 ]
            then
                corta=$((corta + 1))
            elif [ $longitud -lt 900 ]
            then
                mediana=$((mediana + 1 ))
            else
                larga=$((larga + 1))
            fi
        done

        echo -e "\e[32mSecuencias cortas(<100 bp):\e[0m $corta"
        echo -e "\e[32mSecuencias medias(100-900):\e[0m $mediana"
        echo -e "\e[32mSecuencias largas(>900 bp):\e[0m $larga"
        echo ""

        # Análisis detallado por organismo
        for organismos in "$DIR_DATA"/*fna
        do
            [ -e "$organismos" ] || continue
            echo "${CYAN}Analizando muestra: $organismos${RESET}"

            bacteria=$(grep ">" "$organismos" | head -n 1 | sed 's/^>[^ ]* //' | cut -d',' -f1)
            contigs=$(grep -c ">" "$organismos")
            secuencia=$(grep -v ">" "$organismos" | tr -d "\n\r" | tr 'a-z' 'A-Z')

            total=$(echo -n "$secuencia" | wc -c)
            total_mb=$(echo "scale=2; $total/1000000" | bc)
            conteo_n=$(echo -n "$secuencia" | tr -cd "N" | wc -c)

            conteo_a=$(echo -n "$secuencia" | tr -cd "A" | wc -c)
            conteo_t=$(echo -n "$secuencia" | tr -cd "T" | wc -c)
            conteo_g=$(echo -n "$secuencia" | tr -cd "G" | wc -c)
            conteo_c=$(echo -n "$secuencia" | tr -cd "C" | wc -c)
            conteo_gc=$((conteo_g + conteo_c))

            pct_a=$(echo "scale=1; $conteo_a*100/$total" | bc)
            pct_t=$(echo "scale=1; $conteo_t*100/$total" | bc)
            pct_g=$(echo "scale=1; $conteo_g*100/$total" | bc)
            pct_c=$(echo "scale=1; $conteo_c*100/$total" | bc)
            pct_gc=$(echo "scale=2; $conteo_gc*100/$total" | bc)

            diff_at=$(echo "scale=1; $pct_a-$pct_t" | bc | tr -d '-')
            diff_gc=$(echo "scale=1; $pct_g-$pct_c" | bc | tr -d '-')

            if (( $(echo "$diff_at < 1" | bc -l) )) && (( $(echo "$diff_gc < 1" | bc -l) )); then
                cumple_chargaff="SÍ cumple la Regla de Chargaff → Genoma de doble cadena íntegro y bien ensamblado"
            else
                cumple_chargaff="NO cumple la Regla de Chargaff → El ensamblaje podría estar incompleto"
            fi

            accession=$(grep ">" "$organismos" | grep -o "NC_[0-9.]*" | head -n 1)
            cds="N/A"; rrna="N/A"; trna="N/A"
            if [ ! -z "$accession" ]; then
                ft=$(efetch -db nuccore -id "$accession" -format ft 2>/dev/null)
                if [ ! -z "$ft" ]; then
                    cds=$(echo "$ft" | grep -c "	CDS")
                    rrna=$(echo "$ft" | grep -c "	rRNA")
                    trna=$(echo "$ft" | grep -c "	tRNA")
                fi
            fi

            echo "${NEGRITA}Investigador      :${RESET} $investigador"
            echo "${NEGRITA}Bacteria          :${RESET} $bacteria"
            echo "${NEGRITA}Nº de contigs     :${RESET} $contigs"
            echo "${NEGRITA}Tamaño total      :${RESET} $total_mb Mb ($total bp)"
            echo "${NEGRITA}Nucleótidos N     :${RESET} $conteo_n"
            echo "${MORADO}${NEGRITA}--- Anotación génica (NCBI) ---${RESET}"
            echo "${NEGRITA}CDS:${RESET} $cds | ${NEGRITA}rRNA:${RESET} $rrna | ${NEGRITA}tRNA:${RESET} $trna"
            echo "%A = $pct_a%  %T = $pct_t%  Diferencia: $diff_at%"
            echo "%G = $pct_g%  %C = $pct_c%  Diferencia: $diff_gc%"
            echo "%GC               : ${AMARILLO}$pct_gc%${RESET}"
            echo "Chargaff          : $cumple_chargaff"
            echo ""

            # Guardar reporte por organismo
            {
                echo "=== ANÁLISIS 1: PERFIL GENÓMICO GENERAL Y %GC ==="
                echo "Fecha             : $(date)"
                echo "Investigador      : $investigador"
                echo "Bacteria analizada: $bacteria"
                echo "Archivo           : $organismos"
                echo "Nº de contigs     : $contigs"
                echo "Tamaño total      : $total_mb Mb ($total bp)"
                echo "Nucleótidos N     : $conteo_n"
                echo "Genes CDS         : $cds"
                echo "rRNA              : $rrna"
                echo "tRNA              : $trna"
                echo "Adenina (A)       : $conteo_a ($pct_a%)"
                echo "Timina (T)        : $conteo_t ($pct_t%)"
                echo "Guanina (G)       : $conteo_g ($pct_g%)"
                echo "Citosina (C)      : $conteo_c ($pct_c%)"
                echo "%GC               : $pct_gc%"
                echo "Resultado Chargaff: $cumple_chargaff"
                echo "----------------------------------------------------"
            } >> "$DIR_RESULTADOS/opcion1_resultado.txt"
        done
	echo "${VERDE}✔ Resultado acumulado guardado en $DIR_RESULTADOS/opcion1_resultado
        echo ""


    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 2: BÚSQUEDA DE MOTIVOS DE SECUENCIA
    # ─────────────────────────────────────────────────────────────────────
    elif [ "$opcion" = "2" ]; then

	echo "${MORADO}${NEGRITA}--------------------------------------------${RESET}"
        echo "${MORADO}${NEGRITA}   ANÁLISIS 2: BÚSQUEDA DE MOTIVO${RESET}"
        echo "${MORADO}${NEGRITA}--------------------------------------------${RESET}"
        echo ""
        echo "${AZUL}Motivos predefinidos de resistencia:${RESET}"
        echo "${AZUL}  [1] Análisis gen blaZ + promotor AMR${RESET}"
        echo "${AZUL}  [2] Ingresar motivo personalizado${RESET}"
        echo ""
        read -p "${CYAN}Elige una opción: ${RESET}" op_motivo

        for organismos in "$DIR_DATA"/*fna
        do
            [ -e "$organismos" ] || continue
            bacteria=$(grep ">" "$organismos" | head -n 1 | sed 's/^>[^ ]* //' | cut -d',' -f1)

            if [ "$op_motivo" = "1" ]; then
                ocurrencias_gen=$(grep -v ">" "$organismos" | grep -o "ATGAGC" | wc -l)
                ocurrencias_promotor=$(grep -v ">" "$organismos" | grep -o "TTGACA" | wc -l)

                echo ""
                echo "${NEGRITA}Archivo               :${RESET} $organismos"
                echo "${NEGRITA}Investigador          :${RESET} $investigador"
                echo "${NEGRITA}Bacteria              :${RESET} $bacteria"
                echo "${NEGRITA}Gen blaZ (ATGAGC)     :${RESET} ${VERDE}$ocurrencias_gen ocurrencias${RESET}"
                echo "${NEGRITA}Promotor AMR (TTGACA) :${RESET} ${VERDE}$ocurrencias_promotor ocurrencias${RESET}"

                if [ "$ocurrencias_gen" -gt 0 ] && [ "$ocurrencias_promotor" -gt 0 ]; then
                    interpretacion_motivo="Gen blaZ y promotor presentes → Posible expresión activa de resistencia a penicilina"
                elif [ "$ocurrencias_gen" -gt 0 ] && [ "$ocurrencias_promotor" -eq 0 ]; then
                    interpretacion_motivo="Gen blaZ presente pero sin promotor detectado → Podría no estar expresado"
                elif [ "$ocurrencias_gen" -eq 0 ] && [ "$ocurrencias_promotor" -gt 0 ]; then
                    interpretacion_motivo="Promotor presente pero gen blaZ no detectado → Podría activar otros genes"
                else
                    interpretacion_motivo="No se detectaron marcadores de resistencia a penicilina"
                fi
                echo "Interpretación        : $interpretacion_motivo"

                {
                    echo "=== ANÁLISIS 2: BÚSQUEDA DE MOTIVO (blaZ + promotor AMR) ==="
                    echo "Fecha             : $(date)"
                    echo "Investigador      : $investigador"
                    echo "Bacteria analizada: $bacteria"
                    echo "Archivo           : $organismos"
                    echo "Gen blaZ (ATGAGC)     : $ocurrencias_gen ocurrencias"
                    echo "Promotor AMR (TTGACA) : $ocurrencias_promotor ocurrencias"
                    echo "Interpretación    : $interpretacion_motivo"
                    echo "----------------------------------------------------"
		} >> "$DIR_RESULTADOS/opcion2_resultado.txt"
            elif [ "$op_motivo" = "2" ]; then
                if [ -z "$motivo" ]; then
                    read -p "${CYAN}Ingresa tu motivo (solo A, T, G, C): ${RESET}" motivo
                    motivo=$(echo "$motivo" | tr 'a-z' 'A-Z')
                fi

                ocurrencias=$(grep -v ">" "$organismos" | grep -o "$motivo" | wc -l)

                echo ""
                echo "${NEGRITA}Archivo        :${RESET} $organismos"
                echo "${NEGRITA}Investigador   :${RESET} $investigador"
                echo "${NEGRITA}Bacteria       :${RESET} $bacteria"
                echo "${NEGRITA}Motivo buscado :${RESET} $motivo"
                echo "${NEGRITA}Ocurrencias    :${RESET} $ocurrencias"

                {
                    echo "=== ANÁLISIS 2: BÚSQUEDA DE MOTIVO PERSONALIZADO ==="
                    echo "Fecha             : $(date)"
                    echo "Investigador      : $investigador"
                    echo "Bacteria analizada: $bacteria"
                    echo "Archivo           : $organismos"
                    echo "Motivo buscado    : $motivo"
                    echo "Ocurrencias       : $ocurrencias"
                    echo "----------------------------------------------------"
		} >> "$DIR_RESULTADOS/opcion2_resultado.txt"
            fi
        done
        unset motivo
	echo ""
        echo "${VERDE}✔ Resultado guardado en $DIR_RESULTADOS/opcion2_resultado.txt${RESET}"
	echo ""      
	 read -p "${CYAN}Presiona [Enter] para volver al menú principal...${RESET}"
        echo ""
        echo ""
    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 3: DIAGNÓSTICO PRECISO  DE GEN + PROMOTOR (BAKTA / NCBI)
    # ─────────────────────────────────────────────────────────────────────
    elif [ "$opcion" = "3" ]; then
	echo "========================================================================="
        echo -e "\e[32m     Comprobando dependencias del sistema\e[0m"
        echo "========================================================================="

        #Comprobación que el usuario tenga la base de datos completa de Bakta
        if command -v bakta &> /dev/null && [ -d ~/bakta_db_real/db-light ]; then
            echo "✔ Sistema Bakta completo detectado."
            MODO_BUSQUEDA="BAKTA"
        else
            echo -e "\e[32mNo se halla base de datos, script funcionará con alternativa alterna, buscando vía NCBI.\e[0m"
            MODO_BUSQUEDA="EFETCH"
            
            #Base de datos fantasma 
            mkdir -p "$DIR_REFERENCIAS/db_falsa"
            touch "$DIR_REFERENCIAS/db_falsa/db-light.sqlite"
        fi

        #Comprobar que se tenga instalado entorno Bakta
        if ! command -v bakta &> /dev/null; then
            echo -e "\e[31mNo se procederá con el análisis, debe conseguir Bakta\e[0m"
            exit 1
        else
            echo -e "\e[32m✔ Bakta detectado correctamente.\e[0m"
            echo -e "\e[32m✔ Comprobación del entorno finalizada\e[0m"
        fi

        #Zonas que estamos buscando
        PROMOTOR_35="TTGACA"
        PROMOTOR_10="TATAAT"

        echo ""
        echo ""

        #Generar tabla donde identificamos si hay gen de resistencia con dicho promotor

        ARCHIVO_TABLA="$DIR_RESULTADOS/reporte_genes_resistencia.txt"

        echo "========================================================================="
        echo -e "\e[32m        Tabla de condiciones del genoma analizado\e[0m"
        echo "========================================================================="

        printf "| %-35s | %-16s | %-16s | %-13s |\n" "Organismo (NCBI + Nombre)" "¿Tiene Gen Res.?" "¿Tiene Promotor?" "Diagnóstico" > "$ARCHIVO_TABLA"
        echo "-----------------------------------------------------------------------------------------" >> "$ARCHIVO_TABLA"
        for organismos in "$DIR_DATA"/*fna
        do
            #una validación:!EL usuario deve tener ya sus archivos descargados en su scrip
            [ -e "$organismos" ] || continue
            #Limpieza
            adn_unido=$(grep -v ">" "$organismos" | tr -d '\n' | tr -d '\r' | tr 'a-z' 'A-Z')
            encabezado_organismo=$(grep ">" "$organismos" | head -n 1 | cut -d' ' -f1-3)

            if [[ "$organismos" == *"aeruginosa"* ]]; then
                read -p "Ingresar nombre del gen de resistencia que buscas para Pseudomonas: " GEN_RESISTENCIA
                read -p "Ingresar el código NCBI de ese gen de resistencia: " NCBI_ID

            elif [[ "$organismos" == *"s_aureus"* ]]; then
                read -p "Ingresar nombre del gen de resistencia que buscas para S. aureus: " GEN_RESISTENCIA
                read -p "Ingresar el código NCBI de ese gen de resistencia: " NCBI_ID

            elif [[ "$organismos" == *"tuberculosis"* ]]; then
                read -p "Ingresar nombre del gen de resistencia que buscas para Tuberculosis: " GEN_RESISTENCIA
                read -p "Ingresar el código NCBI de ese gen de resistencia: " NCBI_ID

            else
                GEN_RESISTENCIA="Desconocido"
                NCBI_ID=""
            fi
            
            #Ya buscamos lo que queriamos ahora buscar en base de dato e insertar datos en tabla
            HAS_GEN="NO"
            HAS_PROMOTOR="NO"
            DIAGNOSTICO="SENSIBLE"
            posicion_gen=""

            #Opcion A: Si el usuario tiene base de datos de bakta
            if [ "$MODO_BUSQUEDA" == "BAKTA" ]; then
                bakta --output res_bakta --prefix anotacion "$organismos" &> /dev/null
                posicion_gen=$(grep -i "$GEN_RESISTENCIA" res_bakta/anotacion.gff | awk '{print $3}' | head -n 1)
                if [ ! -z "$posicion_gen" ]; then
                    HAS_GEN="SÍ ($GEN_RESISTENCIA)"
                fi
            
            #Obción B: El usuario no tiene base de datos Bakta 
            else
                bakta --db "$DIR_REFERENCIAS/db_falsa/" --skip-cds --skip-plot --skip-trna --skip-rrna "$organismos" &> /dev/null
                if [ ! -z "$NCBI_ID" ]; then
                
                    secuencia_buscar=$(efetch -db nuccore -id "$NCBI_ID" -format fasta 2>/dev/null | grep -v ">" | tr -d '\n' | head -c 12)
                    coordenada=$(echo "$adn_unido" | grep -b -o "$secuencia_buscar" | head -n 1)
                    if [ ! -z "$coordenada" ]; then
                        HAS_GEN="SÍ ($GEN_RESISTENCIA)"
                        posicion_gen=${coordenada%%:*}
                    fi
                    #borrar archivo temporal
                fi
            fi

            #Tenemos hallado ubicación del gen ahora extración del upstream y analisis del promotor
            if [ ! -z "$posicion_gen" ] && [ "$posicion_gen" -gt 100 ]; then
                #aca el gen son 100 nucleotidos los retiramos
                inicio_promotor=$((posicion_gen - 100))
                #pasamos los numeros hallados a letras 
                region_promotora=${adn_unido:$inicio_promotor:100}

                #buscamos regiones -10 y -35
                check_35=$(echo "$region_promotora" | grep -o "$PROMOTOR_35" | head -n 1)
                check_10=$(echo "$region_promotora" | grep -o "$PROMOTOR_10" | head -n 1)
                if [ ! -z "$check_35" ] || [ ! -z "$check_10" ]; then
                    HAS_PROMOTOR="SÍ (-10/-35)"
                    DIAGNOSTICO="RESISTENTE"
                else
                    HAS_PROMOTOR="NO (Mutado)"
                    DIAGNOSTICO="SENSIBLE"
                fi
            fi
            #imprimimos tabla
            printf "| %-35.35s | %-16s | %-16s | %-13s |\n" "$encabezado_organismo" "$HAS_GEN" "$HAS_PROMOTOR" "$DIAGNOSTICO" >> "$ARCHIVO_TABLA"
        done
        echo -e "\e[32m✔ Tabla generada con éxito respuestas y diagnósticos en:\e[0m"
        echo -e "$ARCHIVO_TABLA"
        echo ""

    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 4: IDENTIFICACIÓN DE FACTORES DE VIRULENCIA (ABRICATE)
    # ─────────────────────────────────────────────────────────────────────
    elif [ "$opcion" = "4" ]; then

        echo "╔══════════════════════════════════════════╗"
        echo "║      FACTORES GENES DE VIRULENCIA        ║"
        echo "╚══════════════════════════════════════════╝"

        if conda run -n entorno_abricate command -v abricate &>/dev/null; then
            echo -e "\e[32m Sistema Abricate detectado y listo para usar.\e[0m"
        else
            echo -e "\e[31m  ERROR: Abricate no está disponible. Revise entorno o instalación\e[0m"
        fi

        for organismos in "$DIR_DATA"/*fna
        do
            [ -e "$organismos" ] || continue
            nombre_base=$(basename "$organismos" .fna)
            archivo_reporte="$DIR_RESULTADOS/reporte_vir_${nombre_base}.txt"

            conda run -n entorno_abricate abricate --db vfdb "$organismos" > "$archivo_reporte" 2>/dev/null
            genes_reales=$(grep -v "^#" "$archivo_reporte")

            if [ -z "$genes_reales" ]; then
                HAS_VIRULENCIA="No"
                rm -f "$archivo_reporte"
            else 
                HAS_VIRULENCIA="SÍ"
                echo "=== GENES DE VIRULENCIA DETECTADOS EN $nombre_base ===" > "${archivo_reporte}.tmp"
                grep -v "^#" "$archivo_reporte" | awk '{print "- " $6}' >> "${archivo_reporte}.tmp"
                mv "${archivo_reporte}.tmp" "$archivo_reporte"
                echo -e "\e[32m Reporte de virulencia limpio generado en:\e[0m"
                echo "$archivo_reporte"
            fi
	done
	rm -f "$DIR_RESULTADOS"/*.tmp 2>/dev/null
        rm -f ./*.log 2>/dev/null
        echo ""


    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 5: BÚSQUEDA COMPLEMENTARIA DE AMR Y MUTACIONES (PUNTUALES)
    # ─────────────────────────────────────────────────────────────────────
    elif [ "$opcion" = "5" ]; then
	echo "${MORADO}${NEGRITA}------------------------------------------------------------${RESET}"
        echo "${MORADO}${NEGRITA}  ANÁLISIS 5: DETECCIÓN COMPLEMENTARIA DE AMR Y MUTACIONES${RESET}"
        echo "${MORADO}${NEGRITA}------------------------------------------------------------${RESET}"
	for organismos in "$DIR_DATA"/*fna
        do
            [ -e "$organismos" ] || continue
            nombre_base=$(basename "$organismos" .fna)
            archivo_amr="$DIR_RESULTADOS/reporte_amr_${nombre_base}.txt"

            echo -e "\e[36mProcesando análisis complementario CARD para: $nombre_base...\e[0m"

            # Ejecutamos abricate directamente con la base de datos CARD
            abricate --db card "$organismos" > "$archivo_amr.tmp" 2>/dev/null

            # Verificamos si se detectaron genes/mutaciones (ignorando la cabecera)
            genes_encontrados=$(grep -v "^#" "$archivo_amr.tmp")

            if [ -n "$genes_encontrados" ]; then
                # Formateamos un reporte limpio
                echo "=========================================================================" > "$archivo_amr"
                echo "   REPORTE COMPLEMENTARIO DE AMR Y MUTACIONES       " >> "$archivo_amr"
                echo "=========================================================================" >> "$archivo_amr"
                echo "Muestra analizada: $nombre_base" >> "$archivo_amr"
                echo "Fecha de análisis: $(date)" >> "$archivo_amr"
                echo "Investigador     : $investigador" >> "$archivo_amr"
                echo "-------------------------------------------------------------------------" >> "$archivo_amr"
                echo "" >> "$archivo_amr"

                # Extraemos Gen/Determinante ($6), % Cobertura ($9), % Identidad ($10) y Resistencia/Mecanismo ($11)
                grep -v "^#" "$archivo_amr.tmp" | awk -F'\t' '{print "- Gen/Determinante: " $6 " | Cobertura: " $9 "% | Identidad: " $10 "% | Resistencia/Mecanismo: " $11}' >> "$archivo_amr"

                rm -f "$archivo_amr.tmp"
                echo -e "\e[32m✔ Reporte AMR generado con éxito en:\e[0m"
                echo -e "$archivo_amr"
            else
                echo "No se encontraron determinantes de resistencia ni mutaciones CARD para $nombre_base" > "$archivo_amr"
                rm -f "$archivo_amr.tmp"
                echo -e "\e[33m⚠ No se detectaron marcadores CARD en $nombre_base. Reporte guardado.\e[0m"
            fi
            echo ""
        done
        echo -e "\e[32m✔ Proceso completado para todas las muestras en $DIR_RESULTADOS\e[0m"
        echo ""
    # ─────────────────────────────────────────────────────────────────────
    # OPCIÓN 6: SALIR
    # ─────────────────────────────────────────────────────────────────────
    elif [ "$opcion" = "6" ]; then
        rm -f ./*.log 2>/dev/null
        echo "${VERDE}Saliendo del analizador.${RESET}"
        echo "${VERDE}¡Hasta pronto!${RESET}"
        exit 0

    else
        echo "${ROJO}Opción no válida. Intenta de nuevo.${RESET}"
        echo ""
    fi

done
