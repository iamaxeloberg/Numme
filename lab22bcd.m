clear; clc; close all;

% # delintervall
N0 = 400;

% l=4.00 strandard
L_ref = 4.00;
[V_ref, ~] = volym_lur(L_ref, N0);
targetVolume = 0.72 * V_ref;

% målfuktionen
f_mal = @(L) volym_lur(L, N0) - targetVolume;

% start giss
L0 = 2.5;
L1 = 4.0;

tol = 1e-6;
maxIter = 100;
iter = 0;

while abs(L1 - L0) > tol && iter < maxIter
    f0 = f_mal(L0);
    f1 = f_mal(L1);
    
    % sek formel
    L_new = L1 - f1 * (L1 - L0) / (f1 - f0);
    
    % ny giss
    L0 = L1;
    L1 = L_new;
    
    iter = iter + 1;
end

function [V_extrap, fel] = volym_lur(L, N)

    x0 = 0;
    y0 = 2.5;
    
    %steg
    h1 = L / N;
    h2 = L / (2 * N);
    
    [x1, y1] = rk4(@f_ode, x0, y0, h1, L);
    [x2, y2] = rk4(@f_ode, x0, y0, h2, L);
    
    % vol
    V1 = pi * trapregel(x1, y1.^2);
    V2 = pi * trapregel(x2, y2.^2);
    
    % richard
    V_extrap = V2 + (V2 - V1) / 3;
    
    fel = abs(V_extrap - V2);
end

% rk4
function dydx = f_ode(x, y)
    dydx = - (1/6 + (pi*sin(pi*x))/(1.6 - cos(pi*x))) * y;
end

function [x, y] = rk4(f, x0, y0, h, L)
    x = x0:h:L;
    M = length(x);
    y = zeros(1, M);
    y(1) = y0;
    for i = 1:M-1
        k1 = f(x(i), y(i));
        k2 = f(x(i) + h/2, y(i) + h*k1/2);
        k3 = f(x(i) + h/2, y(i) + h*k2/2);
        k4 = f(x(i) + h, y(i) + h*k3);
        y(i+1) = y(i) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
end

function I = trapregel(x, f_var) % f värde
dx = diff(x); % diff närliggande xvärden
%medel av närliggande fvärden
avg_f = (f_var(1:end-1) + f_var(2:end)) / 2;
% tot
I = sum(dx .* avg_f);
end

disp(['72% L = ', num2str(L1, '%.4f')]);
disp([' vol = ', num2str(volym_lur(L1, N0), '%.4f')]);

%  kontukurva 40 punkter.
N_plot = 40;
[x_plot, y_plot] = rk4(@f_ode, 0, 2.5, L1/N_plot, L1);

%gör kolumnvektorer
x_plot = x_plot(:);
f_plot = y_plot(:);

%  fi 
fi = 0:2*pi/30:2*pi;

X = x_plot * ones(1, length(fi));
Y = f_plot * cos(fi);
Z = f_plot * sin(fi);

figure;
surf(X, Y, Z);
