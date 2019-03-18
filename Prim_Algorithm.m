clear all;
clc;

%% I-Inputs section.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                Please select your Data Type                                                  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Asking User to Select Data Type.                                                                                                   %
Data_Type = questdlg('Which Data do you want to use?','Data Selection','Simple','Moderate','Complex','Simple');                      %
switch Data_Type                                                                                                                     %
    case 'Simple'                                                                                                                    %
    % Simple                                                                                                                         %
    fileName = ('Simple.txt');                                                      % File name.                                     %
                                                                                                                                     %
    case 'Moderate'                                                                                                                  %
    % Moderate                                                                                                                       %
    fileName = ('Moderate.txt');                                                    % File name.                                     %
                                                                                                                                     %
    case 'Complex'                                                                                                                   %
    % Complex                                                                                                                        %
    fileName = ('Complex.txt');                                                     % File name.                                     %
end                                                                                                                                  %
                                                                                                                                     %
% Opening & Reading Data From File.                                                                                                  %
file = fopen(fileName, 'r');                                                        % Input File.                                    %
                                                                                                                                     %
if file == -1                                                                       % Condition to Check the File Existance.         %
    display('Error in Reading File, can not find the file.');                       % Error Message that the File was not Found.     %
else                                                                                                                                 %
    N = fscanf(file, '%d', 1);                                                      % Order of Matrix.                               %
    M = fscanf(file, '%d', [N N]);                                                  % Redaing Matrix.                                %
    fclose(file);                                                                   % Close File.                                    %
    M = M';                                                                         % Transpoze to match the Orientation.            %
    O = M;                                                                          % Original Matrix.                               %
end                                                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% II- Modifying the Input Matrix.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                        Replacing any Zero With Infinity and Checking that No Loops Are Found                                 %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested Loops with Condition for Modification.                                                                                      %          
for i = 1:N                                                                                                                          %
    for j = 1:N                                                                                                                      %
        if i ~= j                                                                                                                    %
            if M(i, j) == 0                                                                                                          %
                M(i, j) = inf;                                                                                                       %
            end                                                                                                                      %                                                                                                      %
        elseif i == j && M(i, j) ~= 0                                               % Checking Looping. Redundant Condition in if.   %                                                                           %
                M(i, j) = 0;                                                                                                         %
        end                                                                                                                          %
    end                                                                                                                              %
end                                                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% III- Calculating Elements, Weight and Vertices For Calculating MST.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                             Initiate Elements, Weight and Vertices Vectors and Calculating MST                               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating Elements and Values Vectors (Minimum Spanning Tree).                                                                      %
A   = M;                                                                            % Copying Original Matrix.                       %
V   = [];                                                                           % Create Vertices Vector.                        %
V(1)= 4;                                                                            % Initiate First Element in Vector.              %
W   = [];                                                                           % Initate Weight Vector.                         %
E1  = [];                                                                           % Initiate Starting Edge Vector.                 %
E2  = [];                                                                           % Initiate Ending Edge Vector.                   %
F   = false(1, N);                                                                  % Creating Flag Vector.                          %
k = 1;                                                                              % Counter.                                       %
                                                                                                                                     %
% Calculation Loop.                                                                                                                  %
while length(W) < N - 1                                                             % Terminate after we have N - 1 Connections.     %
    L   = V(k);                                                                     % Key Needed in Accessing Rows.                  %
    Min = inf;                                                                      % Initiating Minimum by Infinity.                %
    for i = k : -1 : 1                                                              % Loop for Calculating The Minimum in Prev. Rows.%
        L = V(i);                                                                   % Updating the Key.                              %
        for j = 1 : N                                                               % Looping for Colomns.                           %
            if A(L ,j) ~= 0 && A(L ,j) ~= inf && A(L ,j) < Min && F(j) == false     % Calculating Min. Regarding (0, inf., Flags).   %
                Min     =   A(L, j);                                                % Updating Minimun.                              %
                W(k)    = A(L, j);                                                  % Updating the Weights Vector.                   %
                E1(k)   = L;                                                        % Updating Starting Edge Vector.                 %
                E2(k)   = j;                                                        % Updating Ending Edge Vector.                   %
            end                                                                                                                      %
        end                                                                                                                          %
    end                                                                                                                              %
    L = V(k);                                                                       % Updating the Key Needed in Accessing Rows.     %
    if k == 1                                                                       % Needed to set the Flag for First Element.      %
        F(L) = true;                                                                % Updating the Flag of First Element.            %
    end                                                                                                                              % 
    A(L, E2(k))   = 0;                                                              % Deleting Value Found to ease the Comp. (Row 1) %
    A(E2(k), L)   = 0;                                                              % Deleting Value Found to ease the Comp. (Row 2) %
    F(E2(k))      = true;                                                           % Updating Flag.                                 %
    V(k + 1)      = E2(k);                                                          % Updating Vertices Vector.                      %
    k = k + 1;                                                                      % Increment the Counter.                         %
end                                                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% IV - Plotting The Graphs. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                              Plotting the Graph Before and After MST                                         %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting Graph Before MST.                                                                                                         %
G   = M;                                                                            % Creating New Matrix to preform new opperations.%
X   = randperm(15,N);                                                               % Creating Random X Cooridante Points.           %
Y   = randperm(15,N);                                                               % Creating Random Y Cooridante Points.           %
Co  = [X' Y'];                                                                      % Creating the Coordinate Matrix.                %
                                                                                                                                     %
% Creating the Connection Matrix (Only Contains Zeros & Ones).                                                                       %                                                                                                                                     
for i = 1 : N                                                                                                                        %
    for j = 1 : N                                                                                                                    %
        if G(i, j) ~= 0 && G(i, j) ~= inf                                           % Updating any Number than 0 & INF. With One.    %
            G(i, j) = 1;                                                            % Updating Process.                              %
        elseif G(i, j) == inf                                                       % Condition for Updating any Infinity with Zero. %
            G(i, j) = 0;                                                            % Updating Process.                              %
        end                                                                                                                          %
    end                                                                                                                              %
end                                                                                                                                  %
                                                                                                                                     %
% Plotting The Initial Graph.                                                                                                        %
figure('Name','Graph before applying Prim Algorithm.');                             % Creating Figure.                               %
gplot(G,Co, '-*');                                                                  % Plotting.                                      %
title('Graph');                                                                     % Title.                                         %
                                                                                                                                     %
% Plotting MST Graph.                                                                                                                %
G = zeros(N,N);                                                                     % Creating New Zero Matrix .                     %
                                                                                                                                     %
% Creating the Connection Matrix for MST (Only Contains Zeros & Ones).                                                               %
for i = 1 : N - 1                                                                                                                    %             
    G(E1(i), E2(i)) = 1;                                                            % Setting Least Destination between Points.      %
end                                                                                                                                  %
                                                                                                                                     %
% Plotting The Initial Graph.                                                                                                        %
figure('Name','Graph after applying Prim Algorithm.');                              % Creating Figure.                               %
gplot(G,Co, '-*');                                                                  % Plotting.                                      %
title('MST - Prim Algorithm.');                                                     % Title.                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% V - Output The Data On A File. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                                                    Export Data on Text File                                                  %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open File And Exporting the Data.                                                                                                  %
file = fopen('Results.txt', 'w');                                                   % Open File.                                     %
                                                                                                                                     %
% Printing Original Matrix.                                                                                                          %
fprintf(file,'Original Matrix:\r\n\r\n');                                                                                            %
for i = 1 : N                                                                                                                        %
    for j = 1 : N                                                                                                                    %
        fprintf(file,'\t%-3d', O(i, j));                                            % Printing Elements in the Original Matrix.      %
    end                                                                                                                              %
    fprintf(file, '\r\n');                                                          % New Line.                                      %
end                                                                                                                                  %
                                                                                                                                     %
% Printing Modified Matrix.                                                                                                          %
fprintf(file,'\r\nDistance Modified Matrix:\r\n\r\n');                                                                               %
for i = 1 : N                                                                                                                        %
    for j = 1 : N                                                                                                                    %
        fprintf(file,'\t%-3d', M(i, j));                                            % Printing Elements in the Modified Matrix.      %
    end                                                                                                                              %
    fprintf(file, '\r\n');                                                                                                           %
end                                                                                                                                  %
                                                                                                                                     %
% Printing Distances, Sources and Destinations.                                                                                      %
fprintf(file,'\r\nThe Nodes and Shortest Distances Are:\r\n');                                                                       %
fprintf(file,'FORMAT: Distance (Source, Desitnation).\r\n');                                                                         %
for i = 1 : N - 1                                                                                                                    %
    fprintf(file,'%d (%d, %d)\r\n', W(i), E1(i), E2(i));                                                                             %
end                                                                                                                                  %
fclose(file);                                                                       % Close File.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;