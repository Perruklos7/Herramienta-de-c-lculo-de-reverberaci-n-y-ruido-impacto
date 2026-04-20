function [L_nT, L_nTw] = calculate_and_plot_impact(frecuencias, L_i, T, T0)
%% CÁLCULO Y GRÁFICO DEL NIVEL DE IMPACTO (ISO 717-2)
%
% SINTAXIS:
%   [L_nT, L_nTw] = calculate_and_plot_impact(frecuencias, L_i, T, T0)
%
% ENTRADA:
%   frecuencias : Vector fila de frecuencias en bandas de tercio de octava (Hz)
%   L_i         : Vector de niveles de presión acústica promediados (dB)
%   T           : Tiempo de reverberación calculado (segundos)
%   T0          : Tiempo de reverberación de referencia (típicamente 0.5 s)
%
% SALIDA:
%   L_nT        : Vector con niveles estandarizados de impacto (dB)
%   L_nTw       : Valor ponderado de impacto (dB)
%
% DESCRIPCIÓN:
%   Esta función actúa como un "wrapper" independiente. Calcula el L'nT y el 
%   L'nT,w utilizando las funciones existentes en el proyecto sin modificarlas.
%   Posteriormente, deduce la curva de referencia desplazada y genera una 
%   gráfica profesional de la evaluación acústica.

    % 1. Calcular L'nT utilizando la función existente intacta
    L_nT = calculate_standardized_impact_level(L_i, T, T0);
    
    % 2. Calcular L'nT,w utilizando la función existente intacta
    L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);
    
    % 3. Reconstruir la curva de referencia ISO 717-2 desplazada
    % Sabiendo que a 500 Hz la curva original vale 56 dB, el desplazamiento
    % total aplicado matemáticamente es la diferencia: (L_nTw - 56).
    curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, ...
                      630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
    curve_ref_level = [62, 62, 61, 60, 59, 58, 57, 56, ...
                       55, 54, 53, 52, 51, 50, 49, 48];
                       
    shift = L_nTw - 56; 
    final_curve = curve_ref_level + shift;
    
    % 4. Crear la figura y graficar
    figure('Name', 'Evaluación de Aislamiento a Ruido de Impacto ISO 717-2', ...
           'NumberTitle', 'off', 'Position', [150 150 800 500]);
    
    % Graficar L'nT (Espectro estandarizado del recinto)
    semilogx(frecuencias, L_nT, 'b-o', 'LineWidth', 2, 'MarkerSize', 6, ...
             'MarkerFaceColor', 'b', 'DisplayName', 'L''_{nT} (Estandarizado)');
    hold on;
    
    % Graficar la Curva de Referencia ISO desplazada
    semilogx(curve_ref_freq, final_curve, 'r-s', 'LineWidth', 2, 'MarkerSize', 6, ...
             'DisplayName', sprintf('Curva Ref. Desplazada (L''_{nT,w} = %d dB)', L_nTw));
    
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
    ylabel('Nivel de Presión Acústica de Impacto (dB)', 'FontWeight', 'bold', 'FontSize', 11);
    title('Aislamiento a Ruido de Impacto - Evaluación ISO 717-2', 'FontWeight', 'bold', 'FontSize', 13);
    legend('Location', 'southwest', 'FontSize', 10);
    
    hold off;
end