%% SCRIPT DE EJEMPLO - ANÁLISIS COMPLETO DE ACÚSTICA
% =========================================================================
% Este script muestra un ejemplo práctico completo del cálculo de:
% 1. Tiempo de reverberación (Sabine, Eyring, Millington)
% 2. Aislamiento a ruido de impacto (L'nT,w)
% =========================================================================

clear all; close all; clc;

fprintf('╔═════════════════════════════════════════════════════════════════╗\n');
fprintf('║   EJEMPLO PRÁCTICO: ANÁLISIS ACÚSTICO DE UN RECINTO           ║\n');
fprintf('║   (Aula típica de Universidad)                                 ║\n');
fprintf('╚═════════════════════════════════════════════════════════════════╝\n\n');

%% ESCENARIO: Aula Universitaria
% =========================================================================
fprintf('ESCENARIO: Aula Universitaria 5m x 4m x 5m\n');
fprintf('────────────────────────────────────────────────\n\n');

% Dimensiones
L = 5;      % Largo en m
A = 4;      % Ancho en m
H = 5;      % Alto en m
V = L * A * H;  % Volumen

% Superficies (cálculo simplificado)
S_paredes_laterales = 2 * L * H;  % Dos paredes: 2 * 5 * 5 = 50 m²
S_paredes_frontales = 2 * A * H;  % Dos paredes: 2 * 4 * 5 = 40 m²
S_suelo = L * A;                   % Piso: 5 * 4 = 20 m²
S_techo = L * A;                   % Techo: 5 * 4 = 20 m²
S_total = S_paredes_laterales + S_paredes_frontales + S_suelo + S_techo;

fprintf('Dimensiones del aula:\n');
fprintf('  Largo (L): %.1f m\n', L);
fprintf('  Ancho (A): %.1f m\n', A);
fprintf('  Alto (H): %.1f m\n', H);
fprintf('  Volumen (V): %.1f m³\n', V);
fprintf('  Superficie total (S): %.1f m²\n\n', S_total);

% Materiales y absorción (ejemplo realista)
% Composición del aula
materiales_composicion = [
    % [Superficie (m²), Coef. Absorción]
    S_paredes_laterales,  0.05;   % Paredes lisas (yeso, pintura)
    S_paredes_frontales,  0.05;   % Pizarra + paredes
    S_suelo,              0.10;   % Suelo de baldosa con algunas alfombras
    S_techo,              0.70    % Falso techo acústico (típico en aulas)
];

fprintf('Composición de materiales y absorción:\n');
fprintf('  │ Superficie             │  Área (m²) │  α      │\n');
fprintf('  ├────────────────────────┼────────────┼─────────┤\n');
fprintf('  │ Paredes laterales      │  %6.1f   │  %.3f  │\n', ...
    materiales_composicion(1,1), materiales_composicion(1,2));
fprintf('  │ Paredes frontales      │  %6.1f   │  %.3f  │\n', ...
    materiales_composicion(2,1), materiales_composicion(2,2));
fprintf('  │ Suelo                  │  %6.1f   │  %.3f  │\n', ...
    materiales_composicion(3,1), materiales_composicion(3,2));
fprintf('  │ Techo (acústico)       │  %6.1f   │  %.3f  │\n', ...
    materiales_composicion(4,1), materiales_composicion(4,2));
fprintf('  └────────────────────────┴────────────┴─────────┘\n\n');

% Calcular coeficiente de absorción medio
alpha_m = sum(materiales_composicion(:,1) .* materiales_composicion(:,2)) / S_total;
fprintf('Coeficiente de absorción medio (α_m): %.3f\n\n', alpha_m);

% Parámetro de atenuación
m = 0.000007;  % Típico para aire a 20°C, humedad relativa ~50%
fprintf('Coeficiente de atenuación en aire (m): %.6f m⁻¹\n', m);
fprintf('  (típico para aire a 20°C y 50%% humedad relativa)\n\n');

%% BLOQUE 1: CÁLCULO DE REVERBERACIÓN
% =========================================================================
fprintf('\n╔═════════════════════════════════════════════════════════════════╗\n');
fprintf('║ BLOQUE 1: CÁLCULO DEL TIEMPO DE REVERBERACIÓN                 ║\n');
fprintf('╚═════════════════════════════════════════════════════════════════╝\n\n');

% Método 1: Sabine
T_sabine = calculate_reverberation_sabine(alpha_m, S_total, m, V);
fprintf('Método de Sabine:\n');
fprintf('  Fórmula: T₆₀ = 0.162 × V / (α_m × S + 4m × V)\n');
fprintf('  T₆₀ (Sabine) = %.4f s\n\n', T_sabine);

% Método 2: Eyring
T_eyring = calculate_reverberation_eyring(alpha_m, S_total, m, V);
fprintf('Método de Eyring:\n');
fprintf('  Fórmula: T₆₀ = 0.162 × V / (-S × ln(1 - α_m) + 4m × V)\n');
fprintf('  T₆₀ (Eyring) = %.4f s\n\n', T_eyring);

% Método 3: Millington
T_millington = calculate_reverberation_millington(materiales_composicion, S_total, m, V);
fprintf('Método de Millington:\n');
fprintf('  Fórmula: T₆₀ = 0.162 × V / (Σ[-Sᵢ × ln(1 - αᵢ)] + 4m × V)\n');
fprintf('  T₆₀ (Millington) = %.4f s\n\n', T_millington);

% Usar Eyring como método estándar (es más preciso para α_m moderados)
T_selected = T_eyring;
fprintf('★ Método seleccionado para siguiente análisis: EYRING (más preciso)\n');
fprintf('★ T₆₀ = %.4f s\n\n', T_selected);

%% BLOQUE 2: AISLAMIENTO A RUIDO DE IMPACTO
% =========================================================================
fprintf('\n╔═════════════════════════════════════════════════════════════════╗\n');
fprintf('║ BLOQUE 2: AISLAMIENTO A RUIDO DE IMPACTO (L´ₙₜ,w)             ║\n');
fprintf('╚═════════════════════════════════════════════════════════════════╝\n\n');

% Simular mediciones de impacto (máquina de impactos normalizada)
% Posiciones de micrófono en el recinto receptor
frecuencias = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
               1250, 1600, 2000, 2500, 3150];

% Datos simulados: Mediciones en 4 posiciones de micrófono
% (En la práctica provienen de la máquina de impactos normalizada ISO 16283)
L_mediciones = [
    65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50;  % Pos 1
    66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51;  % Pos 2
    64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49;  % Pos 3
    65, 64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50;  % Pos 4
];

fprintf('Mediciones de impacto (máquina de impactos normalizada):\n');
fprintf('Frecuencias (Hz): %s\n\n', sprintf('%d ', frecuencias));

fprintf('Posiciones de micrófono (Nivel en dB ref 20 μPa):\n');
for i = 1:size(L_mediciones, 1)
    fprintf('  Pos %d: %s\n', i, sprintf('%2d ', L_mediciones(i,:)));
end
fprintf('\n');

% Paso 1: Calcular promedio energético
L_i = calculate_impact_level(L_mediciones);
fprintf('Nivel promediado en recinto receptor (L_i):\n');
fprintf('  L_i = %s dB\n\n', sprintf('%.1f ', L_i));

% Parámetro de referencia
T0 = 0.5;  % Referencia para viviendas (ISO 16283)
fprintf('Tiempo de reverberación de referencia (T₀): %.1f s\n', T0);
fprintf('  (valor típico para viviendas y oficinas ISO 16283-2)\n\n');

% Paso 2: Calcular nivel estandarizado
L_nT = calculate_standardized_impact_level(L_i, T_selected, T0);
fprintf('Nivel estandarizado de impacto (L´ₙₜ):\n');
fprintf('  L´ₙₜ = %s dB\n\n', sprintf('%.1f ', L_nT));

fprintf('Corrección por reverberación:\n');
corr = 10 * log10(T_selected / T0);
fprintf('  Δ = 10 × log₁₀(T/T₀) = %.2f dB\n', corr);

%% BLOQUE 3: PONDERACIÓN ISO 717-2
% =========================================================================
fprintf('\n╔═════════════════════════════════════════════════════════════════╗\n');
fprintf('║ BLOQUE 3: PONDERACIÓN ISO 717-2 (L´ₙₜ,w)                      ║\n');
fprintf('╚═════════════════════════════════════════════════════════════════╝\n\n');

% Calcular L'nT,w mediante método de comparación con curva de referencia
L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);

fprintf('\n');
fprintf('══════════════════════════════════════════════════════════════════\n');
fprintf('RESULTADO FINAL\n');
fprintf('══════════════════════════════════════════════════════════════════\n\n');
fprintf('  ┌──────────────────────────────────────────────┐\n');
fprintf('  │ L´ₙₜ,w (Nivel ponderado de impacto):  %3.0f dB │\n', L_nTw);
fprintf('  └──────────────────────────────────────────────┘\n\n');
fprintf('══════════════════════════════════════════════════════════════════\n\n');

%% GRÁFICOS
% =========================================================================
% Gráfico 1: Comparación de métodos de reverberación
figure('Name', 'Análisis de Reverberación', 'NumberTitle', 'off', 'Position', [100 100 600 450]);
bar([T_sabine, T_eyring, T_millington], 'FaceColor', [0.2, 0.6, 0.9], 'EdgeColor', 'k', 'LineWidth', 1.5);
set(gca, 'XTick', 1:3, 'XTickLabel', {'Sabine', 'Eyring', 'Millington'}, 'FontSize', 11);
ylabel('Tiempo de Reverberación T₆₀ (s)', 'FontSize', 11, 'FontWeight', 'bold');
title('Comparación de Métodos de Reverberación', 'FontSize', 12, 'FontWeight', 'bold');
grid on; grid minor;
ylim([0, max([T_sabine, T_eyring, T_millington]) * 1.2]);

% Gráfico 2: Espectro de impacto
figure('Name', 'Espectro de Impacto', 'NumberTitle', 'off', 'Position', [750 100 600 450]);
semilogx(frecuencias, L_nT, 'b-o', 'LineWidth', 2.5, 'MarkerSize', 7);
hold on;
semilogx(frecuencias, L_nT, 'b--', 'LineWidth', 1.5, 'Alpha', 0.6);
xlabel('Frecuencia (Hz)', 'FontSize', 11, 'FontWeight', 'bold');
ylabel('Nivel L´ₙₜ (dB)', 'FontSize', 11, 'FontWeight', 'bold');
title(['Espectro de Impacto Acústico - L´ₙₜ,w = ' num2str(L_nTw, '%.0f') ' dB'], ...
      'FontSize', 12, 'FontWeight', 'bold');
grid on; grid minor;
set(gca, 'XScale', 'log');
xlim([80, 4000]);

% Gráfico 3: Resumen de resultados
figure('Name', 'Resumen de Resultados', 'NumberTitle', 'off', 'Position', [100 600 600 300]);
% Datos para tabla
datos = {
    'Parámetro', 'Valor', 'Unidad'
    '─────────────────────────────', '──────────', '──────'
    'Volumen del recinto', sprintf('%.1f', V), 'm³'
    'Superficie total', sprintf('%.1f', S_total), 'm²'
    'Absorción media', sprintf('%.3f', alpha_m), '-'
    'T₆₀ (Sabine)', sprintf('%.4f', T_sabine), 's'
    'T₆₀ (Eyring)', sprintf('%.4f', T_eyring), 's'
    'T₆₀ (Millington)', sprintf('%.4f', T_millington), 's'
    'L´ₙₜ,w (Resultado)', sprintf('%.1f', L_nTw), 'dB'
};

% Crear tabla (usar text para MATLAB estándar)
axis off;
y_pos = 0.95;
for i = 1:size(datos, 1)
    text(0.05, y_pos, datos{i,1}, 'FontSize', 10, 'FontFamily', 'monospace', 'FontWeight', 'bold');
    text(0.50, y_pos, datos{i,2}, 'FontSize', 10, 'FontFamily', 'monospace', 'HorizontalAlignment', 'right');
    text(0.85, y_pos, datos{i,3}, 'FontSize', 10, 'FontFamily', 'monospace', 'HorizontalAlignment', 'right');
    y_pos = y_pos - 0.10;
end

fprintf('\n✓ Análisis completado.\n');
fprintf('✓ 3 gráficos generados.\n\n');
