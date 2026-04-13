function L_nTw = calculate_weighted_impact_level(frecuencias, L_nT)
%% CÁLCULO DEL NIVEL PONDERADO DE IMPACTO (L'ₙₜ,w) - ISO 717-2
%
% SINTAXIS:
%   L_nTw = calculate_weighted_impact_level(frecuencias, L_nT)
%
% ENTRADA:
%   frecuencias : Vector fila de frecuencias en bandas de tercio de octava (Hz)
%   L_nT        : Vector fila de niveles estandarizados de impacto (dB)
%                 Obtenido de calculate_standardized_impact_level()
%
% SALIDA:
%   L_nTw       : Valor escalar del nivel ponderado de impacto (dB)
%
% DESCRIPCIÓN:
% El método ISO 717-2 para calcular L'ₙₜ,w NO usa una fórmula matemática simple,
% sino un proceso de comparación y desplazamiento de curva:
%
% 1. Se toman los espectros L'ₙₜ entre 100 Hz y 3150 Hz
% 2. Se compara con la curva de referencia (definida en ISO 717-2)
% 3. Se desplaza la curva de referencia en incrementos de 1 dB
% 4. Se calcula la suma de desviaciones desfavorables (UNFAV)
% 5. La curva se posiciona de manera que UNFAV < 32 dB, pero máxima
% 6. Se lee L'ₙₜ,w de la curva de referencia desplazada a 500 Hz
%
% REFERENCIAS:
%   ISO 717-2:2020 (Clasificación del aislamiento acústico a ruido de impacto)
%   Curva de referencia normativa
%
% NOTAS:
%   - Rango de análisis: 100 Hz a 3150 Hz (bandas de tercio de octava)
%   - Incremento de desplazamiento: 1 dB
%   - Límite de UNFAV: 32 dB máximo
%   - El resultado se lee a 500 Hz de la curva ajustada

% Curva de referencia ISO 717-2 (del documento normativo)
% Valores de la curva de referencia a frecuencias de tercio de octava
% 100 Hz hasta 3150 Hz

% Estos valores están normalizados en la norma ISO 717-2
% Representan el nivel "de diseño" para comparación
curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
                  1250, 1600, 2000, 2500, 3150];
curve_ref_level = [62, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, ...
                   52, 51, 50, 49, 48];

% Verificar que las frecuencias coincidan o interpolar
if numel(frecuencias) ~= numel(L_nT)
    error('Error: Longitud de frecuencias y L_nT no coinciden.');
end

% Encontrar índices de frecuencias relevantes (100-3150 Hz)
idx_start = find(frecuencias >= 100, 1);
idx_end = find(frecuencias <= 3150, 1, 'last');

if isempty(idx_start) || isempty(idx_end)
    error('Error: El rango de frecuencias debe incluir al menos 100-3150 Hz.');
end

% Extraer rango de análisis
freq_analysis = frecuencias(idx_start:idx_end);
L_nT_analysis = L_nT(idx_start:idx_end);

% Asegurar que tenemos exactamente la curva de referencia para comparar
if length(freq_analysis) ~= length(curve_ref_freq) || any(abs(freq_analysis - curve_ref_freq) > 1e-10)
    % Si las frecuencias no coinciden exactamente, interpolar L_nT
    L_nT_analysis = interp1(freq_analysis, L_nT_analysis, curve_ref_freq, 'linear', 'extrap');
    freq_analysis = curve_ref_freq;
end

% ALGORITMO DE DESPLAZAMIENTO DE CURVA
% ──────────────────────────────────────
% Buscar el desplazamiento óptimo según ISO 717-2

best_shift = 0;
best_unfav = inf;

% Primero intentar encontrar desplazamiento con UNFAV < 32 dB
for shift = -40:1:40
    shifted_curve = curve_ref_level + shift;
    deviations = L_nT_analysis - shifted_curve;
    unfavorable = deviations(deviations > 0);
    sum_unfav = sum(unfavorable);
    
    % Buscar el máximo UNFAV que sea < 32 dB
    if sum_unfav < 32 && sum_unfav > best_unfav
        best_unfav = sum_unfav;
        best_shift = shift;
    end
end

% Si no se encontró ninguno con UNFAV < 32, buscar el que tenga menor UNFAV
if best_unfav == inf
    best_unfav = inf;
    for shift = -40:1:40
        shifted_curve = curve_ref_level + shift;
        deviations = L_nT_analysis - shifted_curve;
        unfavorable = deviations(deviations > 0);
        sum_unfav = sum(unfavorable);
        
        if sum_unfav < best_unfav
            best_unfav = sum_unfav;
            best_shift = shift;
        end
    end
end

% Aplicar el desplazamiento óptimo
final_curve = curve_ref_level + best_shift;

% Leer L'ₙₜ,w a 500 Hz
idx_500 = find(curve_ref_freq == 500);
if isempty(idx_500)
    error('Error: No se encuentra la frecuencia de 500 Hz en la curva de referencia.');
end

L_nTw = final_curve(idx_500);

% Información de depuración (opcional - deshabilitada por defecto)
% Para habilitar, cambiar verbose = true
verbose = false;

if verbose
    fprintf('\n  Método de ponderación ISO 717-2:\n');
    fprintf('  • Rango de análisis: 100 - 3150 Hz\n');
    fprintf('  • Desplazamiento óptimo: %d dB\n', best_shift);
    fprintf('  • Suma de desviaciones desfavorables: %.2f dB\n', best_unfav);
    fprintf('  • L´ₙₜ,w (valor a 500 Hz): %.1f dB\n', L_nTw);
end

end
