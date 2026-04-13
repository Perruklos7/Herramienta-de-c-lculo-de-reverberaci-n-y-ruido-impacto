function L_i = calculate_impact_level(L_measurements)
%% CÁLCULO DEL NIVEL DE PRESIÓN ACÚSTICA PROMEDIADO EN RECINTO RECEPTOR
%
% SINTAXIS:
%   L_i = calculate_impact_level(L_measurements)
%
% ENTRADA:
%   L_measurements : Matriz MxN con niveles medidos (dB ref 20 μPa)
%                    Filas = posiciones de micrófono
%                    Columnas = bandas de frecuencia
%
% SALIDA:
%   L_i : Vector fila (1xN) con los niveles promediados energéticamente
%         en el recinto receptor para cada banda de frecuencia
%
% FÓRMULA:
%   L_i = 10 * log₁₀ (1/n * Σⱼ₌₁ⁿ 10^(L_j/10))
%
%   donde L_j son los niveles en n diferentes posiciones medidas
%
% REFERENCIAS:
%   ISO 16283-2 (Aislamiento acústico a ruido de impacto)
%   Promedio energético de niveles de presión acústica

% Obtener dimensiones
[num_positions, num_frequencies] = size(L_measurements);

% Inicializar vector de resultados
L_i = zeros(1, num_frequencies);

% Para cada banda de frecuencia, calcular el promedio energético
for f = 1:num_frequencies
    % Extraer los niveles para esta frecuencia de todas las posiciones
    L_f = L_measurements(:, f);
    
    % Promedio energético: L_i = 10*log₁₀(1/n * Σ 10^(L_j/10))
    sum_energies = sum(10.^(L_f / 10));
    L_i(f) = 10 * log10(sum_energies / num_positions);
end

end
