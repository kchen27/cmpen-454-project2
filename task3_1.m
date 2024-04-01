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

% Visualize the projected 2D points on the image
figure;
imshow(im1);
hold on;
scatter(Pixel_location(1,:), Pixel_location(2,:), 'r', 'filled');
hold off;

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

% Visualize the projected 2D points on the image
figure;
imshow(im2);
hold on;
scatter(Pixel_location(1,:), Pixel_location(2,:), 'r', 'filled');
hold off;