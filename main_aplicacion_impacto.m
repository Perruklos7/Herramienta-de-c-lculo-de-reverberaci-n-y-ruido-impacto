%% APLICACIÓN PRINCIPAL - ANÁLISIS DE AISLAMIENTO A RUIDO DE IMPACTO
% =========================================================================
% Este script es una aplicación interactiva para el análisis completo de
% aislamiento a ruido de impacto según las normativas ISO 16283-2 y 717-2.
%
% El flujo de trabajo es el siguiente:
%   1. Pide al usuario las dimensiones del recinto.
%   2. El usuario debe introducir los datos de materiales y mediciones.
%   3. Pide al usuario que seleccione el método de cálculo de T60.
%   4. Realiza todos los cálculos (corrección de ruido, T60, L'_nT, L'_nT,w).
%   5. Genera una única figura con la gráfica de evaluación y una tabla
%      con los resultados por frecuencia, como en la norma.
% =========================================================================

clear all; close all; clc;

fprintf('╔═════════════════════════════════════════════════════════════════╗\n');
fprintf('║   APLICACIÓN DE ANÁLISIS DE AISLAMIENTO A RUIDO DE IMPACTO      ║\n');
fprintf('║               ISO 16283-2 & ISO 717-2                         ║\n');
fprintf('╚═════════════════════════════════════════════════════════════════╝\n\n');

%% 1. DATOS DE ENTRADA
% =========================================================================
fprintf('1. CONFIGURACIÓN DE DATOS DE ENTRADA...\n\n');

% --- Geometría del Recinto Receptor (INTERACTIVO) ---
prompt = {'Largo del recinto (m):', 'Ancho del recinto (m):', 'Alto del recinto (m):'};
dlgtitle = 'Dimensiones del Recinto Receptor';
dims = [1 40];
definput = {'5.0', '4.0', '2.8'};
answer = inputdlg(prompt, dlgtitle, dims, definput);

if isempty(answer)
    fprintf('Operación cancelada por el usuario.\n');
    return;
end

L = str2double(answer{1});
A = str2double(answer{2});
H = str2double(answer{3});

% Matrices por defecto
sup_default = [
    2 * L * H, 0.04;  % Paredes laterales
    2 * A * H, 0.04;  % Paredes frontales
    L * A,     0.08;  % Suelo
    L * A,     0.65   % Techo
];

% --- Materiales y Absorción (INTERACTIVO GRÁFICO) ---
prompt_mat = {'Modifique la matriz de superficies [Área(m²), Coef_Absorción]:'};
dlgtitle_mat = 'Materiales y Absorción';
dims_mat = [6 60]; 

% Formatear para que se vea como una matriz real y alineada en la caja de texto
def_mat_str = strtrim(sprintf('%6.2f   %6.2f\n', sup_default'));
definput_mat = {def_mat_str};

answer_mat = inputdlg(prompt_mat, dlgtitle_mat, dims_mat, definput_mat);

if isempty(answer_mat) || isempty(strtrim(answer_mat{1}))
    superficies = sup_default;
    fprintf(' -> Usando matriz de superficies por defecto.\n\n');
else
    superficies = str2num(answer_mat{1});
    fprintf(' -> Matriz de superficies cargada desde interfaz.\n\n');
end

% Frecuencias de análisis (tercios de octava)
frecuencias = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150];

% Mediciones por defecto (MÍNIMOS SEGÚN ISO 16283-2)
% Impacto: Mín. 4 posiciones de máquina (con 1 barrido de micrófono por pos.) = 4 vectores
L_imp_default = [
    66.1, 65.8, 64.2, 63.1, 62.5, 61.9, 60.4, 59.1, 58.2, 57.0, 56.1, 54.5, 52.1, 50.3, 48.1, 45.5;
    65.9, 66.2, 64.5, 63.3, 62.8, 62.0, 60.9, 59.5, 58.5, 57.3, 56.3, 54.8, 52.5, 50.8, 48.5, 46.0;
    66.5, 66.0, 64.8, 63.5, 62.9, 62.3, 61.0, 59.8, 58.9, 57.6, 56.5, 55.0, 52.9, 51.0, 48.9, 46.2;
    65.2, 65.0, 63.8, 62.6, 62.0, 61.4, 60.1, 58.9, 57.9, 56.5, 55.6, 53.8, 51.6, 49.8, 47.6, 45.0;
];
% Ruido de fondo: Mín. 1 posición (si el ruido es estable)
L_fondo_default = [
    45.1, 44.8, 43.2, 41.1, 39.5, 38.9, 37.4, 36.1, 35.2, 34.0, 33.1, 31.5, 29.1, 27.3, 25.1, 22.5;
];

% --- Mediciones Acústicas (INTERACTIVO GRÁFICO) ---
prompt_med = {
    'Niveles impacto (Mín ISO: 4 vectores mic. móvil o 8 con fijo):',
    'Ruido de fondo (Mín ISO: 1 vector si es estable):'
};
dlgtitle_med = 'Mediciones Acústicas (dB)';
dims_med = [6 130; 3 130]; % Ajustadas en altura al número de vectores mínimos

% Formatear como cuadrícula alineada para la interfaz
fmt_16 = [repmat('%5.1f  ', 1, 16), '\n'];
def_imp_str = strtrim(sprintf(fmt_16, L_imp_default'));
def_fondo_str = strtrim(sprintf(fmt_16, L_fondo_default'));
definput_med = {def_imp_str, def_fondo_str};

answer_med = inputdlg(prompt_med, dlgtitle_med, dims_med, definput_med);

if isempty(answer_med) || isempty(strtrim(answer_med{1}))
    L_mediciones_impacto = L_imp_default;
    fprintf(' -> Usando mediciones de impacto por defecto.\n');
else
    L_mediciones_impacto = str2num(answer_med{1});
    fprintf(' -> Mediciones de impacto cargadas desde interfaz.\n');
end

if isempty(answer_med) || isempty(strtrim(answer_med{2}))
    L_mediciones_fondo = L_fondo_default;
    fprintf(' -> Usando ruido de fondo por defecto.\n\n');
else
    L_mediciones_fondo = str2num(answer_med{2});
    fprintf(' -> Mediciones de ruido de fondo cargadas desde interfaz.\n\n');
end

% Otras Variables
T0 = 0.5;       % Tiempo de reverberación de referencia (s)
m = 0.000007;   % Coeficiente de atenuación del aire (m⁻¹)

fprintf('   -> Datos cargados.\n\n');

%% 2. PROCESAMIENTO DE MEDICIONES
% =========================================================================
fprintf('2. PROCESANDO Y CORRIGIENDO MEDICIONES...\n');

% Promedio energético de las mediciones de impacto
L_i = calculate_impact_level(L_mediciones_impacto);

% Promedio energético de las mediciones de ruido de fondo
L_b = calculate_impact_level(L_mediciones_fondo);

% Corrección de la señal de impacto por el ruido de fondo
L_i_corr = correct_for_background_noise(L_i, L_b);

% Comprobar si alguna medición fue invalidada (diferencia < 3 dB)
if any(isnan(L_i_corr))
    warning('Algunas mediciones no son válidas por estar demasiado cerca del ruido de fondo. Los resultados pueden no ser precisos.');
    % Para este script, se continúa, pero en un informe real se debería detener.
end

fprintf('   -> Corrección por ruido de fondo aplicada.\n\n');

%% 3. CÁLCULO DEL TIEMPO DE REVERBERACIÓN (T60)
% =========================================================================
fprintf('3. CALCULANDO TIEMPO DE REVERBERACIÓN (T60)...\n');

% Calcular parámetros geométricos
V = L * A * H;
S_total = sum(superficies(:, 1));
A_equivalente = sum(superficies(:, 1) .* superficies(:, 2));
alpha_m = A_equivalente / S_total;

% Calcular todos los tiempos de reverberación y generar la 1ª gráfica (Comparativa)
[T_sabine, T_eyring, T_mill] = calculate_and_plot_absorption(superficies, V, m);

% Selección interactiva del método de cálculo de T60
opcion = menu('Seleccione el método para calcular el Tiempo de Reverberación (T60)', 'Sabine', 'Eyring', 'Millington');

fprintf('   -> T60 (Sabine - Referencia) = %.3f s.\n', T_sabine);

switch opcion
    case 0
        fprintf('Operación cancelada por el usuario.\n');
        return;
    case 1
        T_reverb = T_sabine;
        metodo_T60 = 'Sabine';
    case 2
        T_reverb = T_eyring;
        metodo_T60 = 'Eyring';
    case 3
        T_reverb = T_mill;
        metodo_T60 = 'Millington';
end

if opcion ~= 1
    fprintf('   -> T60 (%s - Seleccionado) = %.3f s.\n', metodo_T60, T_reverb);
end
fprintf('\n');

%% 4. CÁLCULO DE ÍNDICES DE AISLAMIENTO
% =========================================================================
fprintf('4. CALCULANDO ÍNDICES DE AISLAMIENTO...\n');

% Calcular Nivel Estandarizado de Impacto (L'_nT)
L_nT = calculate_standardized_impact_level(L_i_corr, T_reverb, T0);

% Calcular Nivel Ponderado (L'_nT,w) y coeficientes de adaptación
[L_nTw, C_I, C_I_50_2500] = calculate_weighted_impact_level(frecuencias, L_nT);

fprintf('   -> Cálculo de L''_nT,w y coeficientes completado.\n\n');

%% 5. PRESENTACIÓN DE RESULTADOS
% =========================================================================
fprintf('5. GENERANDO RESULTADOS FINALES...\n\n');

% --- (Opcional) Tabla de Resultados en Consola ---
% --- Tabla de Resultados en Consola ---
fprintf('----------------- TABLA DE RESULTADOS -----------------\n');
fprintf('ÍNDICE GLOBAL DE AISLAMIENTO:\n');
fprintf('  L''_nT,w = %d dB\n', round(L_nTw));
fprintf('COEFICIENTES DE ADAPTACIÓN:\n');
fprintf('  C_I (100-2500 Hz) = %.1f dB\n', C_I);
if ~isnan(C_I_50_2500)
    fprintf('  C_I,50-2500 (50-2500 Hz) = %.1f dB\n', C_I_50_2500);
else
    fprintf('  C_I,50-2500 (50-2500 Hz) = N/A (datos no disponibles)\n');
end
fprintf('\nRESULTADO COMPLETO: L''_nT,w (C_I) = %d (%.0f) dB\n', round(L_nTw), round(C_I));
fprintf('-------------------------------------------------------\n\n');

fprintf('ÍNDICES DE AISLAMIENTO POR FRECUENCIA (L''_nT):\n');
fprintf(' Freq (Hz) | L''_nT (dB)\n');
fprintf('-----------|-----------\n');
for i = 1:length(frecuencias)
    fprintf('   %5d   |   %5.1f\n', frecuencias(i), L_nT(i));
end
fprintf('-------------------------------------------------------\n\n');

% --- Gráfica y Tabla de Evaluación (como en la norma) ---

% Reconstruir la curva de referencia desplazada para el gráfico
curve_ref_freq = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
curve_ref_level = [62, 62, 62, 62, 62, 62, 61, 60, 59, 58, 57, 54, 51, 48, 45, 42];
shift = L_nTw - 60; % El valor de la curva de referencia a 500 Hz es 60
final_curve = curve_ref_level + shift;

% Crear la figura principal, más ancha para acomodar la tabla
fig = figure('Name', 'Evaluación de Aislamiento a Ruido de Impacto - ISO 717-2', ...
       'NumberTitle', 'off', 'Position', [100 100 1200 650]);

% --- Panel Izquierdo: Gráfica de Evaluación ---
ax = axes('Parent', fig, 'Position', [0.07 0.12 0.55 0.78]);

semilogx(ax, frecuencias, L_nT, 'b-o', 'LineWidth', 2, 'MarkerSize', 7, ...
         'MarkerFaceColor', 'b', 'DisplayName', 'Nivel de Impacto Estandarizado (L''_{nT})');
hold(ax, 'on');

semilogx(ax, curve_ref_freq, final_curve, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 5, ...
         'DisplayName', 'Curva de Referencia ISO 717-2 Desplazada');

idx_500 = find(curve_ref_freq == 500, 1);
plot(ax, 500, final_curve(idx_500), 'k*', 'MarkerSize', 14, 'LineWidth', 2, ...
     'DisplayName', sprintf('Índice Ponderado L''_{nT,w} = %d dB', round(L_nTw)));

grid(ax, 'on'); grid(ax, 'minor');
set(ax, 'XScale', 'log');
xticks(ax, curve_ref_freq);
xticklabels(ax, {'100','125','160','200','250','315','400','500','630','800','1k','1.25k','1.6k','2k','2.5k','3.15k'});
xtickangle(ax, 45);
xlim(ax, [80, 4000]);

xlabel(ax, 'Frecuencia (Hz)', 'FontWeight', 'bold', 'FontSize', 11);
ylabel(ax, 'Nivel de Presión Acústica de Impacto (dB)', 'FontWeight', 'bold', 'FontSize', 11);

title_str = sprintf('Evaluación de Aislamiento a Ruido de Impacto: L''_{nT,w} (C_I) = %d (%.0f) dB', round(L_nTw), round(C_I));
title(ax, title_str, 'FontWeight', 'bold', 'FontSize', 14);

legend(ax, 'Location', 'southwest', 'FontSize', 10);
hold(ax, 'off');

% --- Panel Derecho: Tabla de Niveles y Resultados Globales ---

% Crear la tabla con los niveles por frecuencia
column_names = {'Frecuencia (Hz)', 'L''_nT (dB)'};

% Formatear los datos para forzar exactamente 1 decimal en la interfaz
table_data = cell(length(frecuencias), 2);
for i = 1:length(frecuencias)
    table_data{i, 1} = frecuencias(i);             % Frecuencia (entero)
    table_data{i, 2} = sprintf('%.1f', L_nT(i));   % Nivel (fijado a 1 decimal)
end

uitable('Parent', fig, 'Data', table_data, ...
        'ColumnName', column_names, ...
        'Position', [780 50 380 500], ...
        'ColumnWidth', {150, 150}, ...
        'FontSize', 10, ...
        'RowName', []);

% Añadir texto con los resultados globales encima de la tabla
global_results_str = {
    'RESULTADOS GLOBALES',
    '-------------------------------------------------------',
    sprintf('L''_{nT,w} = %d dB', round(L_nTw)),
    sprintf('C_I (100-2500 Hz) = %.1f dB', C_I),
    sprintf('L''_{nT,w} (C_I) = %d (%d) dB', round(L_nTw), round(C_I)),
    '-------------------------------------------------------',
    sprintf('T60 (%s) = %.2f s  |  T60 (Sabine) = %.2f s', metodo_T60, T_reverb, T_sabine)
};
annotation(fig, 'textbox', [0.63 0.82 0.34 0.14], ...
           'String', global_results_str, ...
           'FontSize', 12, 'FontWeight', 'bold', ...
           'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');

fprintf('✓ Análisis completado. Se ha generado la tabla de resultados y la gráfica de evaluación.\n\n');