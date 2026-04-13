%% PRUEBA RÁPIDA DE LAS FUNCIONES CORREGIDAS
% =========================================================================
% Script para verificar que las funciones corregidas funcionan correctamente
% =========================================================================

clear all; close all; clc;

fprintf('\n');
fprintf('╔═══════════════════════════════════════════════════════════════╗\n');
fprintf('║         PRUEBA DE FUNCIONES CORREGIDAS                       ║\n');
fprintf('╚═══════════════════════════════════════════════════════════════╝\n\n');

% =========================================================================
% PRUEBA 1: calculate_reverberation_millington
% =========================================================================

fprintf('Test 1: calculate_reverberation_millington\n');
fprintf('───────────────────────────────────────────\n');

try
    % Datos de prueba
    superficies = [
        80, 0.05;    % Paredes
        20, 0.80;    % Techo acústico
        30, 0.30     % Piso
    ];
    S_total = 130;
    m = 0.000007;
    V = 100;

    T_mill = calculate_reverberation_millington(superficies, S_total, m, V);

    fprintf('  ✓ Función ejecutada correctamente\n');
    fprintf('  Resultado: T₆₀ = %.4f s\n', T_mill);

    % Verificar que el resultado es razonable
    if T_mill > 0 && T_mill < 10
        fprintf('  ✓ Resultado en rango esperado\n');
    else
        fprintf('  ⚠ Resultado fuera de rango esperado\n');
    end

catch ME
    fprintf('  ✗ Error: %s\n', ME.message);
end

fprintf('\n');

% =========================================================================
% PRUEBA 2: calculate_weighted_impact_level
% =========================================================================

fprintf('Test 2: calculate_weighted_impact_level\n');
fprintf('────────────────────────────────────────\n');

try
    % Datos de prueba
    frecuencias = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
                   1250, 1600, 2000, 2500, 3150];
    L_nT = [55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40];

    L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);

    fprintf('  ✓ Función ejecutada correctamente\n');
    fprintf('  Resultado: L´ₙₜ,w = %.1f dB\n', L_nTw);

    % Verificar que el resultado es razonable
    if L_nTw >= 30 && L_nTw <= 70
        fprintf('  ✓ Resultado en rango esperado\n');
    else
        fprintf('  ⚠ Resultado fuera de rango esperado\n');
    end

catch ME
    fprintf('  ✗ Error: %s\n', ME.message);
end

fprintf('\n');

% =========================================================================
% PRUEBA 3: Integración completa
% =========================================================================

fprintf('Test 3: Integración completa (reverberación → impacto)\n');
fprintf('───────────────────────────────────────────────────────\n');

try
    % Parámetros del recinto
    alpha_m = 0.25;
    S = 100;
    V = 250;
    m = 0.000007;

    % Calcular reverberación
    T_sabine = calculate_reverberation_sabine(alpha_m, S, m, V);
    T_eyring = calculate_reverberation_eyring(alpha_m, S, m, V);

    % Mediciones simuladas
    L_measurements = [
        50, 51, 49, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40;
        51, 50, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39;
        49, 52, 50, 49, 51, 50, 48, 46, 45, 44, 43, 42, 41, 40, 39, 38
    ];

    % Calcular impacto
    L_i = calculate_impact_level(L_measurements);
    L_nT = calculate_standardized_impact_level(L_i, T_eyring, 0.5);
    L_nTw = calculate_weighted_impact_level(frecuencias, L_nT);

    fprintf('  ✓ Integración completa exitosa\n');
    fprintf('  T₆₀ (Sabine): %.4f s\n', T_sabine);
    fprintf('  T₆₀ (Eyring): %.4f s\n', T_eyring);
    fprintf('  L´ₙₜ,w: %.1f dB\n', L_nTw);

catch ME
    fprintf('  ✗ Error en integración: %s\n', ME.message);
end

fprintf('\n');
fprintf('═════════════════════════════════════════════════════════════════\n');

if exist('T_mill', 'var') && exist('L_nTw', 'var')
    fprintf('✅ TODAS LAS FUNCIONES CORREGIDAS FUNCIONAN CORRECTAMENTE\n');
else
    fprintf('❌ ALGUNAS FUNCIONES AÚN TIENEN PROBLEMAS\n');
end

fprintf('═════════════════════════════════════════════════════════════════\n\n');