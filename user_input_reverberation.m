% Script interactivo para cálculo de tiempo de reverberación
% Solicita datos del recinto por consola y calcula TR para múltiples frecuencias

% Cargar base de datos de materiales
run('materials_database.m');

% Definir frecuencias en bandas de tercio de octava (50-5000 Hz)
freqs = [50, 63, 80, 100, 125, 160, 200, 250, 315, 400, 500, 630, 800, 1000, 1250, 1600, 2000, 2500, 3150, 4000, 5000];

% Solicitar datos del recinto
V = input('Volumen del recinto (m³): ');
while V <= 0
    fprintf('El volumen debe ser positivo.\n');
    V = input('Volumen del recinto (m³): ');
end

N = input('Número de superficies: ');
while N <= 0 || mod(N,1) ~= 0
    fprintf('El número de superficies debe ser un entero positivo.\n');
    N = input('Número de superficies: ');
end

% Solicitar datos de cada superficie
surfaces = zeros(N, 1); % áreas
materials = cell(N, 1); % nombres de materiales
available_materials = fieldnames(materials_db);
fprintf('Materiales disponibles: %s\n', strjoin(available_materials, ', '));

for i = 1:N
    area = input(sprintf('Área de superficie %d (m²): ', i));
    while area <= 0
        fprintf('El área debe ser positiva.\n');
        area = input(sprintf('Área de superficie %d (m²): ', i));
    end
    surfaces(i) = area;
    
    mat = input(sprintf('Material de superficie %d (%s): ', i, strjoin(available_materials, '/')), 's');
    while ~isfield(materials_db, mat)
        fprintf('Material no válido. Disponibles: %s\n', strjoin(available_materials, ', '));
        mat = input(sprintf('Material de superficie %d (%s): ', i, strjoin(available_materials, '/')), 's');
    end
    materials{i} = mat;
end

total_S = sum(surfaces);

% Solicitar método de cálculo
fprintf('Métodos disponibles:\n');
fprintf('1: Sabine\n');
fprintf('2: Eyring\n');
fprintf('3: Millington\n');
method = input('Seleccione método (1-3): ');
while ~ismember(method, [1,2,3])
    fprintf('Seleccione 1, 2 o 3.\n');
    method = input('Seleccione método (1-3): ');
end

% Solicitar coeficiente de atenuación del aire
m_default = 0.000007;
m_str = input(sprintf('Coeficiente de atenuación del aire (m⁻¹, default %.2e): ', m_default), 's');
if isempty(m_str)
    m = m_default;
else
    m = str2double(m_str);
end
while m < 0
    fprintf('El coeficiente debe ser no negativo.\n');
    fprintf('Coeficiente de atenuación del aire (m⁻¹, default %.2e): ', m_default);
    m_str = input('', 's');
    if isempty(m_str)
        m = m_default;
    else
        m = str2double(m_str);
    end
end

% Calcular TR para cada frecuencia
T60 = zeros(size(freqs));
for k = 1:length(freqs)
    % Obtener coeficientes de absorción para esta frecuencia
    alphas = zeros(N, 1);
    for i = 1:N
        alphas(i) = materials_db.(materials{i})(k);
    end
    
    if method == 1 || method == 2
        % Calcular absorción media ponderada
        mean_alpha = sum(surfaces .* alphas) / total_S;
        if method == 1
            T60(k) = calculate_reverberation_sabine(mean_alpha, total_S, m, V);
        else
            T60(k) = calculate_reverberation_eyring(mean_alpha, total_S, m, V);
        end
    else
        % Millington: usar matriz de superficies
        superficies_f = [surfaces, alphas];
        T60(k) = calculate_reverberation_millington(superficies_f, total_S, m, V);
    end
end

% Generar gráfico
figure;
semilogx(freqs, T60, 'b-o', 'LineWidth', 2);
xlabel('Frecuencia (Hz)');
ylabel('Tiempo de Reverberación T_{60} (s)');
title(sprintf('Tiempo de Reverberación - Método %d', method));
grid on;
xlim([min(freqs), max(freqs)]);

% Mostrar resultados en consola
fprintf('\nResultados:\n');
fprintf('Frecuencia (Hz)\tT60 (s)\n');
for k = 1:length(freqs)
    fprintf('%.0f\t\t\t%.3f\n', freqs(k), T60(k));
end