function output = wecSimRun(newStiffness, newDamping, newPretension)
%WECSIMRUN Summary of this function goes here
%   Detailed explanation goes here
% Define the WEC-Sim simulation parameters

newStr = strjoin(string({'%% Simulation Data'
'simu = simulationClass();'
'simu.simMechanicsFile = ''RM3.slx'';'
'simu.mode = ''normal'';'                   
'simu.explorer = ''on'';'                  
'simu.startTime = 0;'                    
'simu.rampTime = 100;'                  
'simu.endTime = 400;'                    
'simu.solver = ''ode4'';'                   
'simu.dt = 0.1;' 							
''
%% Wave Information 
% % noWaveCIC, no waves with radiation CIC  
% waves = waveClass('noWaveCIC');       % Initialize Wave Class and Specify Type  

% % Regular Waves  
% 'waves = waveClass(''regular'');'           % Initialize Wave Class and Specify Type                                 
% 'waves.height = 2.5;'                     % Wave Height [m]
% 'waves.period = 8;'                       % Wave Period [s]

% % Regular Waves with CIC
% waves = waveClass('regularCIC');          % Initialize Wave Class and Specify Type                                 
% waves.height = 2.5;                       % Wave Height [m]
% waves.period = 8;                         % Wave Period [s]

% % Irregular Waves using PM Spectrum 
%  waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
%  waves.height = 2.5;                       % Significant Wave Height [m]
%  waves.period = 8;                         % Peak Period [s]
%  waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
%  waves.direction=[0];

% Irregular Waves using JS Spectrum with Equal Energy and Seeded Phase
'waves = waveClass(''irregular'');'           % Initialize Wave Class and Specify Type
'waves.height = 2.5;'                       % Significant Wave Height [m]
'waves.period = 7;'                         % Peak Period [s]
'waves.spectrumType = ''JS'';'                % Specify Wave Spectrum Type
'waves.bem.option = ''EqualEnergy'';'         % Uses EqualEnergy bins (default) 
'waves.phaseSeed = 1;'                      % Phase is seeded so eta is the same

% % Irregular Waves using PM Spectrum with Traditional and State Space 
% waves = waveClass('irregular');           % Initialize Wave Class and Specify Type
% waves.height = 2.5;                       % Significant Wave Height [m]
% waves.period = 8;                         % Peak Period [s]
% waves.spectrumType = 'PM';                % Specify Wave Spectrum Type
% simu.stateSpace = 1;                      % Turn on State Space
% waves.bem.option = 'Traditional';         % Uses 1000 frequnecies

% % Irregular Waves with imported spectrum
% waves = waveClass('spectrumImport');      % Create the Wave Variable and Specify Type
% waves.spectrumFile = 'spectrumData.mat';  % Name of User-Defined Spectrum File [:,2] = [f, Sf]

% % Waves with imported wave elevation time-history  
% waves = waveClass('elevationImport');          % Create the Wave Variable and Specify Type
% waves.elevationFile = 'elevationData.mat';     % Name of User-Defined Time-Series File [:,2] = [time, eta]

%% Body Data\
% Float
'body(1) = bodyClass(''hydroData/rm3.h5'');'      
    % Create the body(1) Variable, Set Location of Hydrodynamic Data File 
    % and Body Number Within this File.   
'body(1).geometryFile = ''geometry/float.stl'';'    % Location of Geomtry File
'body(1).mass = ''equilibrium'';'                   
    % Body Mass. The 'equilibrium' Option Sets it to the Displaced Water 
    % Weight.
'body(1).inertia = [20907301 21306090.66 37085481.11];'  % Moment of Inertia [kg*m^2]     

% Spar/Plate
'body(2) = bodyClass(''hydroData/rm3.h5'');' 
'body(2).geometryFile = ''geometry/plate.stl'';' 
'body(2).mass = ''equilibrium'';'                   
'body(2).inertia = [94419614.57 94407091.24 28542224.82];'

%% PTO and Constraint Parameters
% Floating (3DOF) Joint
'constraint(1) = constraintClass(''Constraint1'');' % Initialize Constraint Class for Constraint1
'constraint(1).location = [0 0 0];'               % Constraint Location [m]

% Translational PTO
'pto(1) = ptoClass(''PTO1'');'                      % Initialize PTO Class for PTO1
'pto(1).stiffness = 0;'                           % PTO Stiffness [N/m]
'pto(1).damping = 1200000;'                       % PTO Damping [N/(m/s)]
'pto(1).pretension = 0;'
'pto(1).location = [0 0 0];'}),'\n');                      % PTO Location [m]"

strRepStiffness = sprintf('pto(1).stiffness = %d;', newStiffness);
newStr = strrep(newStr, 'pto(1).stiffness = 0;', strRepStiffness);

strRepDamping = sprintf('pto(1).damping = %d;', newDamping);
newStr = strrep(newStr, 'pto(1).damping = 1200000;', strRepDamping);

strRepPretension = sprintf('pto(1).pretension = %d;', newPretension);
newStr = strrep(newStr, 'pto(1).pretension = 0;', strRepPretension);

fileID = fopen('/Users/samanthader/Downloads/classes/cit honors research project/GitHub/WEC-Sim/examples/RM3/wecSimInputFile.m', 'w');
fprintf(fileID, newStr);
fclose(fileID);

% % Modify wave properties
% waves = waveClass('regular');     % Initialize the wave class for regular waves
% waves.height = newWaveHeight;     % Set the new wave height [m]
% waves.period = newWavePeriod;     % Set the new wave period [s]
% 
% % Display the modified values
% fprintf('Running WEC-Sim with wave height: %.2f m and wave period: %.2f s\n', waves.height, waves.period);
% 
% Run WEC-Sim
try
     wecSim;  % Run the WEC-Sim simulation (this calls wecSim.m)
catch e
    disp('Error during WEC-Sim simulation:');
    disp(e.message);
end

S = load('/Users/samanthader/Downloads/classes/cit honors research project/GitHub/WEC-Sim/examples/RM3/./output//RM3_matlabWorkspace.mat');
powerArray = S.output.ptos.powerInternalMechanics;
output = 0.1 * abs(sum(powerArray, 'all'));
% output2 = S.waves.power;
fprintf('\npower lost in joint DOF: %d W/m\n', output)

save()
end

% create new file, call this function with different wave parameters
% find a range/increments use linspace
% contour plot for two input values, z output

% figure out what S.waves.power
% github copilot
% find power generated from pto damping

% modify wec

% find most likely wave height and period in northern atlantic and pnw
% 6-8 second period, 2-3 m
% try different stiffness, damping, pretension for one wave state, find
% most optimal
% joint distribution
% JS spectrum jonswap
% different pto types
% what the pto types are
% see what is easily changeable
% bemio nemoh

% keep track of amount of time it takes to run
% save mat?
% checkpoints and save file as date and time

% orders of magnitude
% start bigger then narrow down (find minimum)
% test preload with same magnitude as damping
% read on deep learning in matlab/python
% ewtec abstract due 1/13
    % do sweep over wecsim
    % compare deterministic and surrogate models
    % use deep learning to get approximate values very quickly from
    % surrogate model

% vary stiffness to find potential decrease in power out
% literature: bryony dupont and co-authors
    % see other optimization studies to see what values are useful

% try catch in the loop to save output as "i" and then tries next value
% combination
% get loop into python wrapper, just call from python
% try to do plotting in python too
% lit review: bayesian optimization for wec and other algorithms
    % what people have used, what's popular, what we want to use