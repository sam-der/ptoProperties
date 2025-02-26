function [output] = ptoProperties(SDP) %function pto_out = ptoProperties(SDP) (SDP: array)

S = SDP{1};
D = SDP{2};
P = SDP{3};

% Initialize matrix to store the function outputs

% stiff = linspace(double(sMin), double(sMax), double(numS));
% damp = linspace(double(dMin), double(dMax), double(numD));
% pre = linspace(double(pMin), double(pMax), double(numP));

% output = zeros(length(stiff), length(damp), length(pre));

% Loop through height and period values to get the function output
% for i = 1:length(stiff)
%     for j = 1:length(damp)
%         for k = 1:length(pre)
try
output = wecSimRun(S, D, P); % store single output value, rewrite as S, D, P
catch ME
    if contains(ME.message, 'There may be a singularity in the solution')
        fprintf(['Simulation failed at stiffness = %g, damping = %g, pretension = %g:\n', ...
                 'Singularity or solver issue detected. Adjust step size or tolerances.\n\n'], ...
                 S, D, P); % update variables
    else
        % Log other types of errors
        fprintf(['Simulation failed at stiffness = %g, damping = %g, pretension = %g:\n%s\n\n'], ...
                 S, D, P, ME.message); % update variables
    end
    output = NaN;
 end
%         end
%     end
% end

% Create a grid for the scatter plot
% [S, D, P] = meshgrid(stiff, damp, pre); % 3D grid
% 
% % Flatten all inputs and outputs for scatter3
% S = S(:); % Flatten S
% D = D(:); % Flatten D
% P = P(:); % Flatten P
% output_flat = output(:); % Flatten output
% 
% % Scatter plot
% figure();
% scatter3(S, D, P, 100, output_flat, 'filled'); % Color-coded scatter plot
% colorbar; % Add a color bar to show the scale of outputs
% xlabel('Stiffness'); ylabel('Damping'); zlabel('Preload');
% title('Scatter Plot of WEC Simulation Output');
% 
% minVal = min(output_flat);
% maxVal = max(output_flat);
end