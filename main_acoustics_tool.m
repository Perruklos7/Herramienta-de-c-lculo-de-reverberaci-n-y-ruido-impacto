%% HERRAMIENTA DE CÁLCULO DE REVERBERACIÓN Y RUIDO DE IMPACTO
% =========================================================================
% Proyecto: Cálculo de Reverberación y Nivel de Presión Acústica de Impactos
% Normativas: ISO 3382, ISO 16283, ISO 717
% Fecha: 2026
% =========================================================================
%
% DESCRIPCIÓN:
% Esta herramienta permite calcular:
% 1. Tiempo de reverberación (T60) usando métodos de Sabine, Eyring, Millington
% 2. Nivel estandarizado de presión acústica de impactos ponderado (L'nT,w)
%
% BLOQUES PRINCIPALES:
% - BLOQUE 1: Cálculo de Time de Reverberación
% - BLOQUE 2: Cálculo de Nivel de Impacto Acústico Ponderado

clear all; close all; clc;

%% PARÁMETROS DE ENTRADA - BLOQUE 1: REVERBERACIÓN
% =========================================================================
fprintf('\n');
fprintf('═════════════════════════════════════════════════════════════════\n');
fprintf('  HERRAMIENTA DE ACÚSTICA - REVERBERACIÓN Y RUIDO DE IMPACTO\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');

% Parámetros del recinto
V = 100;  % Volumen en m³ (ejemplo: aula de 5m x 4m x 5m = 100 m³)
S = 130;  % Superficie total en m² (ejemplo)
m = 0.00001;  % Coeficiente de atenuación del aire en m⁻¹ (típico: 0.00001)

% Coeficiente de absorción medio (ejemplo simplificado)
alpha_m = 0.15;  % Valor medio entre 0.05 y 0.8

% Absorción total en sabins (si se conoce de forma granular)
% Ejemplo: paredes de yeso (S_pared=80, alpha=0.05), techo acústico (S_techo=20, alpha=0.8)
A_tot_sabins = 15;  % Sabins

% Para método de Millington - necesitamos superficies individuales
% Estructura de datos: [Superficie_i, Absorcion_i]
superficies = [
    80, 0.05;    % Paredes lisas (ejemplo: 80 m² de yeso)
    20, 0.80;    % Techo acústico (ejemplo: 20 m² de material absorbente)
    30, 0.30     % Piso + mobiliario (ejemplo: 30 m²)
];

fprintf('BLOQUE 1: CÁLCULO DEL TIEMPO DE REVERBERACIÓN\n');
fprintf('──────────────────────────────────────────────────\n\n');
fprintf('Parámetros del recinto:\n');
fprintf('  • Volumen (V): %.2f m³\n', V);
fprintf('  • Superficie Total (S): %.2f m²\n', S);
fprintf('  • Coef. Absorción Media (α_m): %.3f\n', alpha_m);
fprintf('  • Coef. Atenuación del Aire (m): %.6f m⁻¹\n\n', m);

%% CÁLCULOS DE REVERBERACIÓN
% =========================================================================

% Método 1: Sabine
T_sabine = calculate_reverberation_sabine(alpha_m, S, m, V);

% Método 2: Eyring
T_eyring = calculate_reverberation_eyring(alpha_m, S, m, V);

% Método 3: Millington
T_millington = calculate_reverberation_millington(superficies, S, m, V);

% Mostrar resultados
fprintf('Resultados de Reverberación:\n\n');
fprintf('  │ Método              │  T₆₀ (s)  │\n');
fprintf('  ├─────────────────────┼───────────┤\n');
fprintf('  │ Sabine              │  %.4f    │\n', T_sabine);
fprintf('  │ Eyring              │  %.4f    │\n', T_eyring);
fprintf('  │ Millington          │  %.4f    │\n', T_millington);
fprintf('  └─────────────────────┴───────────┘\n\n');

% Seleccionar método (por defecto usamos Sabine)
T_selected = T_sabine;
fprintf('✓ Método seleccionado: SABINE\n');
fprintf('✓ T₆₀ utilizado para siguientes cálculos: %.4f s\n\n', T_selected);

%% PARÁMETROS DE ENTRADA - BLOQUE 2: RUIDO DE IMPACTO
% =========================================================================

fprintf('BLOQUE 2: CÁLCULO DEL NIVEL DE IMPACTO PONDERADO (L´ₙₜ,w)\n');
fprintf('────────────────────────────────────────────────────────────\n\n');

% Datos de mediciones de impacto por banda de frecuencia (en Hz)
% Frecuencias en bandas de tercio de octava (100-3150 Hz)
frecuencias = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
               1250, 1600, 2000, 2500, 3150];

% Niveles de presión acústica medidos (simulación de 3 posiciones de micrófono)
% En la práctica, éstos provienen de mediciones
L_measurements = [
    50, 51, 49, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40;  % Posición 1
    51, 50, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39;  % Posición 2
    49, 52, 50, 49, 51, 50, 48, 46, 45, 44, 43, 42, 41, 40, 39, 38;  % Posición 3
];

fprintf('Frecuencias de análisis (bandas de tercio de octava):\n');
fprintf('%s\n', sprintf('%d ', frecuencias));

fprintf('\n\nMediciones de nivel de presión acústica de impactos (dB ref 20 μPa):\n');
fprintf('Posición 1: %s\n', sprintf('%d ', L_measurements(1,:)));
fprintf('Posición 2: %s\n', sprintf('%d ', L_measurements(2,:)));
fprintf('Posición 3: %s\n\n', sprintf('%d ', L_measurements(3,:)));

% Parámetro de referencia
T0 = 0.5;  % Tiempo de reverberación de referencia (viviendas)
A_ref = 10;  % Área de absorción de referencia en m² (viviendas)

%% CÁLCULOS DE IMPACTO
% =========================================================================

% 1. Calcular nivel promediado en el recinto receptor
L_i = calculate_impact_level(L_measurements);
fprintf('Nivel promediado en receptor (L_i): %s dB\n', sprintf('%.2f ', L_i));

% 2. Calcular nivel estandarizado de impacto
L_nT = calculate_standardized_impact_level(L_i, T_selected, T0);
fprintf('\nNivel estandarizado de impacto (L´ₙₜ): %s dB\n', sprintf('%.2f ', L_nT));

% 3. Calcular nivel ponderado ISO 717-2
L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);

fprintf('\n\n');
fprintf('═════════════════════════════════════════════════════════════════\n');
fprintf('RESULTADO FINAL\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');
fprintf('  ★ L´ₙₜ,w (Nivel ponderado de impacto):  %.1f dB(A)\n\n', L_nTw);
fprintf('═════════════════════════════════════════════════════════════════\n');

%% GRÁFICOS
% =========================================================================

% Gráfico 1: Espectro de reverberación
figure('Name', 'Análisis de Reverberación', 'NumberTitle', 'off');
plot(1:3, [T_sabine, T_eyring, T_millington], 'o-', 'LineWidth', 2, 'MarkerSize', 8);
set(gca, 'XTick', 1:3, 'XTickLabel', {'Sabine', 'Eyring', 'Millington'});
ylabel('Tiempo de Reverberación T₆₀ (s)', 'FontSize', 11);
grid on;
title('Comparación de Métodos de Reverberación', 'FontSize', 12, 'FontWeight', 'bold');

% Gráfico 2: Espectro de impacto
figure('Name', 'Espectro de Impacto Acústico', 'NumberTitle', 'off');
semilogx(frecuencias, L_nT, 'b-o', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
semilogx(frecuencias, L_nT, 'r--', 'LineWidth', 1.5);
xlabel('Frecuencia (Hz)', 'FontSize', 11);
ylabel('Nivel L´ₙₜ (dB)', 'FontSize', 11);
grid on;
title(['Espectro de Impacto (L´ₙₜ,w = ', num2str(L_nTw, '%.1f'), ' dB)'], ...
      'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'XScale', 'log');

fprintf('\n✓ Gráficos generados.\n');
fprintf('✓ Análisis completado exitosamente.\n\n');
