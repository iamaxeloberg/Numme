clc; clear; close all;

% Definiera differentialekvationen som en anonym funktion
dydx = @(x, y) -((1/6) + (pi * sin(pi*x)) / (1.6 - cos(pi*x))) * y;

% Initialvärden
x0 = 0;
y0 = 2.5;
x_end = 4;

% Steglängder att testa
step_sizes = [0.5, 0.25, 0.1];

figure; hold on;
colors = ['r', 'b', 'g'];
legend_entries = {};

for j = 1:length(step_sizes)
    h = step_sizes(j);
    
    % Skapa vektorer för x och y
    x = x0:h:x_end;
    y = zeros(size(x));
    y(1) = y0;
    
    % Eulers metod
    for i = 1:length(x)-1
        y(i+1) = y(i) + h * dydx(x(i), y(i));
    end
    
    % Spara och visa värdet av y(4)
    fprintf('För h = %.2f, y(4) = %.4f\n', h, y(end));
    
    % Plotta resultatet
    plot(x, y, 'Color', colors(j), 'LineWidth', 1.5);
    legend_entries{end+1} = sprintf('h = %.2f', h);
end

xlabel('x'); ylabel('y(x)');
title('Eulers metod för olika steglängder');
legend(legend_entries);
grid on;
