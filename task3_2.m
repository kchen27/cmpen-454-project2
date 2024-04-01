%For image 1
% Load the mocapPoints3D.mat and parameters 
load('mocapPoints3D.mat'); 
parameters1 = load('Parameters_V1.mat');
im1 = imread('im1corrected.jpg');

% Film plane to pixels conversion
Kmat = parameters1.Parameters.Kmat;

% World to Camera transformation
Pmat = parameters1.Parameters.Pmat;

% Combine Kmat and Pmat for full camera project matrix
ProjectionMatrix = Kmat * Pmat;

% Initialize matrix for pixel locations
Pixel_location = zeros(3, size(pts3D, 2));

% Project 3D point into 2D pixel coordinates
for col = 1:size(pts3D, 2)
    % Extract the 3D point to homogeneous coordinates
    World_point = [pts3D(:,col); 1];

    % Project the 3D point into 2D using the camera projection matrix
    pix_loc = ProjectionMatrix * World_point;
    pix_loc = pix_loc / pix_loc(3);  % Normalize to convert back to Cartesian coordinates

    % Store the projected 2D point
    Pixel_location(:,col) = pix_loc(1:3);
end

% For image 2
% Load the mocapPoints3D.mat and parameters 
parameters2 = load('Parameters_V2.mat');
im2 = imread('im2corrected.jpg');

% Film plane to pixels conversion
Kmat = parameters2.Parameters.Kmat;

% World to Camera transformation
Pmat = parameters2.Parameters.Pmat;

% Combine Kmat and Pmat for full camera project matrix
ProjectionMatrix = Kmat * Pmat;

% Initialize matrix for pixel locations
Pixel_location = zeros(3, size(pts3D, 2));

% Project 3D point into 2D pixel coordinates
for col = 1:size(pts3D, 2)
    % Extract the 3D point to homogeneous coordinates
    World_point = [pts3D(:,col); 1];

    % Project the 3D point into 2D using the camera projection matrix
    pix_loc = ProjectionMatrix * World_point;
    pix_loc = pix_loc / pix_loc(3);  % Normalize to convert back to Cartesian coordinates

    % Store the projected 2D point
    Pixel_location(:,col) = pix_loc(1:3);
end


% Above are all work from Task 3.1

% Below are all work for Task 3.2


%Calculates the distance between the cameras
T = Camera_loc2 - Camera_loc1;

MSE = 0;
count = 0;
% disp(T);
for col = 1:size(Pixel_location2, 2)
    px1 = Pixel_location(:,col);
    px2 = Pixel_location2(:,col);

    P_l = R_l * inv(K_l) * px1;

    P_r = inv(K_r) * px2;

    Known_Matrix = [P_l, -1 * (R_r*P_r), P_l .* R_r * P_r, T];
    reduced = rref(Known_Matrix);
    a = reduced(1,4);
    b = reduced(2,4);
    c = reduced(3,4);

    line1 = Camera_loc1 + a * P_l;
    line2 = Camera_loc1 + T + b * R_r * P_r;

    World_Guess = (line1 + line2) / 2;

    World_point = pts3D([1:3], col);

    MSE = MSE + norm(World_point - World_Guess) ^ 2;
    count = count + 1;
end

disp("Error in Triangulation");
disp(MSE / count);