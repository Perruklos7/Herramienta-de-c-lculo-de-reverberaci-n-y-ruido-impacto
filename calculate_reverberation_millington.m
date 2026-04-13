function T60 = calculate_reverberation_millington(superficies, S, m, V)
%% CÁLCULO DEL TIEMPO DE REVERBERACIÓN MEDIANTE FÓRMULA DE MILLINGTON
%
% SINTAXIS:
%   T60 = calculate_reverberation_millington(superficies, S, m, V)
%
% ENTRADA:
%   superficies : Matriz Nx2 con [Superficie_i, Coef_Absorcion_i]
%                 Cada fila representa una superficie con su absorción
%   S           : Superficie total del recinto (m²) [verificación]
%   m           : Coeficiente de atenuación del sonido en el aire (m⁻¹)
%   V           : Volumen del recinto (m³)
%
% SALIDA:
%   T60         : Tiempo de reverberación (segundos)
%
% FÓRMULA:
%   T_RM = 0.162 * V / (Σ[-S_i * ln(1 - α_i)] + 4*m*V)
%
% REFERENCIAS:
%   ISO 3382-2
%   Fórmula de Millington-Sette (óptima para absorciones heterogéneas)
%   Se emplea cuando hay materiales muy diferentes en el recinto
%
% EJEMPLO:
%   superficies = [
%       80, 0.05;    % 80 m² de paredes lisas (α=0.05)
%       20, 0.80;    % 20 m² de techo acústico (α=0.80)
%       30, 0.30     % 30 m² de piso
%   ];
%   T60 = calculate_reverberation_millington(superficies, 130, 0.00001, 100);

% Validación de entrada
if size(superficies, 2) ~= 2
    error('Error: superficies debe ser una matriz Nx2 [Superficie, Absorcion].');
end

% Verificar que la suma de superficies individuales sea consistente con S total
suma_superficies = sum(superficies(:, 1));
if abs(suma_superficies - S) > 1e-6  % Tolerancia pequeña para errores numéricos
    warning(sprintf('La suma de superficies individuales (%.2f m²) no coincide con S total (%.2f m²). Se usará la suma de individuales.', suma_superficies, S));
    S = suma_superficies;  % Usar la suma de individuales como más precisa
end

% Inicializar suma
suma_ln = 0;

% Iterar sobre cada superficie
for i = 1:size(superficies, 1)
    S_i = superficies(i, 1);      % Superficie individual
    alpha_i = superficies(i, 2);   % Coeficiente de absorción individual
    
    % Validación
    if alpha_i >= 1 || alpha_i < 0
        warning(sprintf('Superficie %d: Coeficiente de absorción fuera de rango [0,1). Se ajusta.', i));
        alpha_i = max(0, min(0.99, alpha_i));
    end
    
    % Sumar término logarítmico: -S_i * ln(1 - α_i)
    suma_ln = suma_ln + (-S_i * log(1 - alpha_i));
end

% Denominador completo
denominator = suma_ln + 4 * m * V;

if denominator <= 0
    error('Error: El denominador debe ser positivo. Revise los parámetros de entrada.');
end

% Cálculo final
T60 = 0.162 * V / denominator;

end
