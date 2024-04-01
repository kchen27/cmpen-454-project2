load('mocapPoints3D.mat');

load('Parameters_V1.mat');
im1 = imread('im1corrected.jpg');

% Used Pinhole Camera found in Lecture 14 of the slides

% We are given the camera paramters and motion capture points on the person

% Use the model on slide 20 of Lecture 14 and plug the parameters into the 
% matrix.



% Each matrix corresponds to matrix of Pinhole Camera Model
focal_len = Parameters.foclen;

World_to_Camera = [Parameters.Pmat;0, 0, 0, 1];

R_l = transpose(Parameters.Rmat);
K_l = Parameters.Kmat;
R1=Parameters.Pmat(:,1:3);
T1=Parameters.Pmat(:,4);
Camera_loc1 = -transpose(R1) * T1;


% Includes Perspective Projection
Film_plane_to_pixels = [Parameters.Kmat, zeros(3, 1)];





Pixel_location = zeros([3,39]);


for col = 1:size(pts3D, 2)
    % Grab the point from mocapPoints3D
    World_point = [pts3D(:,col);1];
    
    % Convert to 2D
    pix_loc = Film_plane_to_pixels * ...
        World_to_Camera * World_point;

    pix_loc = pix_loc/pix_loc(3);

    % Store it
    Pixel_location(:,col) = pix_loc(1:3);
end




% Now working with image 2



load('Parameters_V2.mat')
im2 = imread('im2corrected.jpg');



focal_len_2 = Parameters.foclen;

World_to_Camera_2 = [Parameters.Pmat;0, 0, 0, 1];


Film_plane_to_pixels_2 = [Parameters.Kmat, zeros(3, 1)];

R_r = transpose(Parameters.Rmat);
K_r = Parameters.Kmat;


R2=Parameters.Pmat(:,1:3);
T2=Parameters.Pmat(:,4);
Camera_loc2 = -transpose(R2) * T2;


Pixel_location2 = zeros([3,39]);


for col = 1:size(pts3D, 2)
    % Grab the point from mocapPoints3D
    World_point = [pts3D(:,col);1];
    
    % Convert to 2D
    pix_loc = Film_plane_to_pixels_2 * ...
        World_to_Camera_2 * World_point;

    pix_loc = pix_loc/pix_loc(3);

    % Store it
    Pixel_location2(:,col) = pix_loc(1:3);
end




% Everything above is task 1



% Everything below is new for task 2

% Answers found in Lecture 15


% disp(T);
% Do Hartley Preconditioning as found in eightpoint.m in class
% This will normalize each pixel location by subtracting from the mean and 
% Dividing by the standard deviation
x1 = Pixel_location(1,:);
y1 = Pixel_location(2,:);
x2 = Pixel_location2(1,:);
y2 = Pixel_location2(2,:);

savx1 = x1; savy1 = y1; savx2 = x2; savy2 = y2;
mux = mean(x1);
muy = mean(y1);
stdxy = (std(x1)+std(y1))/2;
T1 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
nx1 = (x1-mux)/stdxy;
ny1 = (y1-muy)/stdxy;
mux = mean(x2);
muy = mean(y2);
stdxy = (std(x2)+std(y2))/2;
T2 = [1 0 -mux; 0 1 -muy; 0 0 stdxy]/stdxy;
nx2 = (x2-mux)/stdxy;
ny2 = (y2-muy)/stdxy;

A= [];



% Set up a matrix for the eight point algorithm
% There are 39 degrees of freedom
for i = 1:size(Pixel_location2, 2)
    
    A(i,:) = [nx1(i)*nx2(i), nx1(i)*ny2(i), nx1(i), ny1(i)*nx2(i), ny1(i)*ny2(i), ny1(i), nx2(i), ny2(i), 1];
    
end




%get eigenvector associated with smallest eigenvalue of A' * A
[u,d] = eigs(A' * A,1,'SM');
F = reshape(u,3,3);

%make F rank 2
oldF = F;
[U,D,V] = svd(F);
D(3,3) = 0;
F = U * D * V';

%Undo the effects of the Hartley Preconditioning
F = T2' * F * T1;


disp(F);

Pixels1 = Pixel_location;
Pixels2 = Pixel_location2';


epipolarLines = [];
% Multiply the Pixels in image 2 with F to find the epipolar lines for
% image 1
for i=1:size(Pixel_location2,2)
    
    epipolarLines(:, i) = Pixels2(i,:) * F;
end
colors =  'bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmyk';
figure;
imshow(im1);
hold on;
scatter(Pixel_location(1,:), Pixel_location(2,:), 'r', 'filled');

% Plot the epipolar lines
for i = 1:size(epipolarLines, 2)

    a = epipolarLines(1,i);
    b = epipolarLines(2,i);
    c = epipolarLines(3,i);
    
    % This will evaluate the y for each x in the image using the equation
    % of the current epipolar line
    x = 1:size(im1, 2);
    y = (-a * x - c) / b;

    plot(x, y, colors(i));
end

title('Epipolar Lines');
hold off;


% Image 2
% Multiply the Pixels in image 1 with F to find the epipolar lines for
% image 2
epipolarLines = [];
for i=1:size(Pixel_location2,2)
    
    epipolarLines(:, i) = F * Pixels1(:,i);
end

figure;
imshow(im2);
hold on;
scatter(Pixel_location2(1,:), Pixel_location2(2,:), 'r', 'filled');

% Plot the epipolar lines

for i = 1:size(epipolarLines, 2)

    a = epipolarLines(1,i);
    b = epipolarLines(2,i);
    c = epipolarLines(3,i);
    
    % This will evaluate the y for each x in the image using the equation
    % of the current epipolar line
    x = 1:size(im2, 2);
    y = (-a * x - c) / b;

    plot(x, y, colors(i));
end

title('Epipolar Lines');
hold off;