function L_corr = correct_for_background_noise(L_signal, L_noise)
%% CORRECCIÓN DE NIVEL DE SEÑAL POR RUIDO DE FONDO
%
% SINTAXIS:
%   L_corr = correct_for_background_noise(L_signal, L_noise)
%
% ENTRADA:
%   L_signal : Vector de niveles de presión sonora de la señal (dB)
%   L_noise  : Vector de niveles de presión sonora del ruido de fondo (dB)
%
% SALIDA:
%   L_corr   : Vector de niveles de señal corregidos (dB)
%
% DESCRIPCIÓN:
%   Aplica la corrección por ruido de fondo según ISO 16283.
%   La corrección se aplica si la diferencia (L_signal - L_noise) es
%   menor a 10 dB. Si es menor a 6 dB, la medición tiene una precisión
%   reducida. Si es menor a 3 dB, la medición no es válida.
%
% FÓRMULA:
%   L_corr = 10 * log10(10^(L_signal/10) - 10^(L_noise/10))
%
% REFERENCIAS:
%   ISO 16283-1:2014, Anexo B

    if length(L_signal) ~= length(L_noise)
        error('Los vectores de señal y ruido de fondo deben tener la misma longitud.');
    end

    L_corr = L_signal; % Inicializar con los valores originales
    delta_L = L_signal - L_noise;

    % Aplicar corrección solo donde la diferencia es menor de 10 dB
    indices_a_corregir = find(delta_L < 10);
    
    L_corr(indices_a_corregir) = 10 * log10(10.^(L_signal(indices_a_corregir)/10) - 10.^(L_noise(indices_a_corregir)/10));

end