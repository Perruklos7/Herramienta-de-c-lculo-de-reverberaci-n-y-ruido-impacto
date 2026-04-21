function L_nTw = calculate_weighted_impact_level(frecuencias, L_nT)
%% CÁLCULO DEL NIVEL PONDERADO DE IMPACTO (Lₙₜ,w) - ISO 717-2
%
% SINTAXIS:
%   [L_nT, L_nTw] = calculate_weighted_impact_level(frecuencias, L_medidos, T, T0)
%
% ENTRADA:
%   frecuencias : Vector de frecuencias (Hz) de las bandas de tercio de octava
%   L_medidos   : Vector de niveles de presión sonora medidos (dB) en cada banda
%   T           : Tiempo de reverberación calculado (s)
%   T0          : Tiempo de reverberación de referencia (s, opcional, por defecto 0.5)
%
% SALIDA:
%   L_nTw       : Valor escalar del nivel ponderado de impacto (dB)
%
% DESCRIPCIÓN:
% El método ISO 717-2 para calcular Lₙₜ,w NO usa una fórmula matemática simple,
% sino un proceso de comparación y desplazamiento de curva:
%
% 1. Se toman los espectros Lₙₜ entre 100 Hz y 3150 Hz
% 2. Se compara con la curva de referencia (definida en ISO 717-2)
% 3. Se desplaza la curva de referencia en incrementos de 1 dB
% 4. Se calcula la suma de desviaciones desfavorables (UNFAV)
% 5. La curva se posiciona de manera que UNFAV < 32 dB, pero máxima
% 6. Se lee Lₙₜ,w de la curva de referencia desplazada a 500 Hz
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
curve_ref_level = [62, 62, 62, 62, 62, 62, 61, 60, 59, 58, 57, ...
                   54, 51, 48, 45, 42];

% Encontrar índices de frecuencias relevantes (100-3150 Hz)
idx_start = find(frecuencias >= 100, 1);
idx_end = find(frecuencias <= 3150, 1, 'last');
if isempty(idx_start) || isempty(idx_end)
    error('El rango de frecuencias debe incluir al menos 100-3150 Hz.');
end
freq_analysis = frecuencias(idx_start:idx_end);
L_nT_analysis = L_nT(idx_start:idx_end);

% Asegurar que tenemos exactamente la curva de referencia para comparar
if length(freq_analysis) ~= length(curve_ref_freq) || any(abs(freq_analysis - curve_ref_freq) > 1e-10)
    % Si las frecuencias no coinciden exactamente, interpolar L_nT
    L_nT_analysis = interp1(freq_analysis, L_nT_analysis, curve_ref_freq, 'linear', 'extrap');
    freq_analysis = curve_ref_freq;
end

% Algoritmo de desplazamiento de curva (ISO 717-2)
best_shift = 0;
best_unfav = 0;

% Se busca el desplazamiento en pasos de 1 dB.
% Al iterar desde valores negativos hacia positivos, la curva de referencia 
% va subiendo, lo que hace que las desviaciones desfavorables vayan bajando. 
% El primer valor que logre que la suma sea <= 32.0 dB será exactamente
% "lo más grande posible pero no más de 32.0 dB" (cumpliendo la ISO 717-2).
for shift = -100:1:100
    shifted_curve = curve_ref_level + shift;
    deviations = L_nT_analysis - shifted_curve;
    
    unfavorable = deviations(deviations > 0);
    sum_unfav = sum(unfavorable);
    
    if sum_unfav <= 32.0
        best_shift = shift;
        best_unfav = sum_unfav;
        break;
    end
end
final_curve = curve_ref_level + best_shift;

% Leer Lₙₜ,w a 500 Hz
idx_500 = find(curve_ref_freq == 500);
if isempty(idx_500)
    error('No se encuentra la frecuencia de 500 Hz en la curva de referencia.');
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
