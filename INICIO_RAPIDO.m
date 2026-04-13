%% INICIO RÁPIDO - HERRAMIENTA DE ACÚSTICA
% =========================================================================
%
% Ejecute este archivo para ver las opciones principales
%
% =========================================================================

clc; fprintf('\n\n');

fprintf('╔════════════════════════════════════════════════════════════════╗\n');
fprintf('║    HERRAMIENTA DE ACÚSTICA - REVERBERACIÓN E IMPACTO          ║\n');
fprintf('║                 CENTRO DE INICIO RÁPIDO                       ║\n');
fprintf('╚════════════════════════════════════════════════════════════════╝\n\n');

fprintf('OPCIONES DISPONIBLES:\n');
fprintf('═════════════════════════════════════════════════════════════════\n\n');

fprintf('1️⃣  VERIFICAR INSTALACIÓN (Recomendado primero)\n');
fprintf('    >> INSTALACION_Y_CONFIGURACION\n');
fprintf('    └─ Valida que todo esté correctamente configurado\n\n');

fprintf('2️⃣  EJECUTAR ANÁLISIS AUTOMÁTICO (Opción recomendada)\n');
fprintf('    >> main_acoustics_tool\n');
fprintf('    └─ Ejecuta análisis completo con parámetros por defecto\n');
fprintf('    └─ Genera gráficos comparativos\n\n');

fprintf('3️⃣  EJECUTAR EJEMPLO DETALLADO (Más informativo)\n');
fprintf('    >> ejemplo_completo\n');
fprintf('    └─ Análisis paso a paso con explicaciones\n');
fprintf('    └─ Mejor para entender qué hace cada función\n\n');

fprintf('4️⃣  EJECUTAR PRUEBAS DE VALIDACIÓN\n');
fprintf('    >> test_herramienta_acustica\n');
fprintf('    └─ 14 pruebas unitarias para validar todas las funciones\n\n');

fprintf('5️⃣  CONSULTAR DOCUMENTACIÓN\n');
fprintf('    • Inicio rápido: README.md\n');
fprintf('    • Referencia visual: REFERENCIA_RAPIDA.txt\n');
fprintf('    • Detalles técnicos: DOCUMENTACION_TECNICA.txt\n');
fprintf('    • Estructura: ESTRUCTURA_DEL_PROYECTO.txt\n');
fprintf('    • Setup: INSTALACION_Y_CONFIGURACION.m\n\n');

fprintf('═════════════════════════════════════════════════════════════════\n\n');

fprintf('RECOMENDACIÓN DE PRIMER USO:\n');
fprintf('─────────────────────────────\n\n');

fprintf('  Paso 1: Verificar instalación\n');
fprintf('          >> INSTALACION_Y_CONFIGURACION\n\n');

fprintf('  Paso 2: Ejecutar análisis\n');
fprintf('          >> main_acoustics_tool\n\n');

fprintf('  Paso 3: Si desea más detalles\n');
fprintf('          >> ejemplo_completo\n\n');

fprintf('═════════════════════════════════════════════════════════════════\n\n');

fprintf('COMANDOS INDIVIDUALES (Uso avanzado):\n');
fprintf('──────────────────────────────────────\n\n');

fprintf('Calcular reverberación (Sabine):\n');
fprintf('   T = calculate_reverberation_sabine(0.20, 100, 0.000007, 250)\n\n');

fprintf('Calcular reverberación (Eyring):\n');
fprintf('   T = calculate_reverberation_eyring(0.20, 100, 0.000007, 250)\n\n');

fprintf('Calcular impulso de impacto:\n');
fprintf('   L_i = calculate_impact_level(L_measurements)\n\n');

fprintf('Calcular nivel estandarizado:\n');
fprintf('   L_nT = calculate_standardized_impact_level(L_i, T, 0.5)\n\n');

fprintf('Calcular nivel ponderado ISO 717-2:\n');
fprintf('   L_nTw = calculate_weighted_impact_level(frecuencias, L_nT)\n\n');

fprintf('═════════════════════════════════════════════════════════════════\n\n');

fprintf('Para información adicional:\n');
fprintf('  • Leer: README.md\n');
fprintf('  • Consultar: DOCUMENTACION_TECNICA.txt\n');
fprintf('  • Ejecutar: ejemplo_completo.m\n\n');

fprintf('═════════════════════════════════════════════════════════════════\n\n');
