function L_nT = calculate_standardized_impact_level(L_i, T, T0)
%% CÁLCULO DEL NIVEL DE PRESIÓN ACÚSTICA ESTANDARIZADO DE RUIDO DE IMPACTOS
%
% SINTAXIS:
%   L_nT = calculate_standardized_impact_level(L_i, T, T0)
%
% ENTRADA:
%   L_i  : Vector (1xN) de niveles de presión acústica promediados en recinto
%          receptor (dB ref 20 μPa) - obtenido de calculate_impact_level()
%   T    : Tiempo de reverberación calculado (segundos)
%          Valor escalar (típicamente T60 de Sabine, Eyring o Millington)
%   T0   : Tiempo de reverberación de referencia (segundos)
%          Típico: T0 = 0.5 s para viviendas y oficinas
%
% SALIDA:
%   L_nT : Vector fila (1xN) con niveles estandarizados de impacto
%          en cada banda de frecuencia (dB)
%
% FÓRMULA:
%   L'ₙₜ = L_i - 10*log₁₀(T/T₀)
%
%   donde:
%   - Corrección acústica: -10*log₁₀(T/T₀) 
%   - Si T > T0, la corrección es negativa (reduce el nivel)
%   - Si T < T0, la corrección es positiva (aumenta el nivel)
%
% REFERENCIAS:
%   ISO 16283-2 (Aislamiento acústico a ruido de impacto)
%   Esta normalización permite comparar resultados de impacto entre recintos
%   con diferentes tiempos de reverberación
%
% NOTAS:
%   - T y T0 deben estar en las mismas unidades (segundos)
%   - L_nT corrige los efectos de la acústica del recinto receptor
%   - Se calcula para cada banda de frecuencia por separado

% Validación
if T <= 0 || T0 <= 0
    error('Error: Los tiempos de reverberación T y T0 deben ser positivos.');
end

% Calcular corrección acústica
correction = 10 * log10(T / T0);

% Aplicar corrección a todos los niveles de impacto
L_nT = L_i - correction;

end
