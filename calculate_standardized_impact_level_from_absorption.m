function [L_n, L_nw] = calculate_standardized_impact_level_from_absorption(frecuencias, L_i, T, V)
%% CÁLCULO Y GRÁFICO DEL L_n USANDO ÁREA DE ABSORCIÓN EQUIVALENTE
%
% SINTAXIS:
%   [L_n, L_nw] = calculate_standardized_impact_level_from_absorption(frecuencias, L_i, T, V)
%
% ENTRADA:
%   frecuencias : Vector (1xN) de frecuencias en bandas de tercio de octava (Hz)
%   L_i         : Vector (1xN) de niveles de presión acústica promediados (dB)
%   T           : Tiempo de reverberación del recinto (segundos)
%   V           : Volumen del recinto (m³)
%
% SALIDA:
%   L_n   : Vector fila (1xN) con niveles normalizados de impacto (dB)
%   L_nw  : Valor ponderado de impacto (dB)
%
% DESCRIPCIÓN:
%   Esta función calcula y grafica la evaluación de ruido de impacto normalizado. 
%   Despeja el área de absorción equivalente (A) a partir del tiempo de 
%   reverberación (T) y el volumen (V) usando la fórmula de Sabine. Luego
%   calcula el L_n (con A0 = 10 m²), el L_n,w y genera una gráfica 
%   profesional comparando el espectro con la curva de referencia ISO 717-2.

    % Validación de entradas
    if V <= 0 || any(T <= 0)
        error('Error: El volumen (V) y el tiempo de reverberación (T) deben ser positivos.');
    end
 
    % 1. Despejar el área de absorción equivalente (A) de la fórmula de Sabine
    % Sabine: T = 0.162 * V / A  =>  A = 0.162 * V / T
    A = (0.162 * V) ./ T;
 
    % 2. Calcular el Nivel de Impacto Normalizado (L_n)
    A0 = 10; % Área de absorción de referencia en m²
    L_n = L_i + 10 * log10(A / A0);
 
    % 3. Calcular el valor ponderado L_n,w (usando la función de ponderación ISO 717-2)
    L_nw = calculate_weighted_impact_level(frecuencias, L_n);
 
    % 4. Reconstruir la curva de referencia ISO 717-2 desplazada
    curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, ...
                      630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
    curve_ref_level = [62, 62, 62, 62, 62, 62, 61, 60, ...
                       59, 58, 57, 54, 51, 48, 45, 42];
                       
    shift = L_nw - 60; % El desplazamiento es la diferencia con el valor de ref. a 500Hz (60dB)
    final_curve = curve_ref_level + shift;
    
    % 5. Crear la figura y graficar
    figure('Name', 'Evaluación de Impacto Normalizado L_n (ISO 717-2)', ...
           'NumberTitle', 'off', 'Position', [150 150 800 500]);
    
    % Graficar L_n (Espectro normalizado del recinto)
    semilogx(frecuencias, L_n, 'b-o', 'LineWidth', 2, 'MarkerSize', 6, ...
             'MarkerFaceColor', 'b', 'DisplayName', 'L_n (Normalizado)');
    hold on;
    
    % Graficar la Curva de Referencia ISO desplazada
    semilogx(curve_ref_freq, final_curve, 'r-s', 'LineWidth', 2, 'MarkerSize', 6, ...
             'DisplayName', sprintf('Curva Ref. Desplazada (L_{n,w} = %d dB)', L_nw));
    
    % Resaltar la lectura a 500 Hz
    idx_500 = find(curve_ref_freq == 500, 1);
    plot(500, final_curve(idx_500), 'k*', 'MarkerSize', 12, 'LineWidth', 1.5, ...
         'DisplayName', 'Lectura a 500 Hz');
    
    % Configuración visual
    grid on; grid minor;
    set(gca, 'XScale', 'log');
    xticks([100 125 160 200 250 315 400 500 630 800 1000 1250 1600 2000 2500 3150]);
    xticklabels({'100','125','160','200','250','315','400','500','630','800','1k','1.25k','1.6k','2k','2.5k','3.15k'});
    xlim([80, 4000]);
    
    xlabel('Frecuencia (Hz)', 'FontWeight', 'bold', 'FontSize', 11);
    ylabel('Nivel de Presión Acústica de Impacto Normalizado (dB)', 'FontWeight', 'bold', 'FontSize', 11);
    title('Aislamiento a Ruido de Impacto Normalizado - Evaluación ISO 717-2', 'FontWeight', 'bold', 'FontSize', 13);
    legend('Location', 'southwest', 'FontSize', 10);
    
    hold off;
 
end
