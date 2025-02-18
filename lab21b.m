clc, clearvars, close all;

% Definiera differentialekvationen som en anonym funktion
dydx = @(x, y) -((1/6) + (pi * sin(pi*x)) / (1.6 - cos(pi*x))) * y;

% Initialvärden
x0 = 0;
y0 = 2.5;
x_end = 4;
h = 0.5; % Startsteglängd
threshold = 0.05; % Felgräns för en säker decimal
previous_y4 = NaN;
halvningar = 0;

% Iterera tills förändringen i y(4) är mindre än threshold
while true
    x = x0:h:x_end;
    y = zeros(size(x));
    y(1) = y0;
    
    % Eulers metod
    for i = 1:length(x)-1
        y(i+1) = y(i) + h * dydx(x(i), y(i));
    end
    
    current_y4 = y(end);
    
    if ~isnan(previous_y4) && abs(current_y4 - previous_y4) < threshold
        break;
    end
    
    previous_y4 = current_y4;
    h = h / 2; % Halvera steglängden
    halvningar = halvningar + 1;
end

fprintf('Antal halveringar: %d\n', halvningar);
fprintf('Slutlig steglängd: %.8f\n', h);
fprintf('Beräknat y(4): %.4f\n', current_y4);
