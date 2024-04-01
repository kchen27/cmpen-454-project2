% Load both camera parameters
V1 = load('Parameters_V1.mat');
V2 = load('Parameters_V2.mat');

% Get the nested parameters for both cameras
paramV1 = V1.Parameters;
paramV2 = V2.Parameters;

% Get the K values for both cameras
Kmat1 = paramV1.Kmat;
Kmat2 = paramV2.Kmat;

% Get the rotation and position values for both cameras
R1 = paramV1.Rmat;
T1 = paramV1.position;
R2 = paramV2.Rmat;
T2 = paramV2.position;

% Make sure the position values are column vectors
if isrow(T1)
    T1 = T1';
end
if isrow(T2)
    T2 = T2';
end

% Get the relative rotation and relative positions of the cameras
R_rel = R2 * R1';
T_rel = T2 - R_rel * T1;

% Get the Essential matrix using the skew-symmetric matrix function
E = R_rel * skewSymmetric(T_rel);

% Get the Fundamental matrix
F = inv(Kmat2)' * E * inv(Kmat1);

% Display the Fundamental matrix
disp('Fundamental matrix F:');
disp(F);

% Create a skew-symmetric matrix from a vector
function S = skewSymmetric(v)
    S = [  0   -v(3)  v(2);
           v(3)  0   -v(1);
          -v(2)  v(1)   0 ];
end
