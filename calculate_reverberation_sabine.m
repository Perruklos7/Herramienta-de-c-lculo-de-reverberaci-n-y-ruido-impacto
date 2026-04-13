function T60 = calculate_reverberation_sabine(alpha_m, S, m, V)
%% CÁLCULO DEL TIEMPO DE REVERBERACIÓN MEDIANTE FÓRMULA DE SABINE
%
% SINTAXIS:
%   T60 = calculate_reverberation_sabine(alpha_m, S, m, V)
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
%   T_RS = 0.162 * V / (α_m * S + 4*m*V)
%
%   O equivalentemente:
%   T_60−Sabine = 0.161 * V / (A_tot + 4*m*V)
%
% REFERENCIAS:
%   ISO 3382-2 (Medición de parámetros acústicos en recintos)
%   Norma Sabine (1900s)

% Fórmula de Sabine
A_tot = alpha_m * S;  % Absorción total en sabins
denominator = A_tot + 4 * m * V;

if denominator <= 0
    error('Error: El denominador debe ser positivo. Revise los parámetros de entrada.');
end

T60 = 0.162 * V / denominator;

end
