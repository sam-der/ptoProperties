% Define height and period ranges
height = linspace(1, 8, 7);
period = linspace(2, 12, 10);

% Initialize matrix to store the function outputs
output = zeros(length(height), length(period));

% Loop through height and period values to get the function output
for i = 1:length(height)
    for j = 1:length(period)
        output(i, j) = wecSimRun(height(i), period(j)); % Assuming wecSimRun takes height and period
    end
end

% Create a contour plot
figure()
[H, P] = meshgrid(height, period); % Create a grid for height and period
contour3(H, P, output', 100);       % Transpose output for correct orientation
colorbar;                          % Add a color bar to show the scale of outputs
xlabel('Height (m)');              % Label for x-axis
ylabel('Period (s)');              % Label for y-axis
title('Contour Plot of WEC Simulation Output'); % Title for the plot