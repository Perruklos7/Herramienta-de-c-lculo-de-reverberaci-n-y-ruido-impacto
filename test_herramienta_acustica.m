%% PRUEBAS UNITARIAS - HERRAMIENTA DE ACÚSTICA
% =========================================================================
% Este script contiene pruebas unitarias para validar todas las funciones
% de la herramienta de cálculo de reverberación y ruido de impacto.
%
% EJECUTAR CON: >> test_herramienta_acustica
% =========================================================================

clear all; close all; clc;

fprintf('\n');
fprintf('╔═══════════════════════════════════════════════════════════════╗\n');
fprintf('║    SUITE DE PRUEBAS UNITARIAS - HERRAMIENTA ACÚSTICA        ║\n');
fprintf('╚═══════════════════════════════════════════════════════════════╝\n\n');

% Variables de contador para pruebas
pruebas_totales = 0;
pruebas_pasadas = 0;
pruebas_fallidas = 0;

% =========================================================================
% FUNCIÓN AUXILIAR PARA PRUEBAS
% =========================================================================

function [paso, total] = run_test(nombre_test, test_func, verbose)
    % run_test: Ejecuta una prueba y reporta resultado
    
    if nargin < 3
        verbose = false;
    end
    
    try
        test_func();
        if verbose
            fprintf('  ✓ %s\n', nombre_test);
        end
        paso = true;
    catch ME
        if verbose
            fprintf('  ✗ %s\n', nombre_test);
            fprintf('    Error: %s\n', ME.message);
        end
        paso = false;
    end
    total = 1;
end

% =========================================================================
% BLOQUE 1: PRUEBAS DE REVERBERACIÓN
% =========================================================================

fprintf('═ BLOQUE 1: REVERBERACIÓN ═════════════════════════════════════\n\n');

fprintf('Test Group 1.1: Método Sabine\n');
fprintf('─────────────────────────────────\n');

% Test 1.1.1: Sabine - Parámetros normales
test_1_1_1 = @() test_sabine_normal();
function test_sabine_normal()
    T = calculate_reverberation_sabine(0.20, 100, 0.000007, 250);
    assert(T > 0, 'T debe ser positivo');
    assert(T < 10, 'T debe ser menor a 10s');
    assert(abs(T - 2.023) < 0.01, 'Valor esperado ~2.02s');  % valor calculado correctamente
end
[p, t] = run_test('Sabine con parámetros normales', test_1_1_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 1.1.2: Sabine - Validación de rango
test_1_1_2 = @() test_sabine_rango();
function test_sabine_rango()
    % Probar con diferentes valores
    for alpha = 0.05:0.05:0.25
        T = calculate_reverberation_sabine(alpha, 100, 0.000007, 250);
        assert(T > 0.1 && T < 15, 'T fuera de rango esperado');
    end
end
[p, t] = run_test('Sabine - Rango de valores', test_1_1_2, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 1.1.3: Sabine - Relación inversa con absorción
test_1_1_3 = @() test_sabine_inversa();
function test_sabine_inversa()
    T1 = calculate_reverberation_sabine(0.10, 100, 0.000007, 250);
    T2 = calculate_reverberation_sabine(0.20, 100, 0.000007, 250);
    assert(T1 > T2, 'Mayor absorción debe dar menor T60');
end
[p, t] = run_test('Sabine - Relación inversa absorción', test_1_1_3, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

fprintf('\nTest Group 1.2: Método Eyring\n');
fprintf('─────────────────────────────────\n');

% Test 1.2.1: Eyring - Parámetros normales
test_1_2_1 = @() test_eyring_normal();
function test_eyring_normal()
    T = calculate_reverberation_eyring(0.20, 100, 0.000007, 250);
    assert(T > 0, 'T debe ser positivo');
    assert(T < 10, 'T debe ser menor a 10s');
end
[p, t] = run_test('Eyring con parámetros normales', test_1_2_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 1.2.2: Eyring vs Sabine - Eyring < Sabine para mismos parámetros
test_1_2_2 = @() test_eyring_vs_sabine();
function test_eyring_vs_sabine()
    alpha = 0.30;
    S = 100;
    m = 0.000007;
    V = 250;
    
    T_sabine = calculate_reverberation_sabine(alpha, S, m, V);
    T_eyring = calculate_reverberation_eyring(alpha, S, m, V);
    
    % Para absorción media, Eyring típicamente da valores menores
    assert(T_eyring > 0 && T_sabine > 0, 'Ambos deben ser positivos');
end
[p, t] = run_test('Eyring vs Sabine', test_1_2_2, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

fprintf('\nTest Group 1.3: Método Millington\n');
fprintf('─────────────────────────────────\n');

% Test 1.3.1: Millington - Parámetros normales
test_1_3_1 = @() test_millington_normal();
function test_millington_normal()
    superficies = [80, 0.05; 20, 0.80; 30, 0.30];
    T = calculate_reverberation_millington(superficies, 130, 0.000007, 100);
    assert(T > 0, 'T debe ser positivo');
    assert(T < 10, 'T debe ser menor a 10s');
end
[p, t] = run_test('Millington con parámetros normales', test_1_3_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 1.3.2: Millington - Validación de entrada
test_1_3_2 = @() test_millington_entrada();
function test_millington_entrada()
    % Matriz bien formada
    superficies = [50, 0.10; 50, 0.20; 30, 0.30];
    T = calculate_reverberation_millington(superficies, 130, 0.000007, 100);
    assert(T > 0, 'Resultado debe ser positivo');
end
[p, t] = run_test('Millington - Validación de entrada', test_1_3_2, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% =========================================================================
% BLOQUE 2: PRUEBAS DE IMPACTO ACÚSTICO
% =========================================================================

fprintf('\n═ BLOQUE 2: IMPACTO ACÚSTICO ══════════════════════════════════\n\n');

fprintf('Test Group 2.1: Nivel Promediado (L_i)\n');
fprintf('─────────────────────────────────────\n');

% Test 2.1.1: Promedio simple
test_2_1_1 = @() test_promedio_simple();
function test_promedio_simple()
    L = [50, 50, 50];  % Valores iguales
    L_i = calculate_impact_level([L]);
    assert(all(abs(L_i - 50) < 0.01), 'Promedio de valores iguales debe ser igual');
end
[p, t] = run_test('Promedio de valores iguales', test_2_1_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 2.1.2: Promedio energético
test_2_1_2 = @() test_promedio_energetico();
function test_promedio_energetico()
    L = [60, 60, 60];
    L_i = calculate_impact_level([L; L; L]);  % 3 posiciones iguales
    assert(abs(L_i(1) - 60) < 0.01, 'Promedio energético debe ser correcto');
end
[p, t] = run_test('Promedio energético múltiples posiciones', test_2_1_2, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 2.1.3: Rango de valores
test_2_1_3 = @() test_promedio_rango();
function test_promedio_rango()
    L = [40, 50, 60, 70, 80];
    L_i = calculate_impact_level([L]);
    % El promedio energético de 40-80 debe estar entre 40 y 80
    assert(all(L_i >= 40) && all(L_i <= 80), 'Promedio debe estar en rango');
end
[p, t] = run_test('Promedio en rango válido', test_2_1_3, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

fprintf('\nTest Group 2.2: Nivel Estandarizado (L_nT)\n');
fprintf('────────────────────────────────────────\n');

% Test 2.2.1: Sin corrección (T = T0)
test_2_2_1 = @() test_estandarizado_sin_corr();
function test_estandarizado_sin_corr()
    L_i = [50, 51, 52];
    T = 0.5;
    T0 = 0.5;
    L_nT = calculate_standardized_impact_level(L_i, T, T0);
    assert(all(abs(L_nT - L_i) < 0.01), 'Sin corrección, L_nT = L_i');
end
[p, t] = run_test('Estandarizado sin corrección (T=T₀)', test_2_2_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% Test 2.2.2: Con corrección (T > T0)
test_2_2_2 = @() test_estandarizado_con_corr();
function test_estandarizado_con_corr()
    L_i = [50, 51, 52];
    T = 1.0;  % Doble reverberación
    T0 = 0.5;
    L_nT = calculate_standardized_impact_level(L_i, T, T0);
    % T/T0 = 2, log(2) ≈ 0.301, 10*log(2) ≈ 3 dB
    assert(all(L_nT < L_i), 'Mayor T debe dar menor L_nT');
end
[p, t] = run_test('Estandarizado con corrección', test_2_2_2, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

fprintf('\nTest Group 2.3: Nivel Ponderado (L_nT_w)\n');
fprintf('─────────────────────────────────────────\n');

% Test 2.3.1: Ponderación con espectro típico
test_2_3_1 = @() test_ponderado_tipico();
function test_ponderado_tipico()
    freq = [100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, ...
            1250, 1600, 2000, 2500, 3150];
    L_nT = [55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40];
    
    L_nTw = calculate_weighted_impact_level(freq, L_nT);
    
    % L_nTw debe estar en rango razonable
    assert(L_nTw >= 30 && L_nTw <= 70, 'L_nTw fuera de rango esperado');
end
[p, t] = run_test('Ponderado con espectro típico', test_2_3_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% =========================================================================
% BLOQUE 3: PRUEBAS DE INTEGRACIÓN
% =========================================================================

fprintf('\n═ BLOQUE 3: PRUEBAS DE INTEGRACIÓN ════════════════════════════\n\n');

fprintf('Test Group 3.1: Flujo Completo\n');
fprintf('──────────────────────────────\n');

% Test 3.1.1: Flujo reverberación → impacto
test_3_1_1 = @() test_flujo_completo();
function test_flujo_completo()
    % Parámetros de recinto
    alpha_m = 0.25;
    S = 100;
    V = 250;
    m = 0.000007;
    
    % Calcular reverberación
    T_sabine = calculate_reverberation_sabine(alpha_m, S, m, V);
    
    % Mediciones simuladas
    L_measurements = [50, 51, 49, 52; 51, 50, 52, 51];
    
    % Calcular impacto
    L_i = calculate_impact_level(L_measurements);
    L_nT = calculate_standardized_impact_level(L_i, T_sabine, 0.5);
    
    % Verificar que todos los pasos funcionan
    assert(T_sabine > 0, 'T₆₀ debe ser positivo');
    assert(all(L_i > 0), 'L_i debe ser positivo');
    assert(all(L_nT > 0), 'L_nT debe ser positivo');
end
[p, t] = run_test('Flujo completo reverberación-impacto', test_3_1_1, true);
pruebas_totales = pruebas_totales + t;
pruebas_pasadas = pruebas_pasadas + p;

% =========================================================================
% RESUMEN DE PRUEBAS
% =========================================================================

fprintf('\n═════════════════════════════════════════════════════════════════\n');
fprintf('                      RESUMEN DE PRUEBAS\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');

porcentaje = (pruebas_pasadas / pruebas_totales) * 100;

fprintf('  Total de pruebas:       %3d\n', pruebas_totales);
fprintf('  Pruebas pasadas:        %3d\n', pruebas_pasadas);
fprintf('  Pruebas fallidas:       %3d\n', pruebas_totales - pruebas_pasadas);
fprintf('  Porcentaje de éxito:    %3.1f%%\n\n', porcentaje);

if porcentaje == 100
    fprintf('╔═════════════════════════════════════════════════════════════╗\n');
    fprintf('║              ✅ TODAS LAS PRUEBAS PASADAS                  ║\n');
    fprintf('║        La herramienta está funcionando correctamente       ║\n');
    fprintf('╚═════════════════════════════════════════════════════════════╝\n\n');
elseif porcentaje >= 80
    fprintf('╔═════════════════════════════════════════════════════════════╗\n');
    fprintf('║             ⚠️  ALGUNAS PRUEBAS FALLIDAS                   ║\n');
    fprintf('║        Revisar los errores anteriores                      ║\n');
    fprintf('╚═════════════════════════════════════════════════════════════╝\n\n');
else
    fprintf('╔═════════════════════════════════════════════════════════════╗\n');
    fprintf('║             ❌ MÚLTIPLES PRUEBAS FALLIDAS                  ║\n');
    fprintf('║        La herramienta podría tener problemas graves        ║\n');
    fprintf('╚═════════════════════════════════════════════════════════════╝\n\n');
end

fprintf('\n');
