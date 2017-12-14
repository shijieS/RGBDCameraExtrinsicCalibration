function showError(B, C)
subplot(2, 3, 6);
D = abs(B - C);
x = 1:size(D, 1);
y1 = D(:, 1);
y2 = D(:, 2);
y3 = D(:, 3);
plot(x, y1, 'r-', x, y2, 'g-', x, y3, 'b-');
legend('\Delta\theta', '\Delta\phi', '\Delta H');
end