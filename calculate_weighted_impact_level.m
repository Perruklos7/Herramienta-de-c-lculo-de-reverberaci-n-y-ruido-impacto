function [L_nTw, C_I, C_I_50_2500] = calculate_weighted_impact_level(frecuencias, L_nT)
%% CÁLCULO DEL NIVEL PONDERADO DE IMPACTO (Lₙₜ,w) Y COEFICIENTES - ISO 717-2
%
% SINTAXIS:
%   [L_nTw, C_I, C_I_50_2500] = calculate_weighted_impact_level(frecuencias, L_nT)
%
% ENTRADA:
%   frecuencias : Vector de frecuencias (Hz) de las bandas de tercio de octava
%   L_nT        : Vector de niveles de presión sonora estandarizados (dB)
%
% SALIDA:
%   L_nTw       : Valor escalar del nivel ponderado de impacto (dB)
%   C_I         : Coeficiente de adaptación espectral (100-2500 Hz)
%   C_I_50_2500 : Coeficiente de adaptación espectral (50-2500 Hz)
%
% DESCRIPCIÓN:
% El método ISO 717-2 para calcular Lₙₜ,w usa un proceso de comparación y
% desplazamiento de curva. Esta función también calcula los coeficientes de
% adaptación espectral C_I y C_I,50-2500.
%
% 1. Se toman los espectros Lₙₜ entre 100 Hz y 3150 Hz
% 2. Se compara con la curva de referencia (definida en ISO 717-2)
% 3. Se desplaza la curva de referencia en incrementos de 1 dB
% 4. Se calcula la suma de desviaciones desfavorables (UNFAV)
% 5. La curva se posiciona de manera que UNFAV < 32 dB, pero máxima
% 6. Se lee Lₙₜ,w de la curva de referencia desplazada a 500 Hz
% 7. Se calculan los coeficientes C_I y C_I,50-2500 a partir de la suma
%    energética de los niveles L_nT en los rangos de frecuencia definidos.
%
% REFERENCIAS:
%   ISO 717-2:2020 (Clasificación del aislamiento acústico a ruido de impacto)
%   Curva de referencia normativa
%
% NOTAS:
%   - Rango de análisis: 100 Hz a 3150 Hz (bandas de tercio de octava)
%   - Incremento de desplazamiento: 1 dB

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

% --- CÁLCULO DE COEFICIENTES DE ADAPTACIÓN ESPECTRAL (C_I) ---
% C_I = L'_nT,sum - L'_nT,w
% L'_nT,sum = 10 * log10( sum( 10^(L'_nT,i / 10) ) )
% Esta es la fórmula para Rw+C. Para L'nTw+CI, la norma es menos explícita
% y a menudo se usan otras definiciones. Sin embargo, la más consistente
% con la definición de suma energética es la siguiente:

% Coeficiente C_I (100 - 2500 Hz)
idx_start_ci = find(frecuencias >= 100, 1);
idx_end_ci = find(frecuencias <= 2500, 1, 'last');
if ~isempty(idx_start_ci) && ~isempty(idx_end_ci) && length(L_nT) >= idx_end_ci
    L_nT_sum_range = L_nT(idx_start_ci:idx_end_ci);
    L_nT_sum = 10 * log10(sum(10.^(L_nT_sum_range / 10)));
    C_I = L_nT_sum - L_nTw;
else
    C_I = NaN; % No hay datos en el rango 100-2500 Hz
end

% Coeficiente C_I,50-2500 (50 - 2500 Hz)
idx_start_ci_ext = find(frecuencias >= 50, 1);
if ~isempty(idx_start_ci_ext) && ~isempty(idx_end_ci) && length(L_nT) >= idx_end_ci
    L_nT_sum_range_ext = L_nT(idx_start_ci_ext:idx_end_ci);
    L_nT_sum_ext = 10 * log10(sum(10.^(L_nT_sum_range_ext / 10)));
    C_I_50_2500 = L_nT_sum_ext - L_nTw;
else
    C_I_50_2500 = NaN; % No hay datos en el rango extendido
end

% Información de depuración (opcional - deshabilitada por defecto)
% Para habilitar, cambiar verbose = true
verbose = false;
if verbose
    fprintf('\n  Método de ponderación ISO 717-2:\n');
    fprintf('  • Rango de análisis: 100 - 3150 Hz\n');
    fprintf('  • Desplazamiento óptimo: %d dB\n', best_shift);
    fprintf('  • Suma de desviaciones desfavorables: %.2f dB\n', best_unfav);
    fprintf('  • L´ₙₜ,w (valor a 500 Hz): %.1f dB\n', L_nTw);
    fprintf('  • C_I (100-2500 Hz): %.1f dB\n', C_I);
    fprintf('  • C_I,50-2500 (50-2500 Hz): %.1f dB\n', C_I_50_2500);
end

end
