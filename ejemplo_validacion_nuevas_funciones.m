%% SCRIPT DE VALIDACIÓN DE NUEVAS FUNCIONES GRÁFICAS E INTEGRADAS
% =========================================================================
% Este script pone a prueba las dos funciones wrapper creadas recientemente:
% 1. calculate_and_plot_absorption
% 2. calculate_standardized_impact_level_from_absorption
% =========================================================================

clear all; close all; clc;

disp('==============================================================');
disp('   VALIDACIÓN DE NUEVAS FUNCIONES GRÁFICAS E INTEGRADAS');
disp('==============================================================');

% --- DATOS DE ENTRADA COMUNES ---
% 1. Superficies del recinto [Área (m²), Coef. Absorción (\alpha)]
superficies = [
    50,  0.05;   % Paredes laterales lisas
    40,  0.05;   % Paredes frontales lisas
    20,  0.10;   % Suelo duro
    20,  0.70    % Falso techo acústico altamente absorbente
];
V = 100;         % Volumen del recinto en m³
m = 0.000007;    % Atenuación del aire
T0 = 0.5;        % Tiempo de reverberación de referencia (viviendas/oficinas)

% 2. Datos de ruido de impacto promediados (L_i)
frecuencias = [100, 125, 160, 200, 250, 315, 400, 500, ...
               630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
L_i = [65.5, 64.3, 63.8, 62.3, 61.3, 60.3, 59.3, 58.3, ...
       57.3, 56.3, 55.3, 54.3, 53.3, 52.3, 51.3, 50.3];

% =========================================================================
% PRUEBA 1: Función de Absorción y Reverberación
% =========================================================================
disp(' ');
disp('Prueba 1: Ejecutando "calculate_and_plot_absorption"...');
[T_sabine, T_eyring, T_mill] = calculate_and_plot_absorption(superficies, V, m);

fprintf('Resultados obtenidos:\n');
fprintf('  - T60 (Sabine):     %.3f s\n', T_sabine);
fprintf('  - T60 (Eyring):     %.3f s\n', T_eyring);
fprintf('  - T60 (Millington): %.3f s\n', T_mill);
disp('  -> ¡Figura de Absorción generada con éxito!');

% =========================================================================
% PRUEBA 2: Función de Impacto a partir de Absorción
% =========================================================================
disp(' ');
disp('Prueba 2: Ejecutando "calculate_standardized_impact_level_from_absorption"...');
[L_nT, L_nTw] = calculate_standardized_impact_level_from_absorption(frecuencias, L_i, superficies, V, T0);

fprintf('Resultados obtenidos:\n');
fprintf('  - Nivel ponderado de impacto (L''nT,w): %d dB\n', L_nTw);
disp('  -> ¡Figura de Evaluación de Impacto generada con éxito!');

disp(' ');
disp('==============================================================');
disp('   VALIDACIÓN COMPLETADA - REVISE LAS 2 FIGURAS CREADAS');
disp('==============================================================');