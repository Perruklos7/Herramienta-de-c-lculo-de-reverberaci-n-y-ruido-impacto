function [L_nT, L_nTw] = calculate_standardized_impact_level_from_absorption(frecuencias, L_i, superficies, V, T0)
%% CÁLCULO Y GRÁFICO DEL L_nT USANDO ÁREA DE ABSORCIÓN EQUIVALENTE
%
% SINTAXIS:
%   [L_nT, L_nTw] = calculate_standardized_impact_level_from_absorption(frecuencias, L_i, superficies, V, T0)
%
% ENTRADA:
%   frecuencias : Vector (1xN) de frecuencias en bandas de tercio de octava (Hz)
%   L_i         : Vector (1xN) de niveles de presión acústica promediados (dB)
%   superficies : Matriz Mx2 con [Superficie_i, Coef_Absorcion_i]
%   V           : Volumen del recinto (m³)
%   T0          : Tiempo de reverberación de referencia (segundos), típicamente 0.5 s
%
% SALIDA:
%   L_nT  : Vector fila (1xN) con niveles estandarizados de impacto (dB)
%   L_nTw : Valor ponderado de impacto (dB)
%
% DESCRIPCIÓN:
%   Esta función calcula y grafica la evaluación de ruido de impacto. Estima
%   el tiempo de reverberación (T) a partir de las superficies de absorción
%   del recinto (método Sabine), calcula el L_nT, el L_nT,w y genera una
%   gráfica profesional comparando el espectro con la curva de referencia
%   de la norma ISO 717-2.

    % Validación de entradas
    if V <= 0 || T0 <= 0
        error('Error: El volumen (V) y el tiempo de referencia (T0) deben ser positivos.');
    end
    if size(superficies, 2) ~= 2
        error('Error: La matriz de superficies debe tener 2 columnas [Área, Coeficiente].');
    end
 
    % 1. Calcular el área de absorción equivalente total (A)
    A_equivalente = sum(superficies(:, 1) .* superficies(:, 2));
    
    % 2. Estimar T con Sabine y calcular L_nT usando la función ya existente
    T_estimado_por_absorcion = (0.162 * V) / A_equivalente;
    L_nT = calculate_standardized_impact_level(L_i, T_estimado_por_absorcion, T0);
 
    % 3. Calcular el valor ponderado L_nT,w
    L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);
 
    % 4. Reconstruir la curva de referencia ISO 717-2 desplazada
    curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, ...
                      630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
    curve_ref_level = [62, 62, 61, 60, 59, 58, 57, 56, ...
                       55, 54, 53, 52, 51, 50, 49, 48];
                       
    shift = L_nTw - 56; % El desplazamiento es la diferencia con el valor de ref. a 500Hz (56dB)
    final_curve = curve_ref_level + shift;
    
    % 5. Crear la figura y graficar
    figure('Name', 'Evaluación de Impacto (calculado desde Absorción)', ...
           'NumberTitle', 'off', 'Position', [150 150 800 500]);
    
    % Graficar L_nT (Espectro estandarizado del recinto)
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