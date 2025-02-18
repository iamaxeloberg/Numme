clc, clearvars, close all
function berakna_volym()
    % Huvudfunktion för att beräkna volymen och hitta ny axellängd
    
    L = 4.00; % Ursprunglig axellängd
    N = 10000; % Antal delintervall
    mal_procent = 0.72; % Målvolym som 72% av originalet
    
    % Beräkna ursprunglig volym
    [x, y] = los_diff_ekv(L, N);
    V_original = berakna_volym_trapets(x, y);
    fprintf('Volym för L = %.2f: %.6f\n', L, V_original);
    
    % Hitta ny axellängd
    L_ny = hitta_ny_L(L, N, mal_procent);
    fprintf('Ny axellängd för %.0f%% av volymen: %.6f\n', mal_procent * 100, L_ny);
    
    % Noggrannhetsanalys
    analysera_noggrannhet(L);
end

function [x, y] = los_diff_ekv(L, N)
    % Lös differentialekvationen med Runge-Kutta 4:e ordningen
    
    dydx = @(x, y) -((1/6) + (pi * sin(pi*x)) / (1.6 - cos(pi*x))) * y;
    h = L / N;
    x = linspace(0, L, N+1);
    y = zeros(1, N+1);
    y(1) = 1; % Startvärde
    
    for i = 1:N
        k1 = dydx(x(i), y(i));
        k2 = dydx(x(i) + h/2, y(i) + k1*h/2);
        k3 = dydx(x(i) + h/2, y(i) + k2*h/2);
        k4 = dydx(x(i) + h, y(i) + k3*h);
        y(i+1) = y(i) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
end

function V = berakna_volym_trapets(x, y)
    % Beräkna volym med trapetsregeln
    h = x(2) - x(1);
    integrand = pi * y.^2;
    V = h * (sum(integrand) - 0.5 * (integrand(1) + integrand(end)));
end

function L_ny = hitta_ny_L(L, N, mal_procent)
    % Hitta ny axellängd med sekantmetoden
    
    [x, y] = los_diff_ekv(L, N);
    V_original = berakna_volym_trapets(x, y);
    V_mal = mal_procent * V_original;
    
    L1 = L;
    L2 = 0.9 * L; % Startvärde
    tol = 1e-6;
    max_iter = 100;
    
    for i = 1:max_iter
        [x1, y1] = los_diff_ekv(L1, N);
        V1 = berakna_volym_trapets(x1, y1);
        [x2, y2] = los_diff_ekv(L2, N);
        V2 = berakna_volym_trapets(x2, y2);
        
        L_ny = L2 - (V2 - V_mal) * (L2 - L1) / (V2 - V1);
        if abs(L_ny - L2) < tol
            break;
        end
        L1 = L2;
        L2 = L_ny;
    end
end
    
function analysera_noggrannhet(L)
    % Testa noggrannheten med olika N
    
    N_values = [100, 200, 400, 800, 1600];
    fprintf('\nNoggrannhetsanalys:\n');
    
    for N = N_values
        [x, y] = los_diff_ekv(L, N);
        V = berakna_volym_trapets(x, y);
        fprintf('N = %d, V = %.6f\n', N, V);
    end
end

% Starta programmet
berakna_volym();
