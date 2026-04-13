%% PRUEBA SENCILLA DE FUNCIONES CORREGIDAS
% =========================================================================

clear all; close all; clc;

fprintf('Iniciando pruebas...\n\n');

% Test calculate_reverberation_millington
try
    superficies = [80, 0.05; 20, 0.80; 30, 0.30];
    S = 130;
    m = 0.000007;
    V = 100;
    T = calculate_reverberation_millington(superficies, S, m, V);
    fprintf('✓ Millington: T = %.4f s\n', T);
    millington_ok = true;
catch ME
    fprintf('✗ Millington ERROR: %s\n', ME.message);
    millington_ok = false;
end

% Test calculate_weighted_impact_level
try
    freq = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150];
    L_nT = [55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40];
    L_nTw = calculate_weighted_impact_level(freq, L_nT);
    fprintf('✓ Weighted: L_nTw = %.1f dB\n', L_nTw);
    weighted_ok = true;
catch ME
    fprintf('✗ Weighted ERROR: %s\n', ME.message);
    weighted_ok = false;
end

% Resumen
fprintf('\nRESUMEN:\n');
fprintf('────────\n');
if millington_ok && weighted_ok
    fprintf('✅ TODAS LAS FUNCIONES CORREGIDAS FUNCIONAN\n');
else
    fprintf('❌ ALGUNAS FUNCIONES AÚN TIENEN PROBLEMAS\n');
end

fprintf('\nPruebas completadas.\n');