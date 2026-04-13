function T60 = calculate_reverberation_eyring(alpha_m, S, m, V)
%% CÁLCULO DEL TIEMPO DE REVERBERACIÓN MEDIANTE FÓRMULA DE EYRING
%
% SINTAXIS:
%   T60 = calculate_reverberation_eyring(alpha_m, S, m, V)
%
% ENTRADA:
%   alpha_m : Coeficiente de absorción medio del recinto
%   S       : Superficie total del recinto (m²)
%   m       : Coeficiente de atenuación del sonido en el aire (m⁻¹)
%   V       : Volumen del recinto (m³)
%
% SALIDA:
%   T60     : Tiempo de reverberación (segundos)
%
% FÓRMULA:
%   T_RE = 0.162 * V / (-S*ln(1 - α_m) + 4*m*V)
%
% REFERENCIAS:
%   ISO 3382-2 (Medición de parámetros acústicos en recintos)
%   Fórmula de Eyring (válida para absorción no uniforme)
%   Se emplea cuando α_m > 0.3 (normalmente más precisa que Sabine)

% Validación
if alpha_m >= 1
    error('Error: El coeficiente de absorción debe ser menor que 1.');
end

% Fórmula de Eyring
% Término logarítmico de Eyring
ln_term = -S * log(1 - alpha_m);
denominator = ln_term + 4 * m * V;

if denominator <= 0
    error('Error: El denominador debe ser positivo. Revise los parámetros de entrada.');
end

T60 = 0.162 * V / denominator;

end
