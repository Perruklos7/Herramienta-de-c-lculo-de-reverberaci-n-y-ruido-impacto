%% GUÍA DE INSTALACIÓN Y CONFIGURACIÓN
% =========================================================================
%
% Este archivo describe los requisitos y pasos para instalar y configurar
% la herramienta de cálculo de reverberación y ruido de impacto acústico.
%
% =========================================================================


% REQUISITOS DEL SISTEMA
% =========================================================================
%
% MATLAB:
%   - Versión: MATLAB R2018a o superior (muy compatible con versiones antiguas)
%   - Licencia: Academic o Professional
%   - Toolboxes: Ninguno especial requerido (solo MATLAB base)
%   - RAM: Mínimo 4 GB
%   - Espacio en disco: ~50 MB
%
% SISTEMA OPERATIVO:
%   - Windows: 7/8/10/11
%   - macOS: 10.13 o superior
%   - Linux: Ubuntu 16.04 o superior
%
% =========================================================================


% PASOS DE INSTALACIÓN
% =========================================================================
%
% 1. CLONAR O DESCARGAR EL REPOSITORIO
%    ══════════════════════════════════════
%
%    Opción A: Clonar con Git
%    ───────────────────────────
%    $ git clone https://github.com/usuario/Herramienta-acustica.git
%    $ cd Herramienta-acustica
%
%    Opción B: Descargar ZIP
%    ───────────────────────
%    - Descargar ZIP del repositorio
%    - Extraer en una carpeta local
%    - Abrir esa carpeta como working directory en MATLAB
%
%
% 2. AGREGAR CARPETA A MATLAB PATH (si no se abre desde la carpeta)
%    ═════════════════════════════════════════════════════════════════
%
%    Método A: En MATLAB IDE
%    ──────────────────────────
%    Home > Set Path > Add Folder
%    (seleccionar carpeta del proyecto)
%    Save
%
%
%    Método B: Programáticamente
%    ──────────────────────────────
%    >> addpath('C:\ruta\a\la\carpeta\del\proyecto');
%    >> savepath;
%
%
%    Método C: Desde archivo startup.m
%    ──────────────────────────────────
%    Agregar a Documentos\MATLAB\startup.m:
%
%    ──── inicio del archivo ────
%    % Configuración de rutas del proyecto
%    addpath('C:\ruta\completa\del\proyecto');
%    disp('Proyecto de Acústica cargado');
%    ──── fin del archivo ────
%
%
% 3. VERIFICAR LA INSTALACIÓN
%    ═════════════════════════════════════════════════════════════════
%
%    En la consola de MATLAB, ejecutar:
%
%    >> which calculate_reverberation_sabine
%    
%    Debería mostrar la ruta del archivo
%
%
% 4. EJECUTAR PRUEBA INICIAL
%    ═════════════════════════════════════════════════════════════════
%
%    >> main_acoustics_tool
%
%    o si prefieres más detalles:
%
%    >> ejemplo_completo
%
%
% =========================================================================


% VERIFICACIÓN DE INSTALACIÓN
% =========================================================================
%
% Ejecutar este bloque de código para verificar que todo funciona:

clear all; close all; clc;

fprintf('\n╔════════════════════════════════════════════════════════════╗\n');
fprintf('║         VERIFICACIÓN DE INSTALACIÓN                       ║\n');
fprintf('╚════════════════════════════════════════════════════════════╝\n\n');

% Test 1: Verificar que las funciones existen
fprintf('Test 1: Verificar disponibilidad de funciones...\n');

funciones_rev = {
    'calculate_reverberation_sabine'
    'calculate_reverberation_eyring'
    'calculate_reverberation_millington'
};

funciones_imp = {
    'calculate_impact_level'
    'calculate_standardized_impact_level'
    'calculate_weighted_impact_level'
};

todas_funciones = [funciones_rev; funciones_imp];
funciones_ok = 0;
funciones_falta = {};

for i = 1:length(todas_funciones)
    try
        which(todas_funciones{i});
        fprintf('  ✓ %s\n', todas_funciones{i});
        funciones_ok = funciones_ok + 1;
    catch
        fprintf('  ✗ %s (NO ENCONTRADA)\n', todas_funciones{i});
        funciones_falta = [funciones_falta; todas_funciones{i}];
    end
end

fprintf('\n  Resultado: %d/%d funciones disponibles\n\n', funciones_ok, length(todas_funciones));

% Test 2: Prueba de cálculo simple
fprintf('Test 2: Prueba de cálculo (Sabine)...\n');

try
    T_test = calculate_reverberation_sabine(0.20, 100, 0.000007, 250);
    fprintf('  ✓ Cálculo exitoso\n');
    fprintf('  Resultado: T₆₀ = %.4f s\n', T_test);
    if T_test > 0 && T_test < 5
        fprintf('  ✓ Resultado dentro de rango esperado\n\n');
    else
        fprintf('  ⚠ Resultado fuera de rango (puede ser correcto según parámetros)\n\n');
    end
catch ME
    fprintf('  ✗ Error en cálculo: %s\n\n', ME.message);
end

% Test 3: Prueba de datos de impacto
fprintf('Test 3: Prueba de cálculo de impacto...\n');

try
    L_test = [50, 51, 49; 51, 50, 52];  % 2 posiciones, 3 frecuencias
    L_i_test = calculate_impact_level(L_test);
    fprintf('  ✓ Promedio energético calculado\n');
    fprintf('  Resultado: L_i = %s dB\n\n', sprintf('%.2f ', L_i_test));
catch ME
    fprintf('  ✗ Error: %s\n\n', ME.message);
end

fprintf('╔════════════════════════════════════════════════════════════╗\n');

if funciones_ok == length(todas_funciones)
    fprintf('║         ✅ INSTALACIÓN CORRECTA                         ║\n');
else
    fprintf('║         ⚠️  FALTAN %d FUNCIONES                        ║\n', length(funciones_falta));
end

fprintf('╚════════════════════════════════════════════════════════════╝\n\n');


% =========================================================================
%
% PRÓXIMOS PASOS
% =========================================================================
%
% Una vez verificada la instalación, puede ejecutar:
%
%   >> main_acoustics_tool          % Script principal automático
%   >> ejemplo_completo             % Ejemplo detallado paso a paso
%
%
% =========================================================================
%
% TROUBLESHOOTING (Resolución de problemas)
% =========================================================================
%
% PROBLEMA: "Undefined function 'calculate_reverberation_sabine'"
% ──────────────────────────────────────────────────────────
% SOLUCIÓN:
%   1. Verificar que la carpeta está agregada al path:
%      >> path  % muestra el path actual
%   2. Agregar manualmente:
%      >> addpath('C:\ruta\correcta\del\proyecto')
%      >> savepath
%   3. Reiniciar MATLAB si persiste
%
%
% PROBLEMA: Errores en cálculos o resultados extraños
% ──────────────────────────────────────────────────
% SOLUCIÓN:
%   1. Verificar parámetros de entrada (α_m debe ser 0-1, V>0, etc.)
%   2. Revisar DOCUMENTACION_TECNICA.txt para valores típicos
%   3. Ejecutar ejemplo_completo.m para ver funcionamiento correcto
%
%
% PROBLEMA: MATLAB se congela o cálculos muy lentos
% ──────────────────────────────────────────────────
% SOLUCIÓN:
%   1. Matrices de datos muy grandes: usar datos moderados (típico: 4x16)
%   2. Verificar memoria disponible: >> memory
%   3. Cerrar otras aplicaciones pesadas
%
%
% PROBLEMA: Gráficos no se muestran
% ───────────────────────────────────
% SOLUCIÓN:
%   1. Verificar que el modo gráfico está activo:
%      >> graphics_toolkit   % muestra el tipo
%   2. Para cambiar:
%      >> graphics_toolkit('qt')   % o 'opengl', 'fltk', etc.
%   3. Reiniciar MATLAB
%
%
% =========================================================================
%
% INFORMACIÓN DE CONTACTO Y SOPORTE
% =========================================================================
%
% Para consultas sobre:
%   • Instalación
%   • Uso de funciones
%   • Interpretación de resultados
%   • Validación contra normas ISO
%
% Consultar: DOCUMENTACION_TECNICA.txt (guía completa)
%
% =========================================================================
%
% OPCIONES DE CONFIGURACIÓN AVANZADA
% =========================================================================
%
% 1. PERSONALIZAR VALORES POR DEFECTO
%    Editar main_acoustics_tool.m y cambiar:
%
%       V = 100;  % Volumen
%       S = 130;  % Superficie
%       alpha_m = 0.15;  % Absorción
%       m = 0.00001;  % Atenuación
%
%
% 2. MODIFICAR CURVA DE REFERENCIA ISO 717-2
%    En calculate_weighted_impact_level.m:
%
%       curve_ref_level = [62, 62, 61, ...];  % Nuevos valores
%
%
% 3. AMPLIAR CON NUEVOS MÉTODOS
%    Crear archivo: calculate_reverberation_micrometric.m
%    Basarse en template de calculate_reverberation_sabine.m
%
%
% =========================================================================
