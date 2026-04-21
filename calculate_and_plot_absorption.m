function [T_sabine, T_eyring, T_mill] = calculate_and_plot_absorption(superficies, V, m)
%% CÁLCULO Y GRÁFICO DE REVERBERACIÓN DESDE SUPERFICIES DE ABSORCIÓN
%
% SINTAXIS:
%   [T_sabine, T_eyring, T_mill] = calculate_and_plot_absorption(superficies, V, m)
%
% ENTRADA:
%   superficies : Matriz Mx2 con [Área_i, Coef_Absorcion_i]
%   V           : Volumen del recinto (m³)
%   m           : Coeficiente de atenuación del aire (m⁻¹)
%
% SALIDA:
%   T_sabine    : Tiempo de reverberación según Sabine (s)
%   T_eyring    : Tiempo de reverberación según Eyring (s)
%   T_mill      : Tiempo de reverberación según Millington (s)

    % 1. Calcular parámetros globales del recinto
    S_total = sum(superficies(:, 1));
    A_equivalente = sum(superficies(:, 1) .* superficies(:, 2));
    alpha_m = A_equivalente / S_total;
    
    % 2. Calcular los tres tiempos de reverberación usando las funciones base
    T_sabine = calculate_reverberation_sabine(alpha_m, S_total, m, V);
    T_eyring = calculate_reverberation_eyring(alpha_m, S_total, m, V);
    T_mill   = calculate_reverberation_millington(superficies, S_total, m, V);
    
    % 3. Crear figura y graficar comparativa
    figure('Name', 'Comparativa de Tiempos de Reverberación', ...
           'NumberTitle', 'off', 'Position', [200 200 600 450]);
           
    valores_T = [T_sabine, T_eyring, T_mill];
    nombres = {'Sabine', 'Eyring', 'Millington'};
    
    b = bar(valores_T, 'FaceColor', [0.2 0.6 0.8], 'EdgeColor', 'k', 'LineWidth', 1.2);
    
    % Configuración visual de la gráfica
    set(gca, 'XTickLabel', nombres, 'FontSize', 11);
    ylabel('Tiempo de Reverberación T_{60} (s)', 'FontWeight', 'bold', 'FontSize', 11);
    title(sprintf('Comparativa T_{60}\n(Volumen: %.1f m³ | Superficie: %.1f m² | \\alpha_m: %.2f)', ...
          V, S_total, alpha_m), 'FontSize', 12);
    grid on; grid minor;
    
    % Añadir etiquetas de texto con el valor encima de cada barra
    text(b.XEndPoints, b.YEndPoints, string(round(b.YData, 3)) + " s", ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', ...
         'FontWeight', 'bold', 'FontSize', 10);
         
    % Dar un margen superior al eje Y para que no se corten las etiquetas
    ylim([0, max(valores_T) * 1.2]);
    
end