function [L_nT, L_nTw] = calculate_weighted_impact_level(frecuencias, L_medidos, T, T0)
%% CÁLCULO DEL NIVEL ESTANDARIZADO Y PONDERADO DE IMPACTO (L'nT y L'nT,w)
% Según UNE-EN-ISO 16283-2:2021 e ISO 717-2
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
%   L_nT        : Vector de niveles estandarizados de impacto (dB) por banda
%   L_nTw       : Nivel ponderado de impacto (dB) según ISO 717-2

if nargin < 4 || isempty(T0)
    T0 = 0.5;
end
if nargin < 3
    error('Debe proporcionar frecuencias, niveles medidos y tiempo de reverberación.');
end
if isempty(L_medidos) || isempty(frecuencias) || T <= 0 || T0 <= 0
    error('Entradas no válidas.');
end

% 1. Calcular el nivel estandarizado de impacto (UNE-EN-ISO 16283-2)
L_nT = L_medidos - 10*log10(T/T0);

% 2. Calcular el nivel ponderado L'nT,w (ISO 717-2)
curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
                  1250, 1600, 2000, 2500, 3150];
curve_ref_level = [62, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, ...
                   52, 51, 50, 49, 48];

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
best_unfav = -inf;
for shift = -40:1:40
    shifted_curve = curve_ref_level + shift;
    deviations = L_nT_analysis - shifted_curve;
    unfavorable = deviations(deviations > 0);
    sum_unfav = sum(unfavorable);
    if sum_unfav < 32 && sum_unfav > best_unfav
        best_unfav = sum_unfav;
        best_shift = shift;
    end
end
if best_unfav == -inf
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
final_curve = curve_ref_level + best_shift;
idx_500 = find(curve_ref_freq == 500);
if isempty(idx_500)
    error('No se encuentra la frecuencia de 500 Hz en la curva de referencia.');
end
L_nTw = final_curve(idx_500);

end
