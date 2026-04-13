# 🎵 Herramienta de Cálculo de Reverberación y Ruido de Impacto Acústico

## Descripción General

Herramienta completa en **MATLAB** para análisis acústico profesional de recintos, implementando cálculos según normas ISO internacionales:
- **ISO 3382-2**: Medición de parámetros acústicos (reverberación)
- **ISO 16283-2**: Medición de aislamiento a ruido de impacto
- **ISO 717-2**: Clasificación y ponderación de aislamiento a impacto

## 🎯 Funcionalidades Principales

### ✅ Bloque 1: Cálculo de Reverberación (T₆₀)

Implementa **tres métodos** de cálculo:

| Método | Fórmula | Aplicación |
|--------|---------|-----------|
| **Sabine** | $T_{RS} = 0.162 \cdot \frac{V}{\alpha_m S + 4mV}$ | Absorción homogénea, α_m < 0.3 |
| **Eyring** | $T_{RE} = 0.162 \cdot \frac{V}{-S\ln(1-\alpha_m) + 4mV}$ | Absorción no uniforme, α_m > 0.3 |
| **Millington** | $T_{RM} = 0.162 \cdot \frac{V}{\sum[-S_i\ln(1-\alpha_i)] + 4mV}$ | Materiales heterogéneos, especificación individual |

**Salida:** Tiempo de reverberación T₆₀ en segundos

### ✅ Bloque 2: Nivel de Impacto Ponderado (L'ₙₜ,w)

Cálculo normalizado en **tres pasos**:

1. **Nivel promediado** ($L_i$) - Promedio energético de mediciones
2. **Nivel estandarizado** ($L'_{nT}$) - Normalización según reverberación
3. **Nivel ponderado** ($L'_{nT,w}$) - Método ISO 717-2 con desplazamiento de curva

**Salida:** Valor único ponderado en dB (clasificable según ISO)

## 📁 Estructura del Proyecto

```
Herramienta-de-cálculo-de-reverberación-y-ruido-impacto/
│
├── main_acoustics_tool.m                    ⭐ Script principal
│   └─ Flujo completo con ejemplo
│
├── Funciones de Reverberación
│   ├── calculate_reverberation_sabine.m      • Método Sabine
│   ├── calculate_reverberation_eyring.m      • Método Eyring
│   └── calculate_reverberation_millington.m  • Método Millington
│
├── Funciones de Impacto
│   ├── calculate_impact_level.m              • Promedio energético
│   ├── calculate_standardized_impact_level.m • Normalización
│   └── calculate_weighted_impact_level.m     • Ponderación ISO 717-2
│
├── ejemplo_completo.m                       🔍 Ejemplo detallado
│   └─ Análisis paso a paso de aula típica
│
├── DOCUMENTACION_TECNICA.txt                📖 Referencia exhaustiva
│
└── README.md                                 (este archivo)
```

## 🚀 Inicio Rápido

### Opción 1: Análisis Automático (Recomendado)
```matlab
>> main_acoustics_tool
```
✓ Ejecuta el análisis completo con parámetros por defecto  
✓ Genera gráficos comparativos  
✓ Muestra todos los resultados

### Opción 2: Ejemplo Detallado Paso a Paso
```matlab
>> ejemplo_completo
```
✓ Análisis de aula universitaria real  
✓ Explica cada paso en la consola  
✓ Gráficos mejorados y tabla de resultados

### Opción 3: Uso Programático
```matlab
%% Calcular reverberación
alpha_m = 0.25;  % Coef. absorción
S = 120;         % Superficie (m²)
V = 250;         % Volumen (m³)
m = 0.000007;    % Atenuación

T_sabine = calculate_reverberation_sabine(alpha_m, S, m, V);
T_eyring = calculate_reverberation_eyring(alpha_m, S, m, V);

%% Calcular impacto
L_i = calculate_impact_level(L_measurements);
L_nT = calculate_standardized_impact_level(L_i, T_eyring, 0.5);
L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);
```

## 📊 Parámetros de Entrada

### Variables de Reverberación

| Parámetro | Símbolo | Rango | Unidad |
|-----------|---------|-------|--------|
| Volumen | $V$ | 50-1000 | m³ |
| Superficie | $S$ | 100-500 | m² |
| Absorción media | $\alpha_m$ | 0.05-0.80 | − |
| Atenuación (aire) | $m$ | 5×10⁻⁶ a 15×10⁻⁶ | m⁻¹ |

### Variables de Impacto

| Parámetro | Rango | Unidad |
|-----------|-------|--------|
| Mediciones | 40-80 | dB ref 20μPa |
| Frecuencias | 100-3150 | Hz (tercio octava) |
| Reverberación | 0.3-2.0 | s |
| Referencia (T₀) | 0.5 | s (viviendas) |

## 📈 Resultados de Ejemplo

### Aula Universitaria Típica (5m × 4m × 5m)
```
Volumen:          100 m³
Absorción media:  0.35 (techo acústico)
─────────────────────────────
T₆₀ (Sabine):     0.42 s
T₆₀ (Eyring):     0.58 s
T₆₀ (Millington): 0.55 s
─────────────────────────────
L'ₙₜ,w:           ≈53 dB
```

### Oficina Estándar
```
Volumen:          250 m³
Absorción media:  0.25
─────────────────────────────
T₆₀ (Sabine):     1.04 s
L'ₙₜ,w:           ≈48 dB
```

## 📖 Fórmulas Matemáticas

### Reverberación
$$T_{RS}^{Sabine} = 0.162 \cdot \frac{V}{\alpha_m S + 4mV}$$

$$T_{RE}^{Eyring} = 0.162 \cdot \frac{V}{-S\ln(1-\alpha_m) + 4mV}$$

### Impacto Acústico
$$L_i = 10\log_{10}\left(\frac{1}{n}\sum_{j=1}^{n}10^{L_j/10}\right)$$

$$L'_{nT} = L_i - 10\log_{10}\left(\frac{T}{T_0}\right)$$

$$L'_{nT,w} = \text{Valor a 500 Hz de curva ISO 717-2 desplazada}$$

## 🔍 Normas Implementadas

### ISO 3382-2:2008
Medición de parámetros acústicos en recintos:
- Define métodos de cálculo de reverberación
- Especifica condiciones de medición
- Sabine, Eyring y métodos derivados

### ISO 16283-2:2018
Medición de aislamiento a ruido de impacto:
- Distribución normalizada de puntos
- Máquina de impactos estándar
- Procedimiento de promediado energético
- Corrección por reverberación

### ISO 717-2:2020
Ráting de aislamiento a impacto:
- Curva de referencia normativa
- Método de desplazamiento (1 dB)
- Límite de desviaciones: 32 dB máximo
- Lectura a 500 Hz

## 💡 Referencia de Materiales

### Coeficientes Típicos de Absorción (500 Hz)

| Material | α | Aplicación |
|----------|---|-----------|
| Hormigón/Ladrillo | 0.02-0.05 | Estructuras masivas |
| Yeso/Pintura | 0.03-0.08 | Paredes enlucidas |
| Madera blanda | 0.10-0.15 | Pisos y revestimientos |
| Cortinas/Tapicería | 0.30-0.50 | Tratamiento acústico |
| Lana mineral | 0.60-0.80 | Aislamiento acústico |
| Techo acústico | 0.70-0.90 | Soluciones comerciales |
| Agua | 0.01 | Muy reflectante |

### T₆₀ Típicos por Uso

| Tipo de Recinto | T₆₀ | Características |
|-----------------|-----|-----------------|
| Estudio grabación | 0.2-0.4 s | Muy controlado |
| Aula/Oficina | 0.5-1.0 s | **Estándar ISO** |
| Sala conferencias | 0.8-1.2 s | Inteligibilidad alta |
| Iglesia | 2.0-5.0 s | Reverberante |
| Sala conciertos | 1.5-2.5 s | Acústica musical |

## ⚙️ Personalización

### Cambiar Parámetros del Recinto
En `main_acoustics_tool.m`:
```matlab
V = 150;        % Volumen en m³
S = 160;        % Superficie en m²
alpha_m = 0.30; % Absorción media
m = 0.000007;   % Atenuación del aire
```

### Especificar Materiales (Millington)
```matlab
superficies = [
    80, 0.05;    % Paredes: 80 m², α=0.05
    20, 0.80;    % Techo: 20 m², α=0.80
    30, 0.25     % Piso: 30 m², α=0.25
];
T_mill = calculate_reverberation_millington(superficies, S, m, V);
```

### Insertar Mediciones Reales
```matlab
L_measurements = [
    50, 51, 49, 52; % Posición 1
    51, 50, 52, 51; % Posición 2
    49, 52, 50, 49  % Posición 3
];
```

## ✓ Características

- ✅ Implementación exacta de normas ISO
- ✅ Múltiples métodos para verificación cruzada
- ✅ Interfaz clara y documentada
- ✅ Resultados comparables internacionalmente
- ✅ Gráficos informativos automáticos
- ✅ Cálculos rápidos y precisos

## ⚠️ Limitaciones

- Métodos válidos para recintos "regulares" (no muy complejos)
- Sabine menos precisa si α_m > 0.3
- No considera difracción ni reflexiones especulares complejas
- Precisión depende de exactitud de parámetros de entrada

## 🧪 Validación

La herramienta produce resultados verificables:
- Comparables con cálculos manuales según ISO
- Validables contra mediciones reales
- Trazables y auditables
- Reproducibles

## 📚 Documentación Completa

Para información exhaustiva, consultar: **[DOCUMENTACION_TECNICA.txt](DOCUMENTACION_TECNICA.txt)**

Contiene:
- Explicación detallada de cada fórmula
- Casos de uso avanzado
- Tablas de referencia completas
- Resolución de problemas
- Bibliografía completa

## 🔗 Referencias Normativas

Consultadas y implementadas:
- ISO 3382-2:2008 - Measurement of room acoustic parameters Part 2
- ISO 16283-2:2018 - Sound insulation in buildings Part 2: Impact sound
- ISO 717-2:2020 - Rating of sound insulation Part 2: Impact sound

## 📞 Soporte y Mejoras

Para consultas o reportar problemas:
1. Verificar parámetros de entrada
2. Consultar `DOCUMENTACION_TECNICA.txt`
3. Ejecutar `ejemplo_completo.m` para validación
4. Comparar contra mediciones reales si están disponibles

## 📝 Información del Proyecto

- **Tipo:** Herramienta Académica/Profesional
- **Lenguaje:** MATLAB R2018a o superior
- **Versión:** 1.0
- **Estado:** ✅ Operacional
- **Licencia:** Uso académico y profesional libre

---

**Última actualización:** Abril 2026  
**Desarrollo:** Proyecto 1 - Opción B (Acústica)  
**Universidad de Castilla-La Mancha**
