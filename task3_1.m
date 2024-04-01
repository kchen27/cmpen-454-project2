load('mocapPoints3D.mat');

parameters1 = load('Parameters_V1.mat');
im1 = imread('im1corrected.jpg');

% Each matrix corresponds to matrix of Pinhole Camera
focal_len = parameters1.Parameters.foclen;

World_to_Camera = [parameters1.Parameters.Pmat; 0, 0, 0, 1];

% Perspective Project
Film_plane_to_pixels = [parameters1.Parameters.Kmat, zeros(3, 1)];

Pixel_location = zeros([3,39]);

for col = 1:size(pts3D, 2)
    % Grab point from mocapPoints3D
    World_point = [pts3D(:,col);1];

    % Convert to 2D
    pix_loc = Film_plane_to_pixels * ...
        World_to_Camera * World_point;
    pix_loc = pix_loc/pix_loc(3);

    Pixel_location(:,col) = pix_loc([1:3]);
end

figure;
imshow(im1);
hold on;
scatter(Pixel_location(1,:), Pixel_location(2,:),'r','filled');
hold off;