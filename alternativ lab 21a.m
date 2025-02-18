% detta är utan plot

dydx = @(x,y) -((1/6) + (pi * sin(pi*x)) / (1.6 - cos(pi*x))) * y;

x0 = 0;
xn = 4;
y = 2.5;
h = 0.5;

fprintf('%f\n', y);

for x = x0 : h : xn-h
    y = y + h*dydx(x,y);
    x = x + h;
    fprintf('%f\n', y);
end
