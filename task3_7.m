% Read source image based off of planewarpdemo
source = imread('bldg2.jpg'); 
[nr, nc, nb] = size(source);

% Make new image
dest = zeros(nr, nc, nb);

% Get the x-coordinates of the selected points based off of an already
% found corner
xpts = [238.00;  % Top-Left
        292.00;  % Top-Right
        294.00;  % Bottom-Right
        232.00]; % Bottom-Left
ypts = [106.00;  % Top-Left
        126.00;  % Top-Right
        166.00;  % Bottom-Right
        152.00]; % Bottom-Left

% Input rectangle in destination image. code from planewarpdemo
xp1 = 1; yp1 = 1;
xp2 = nc; yp2 = nr;
xprimes = [xp1; xp2; xp2; xp1];  % Get the x coordinates in the output image
yprimes = [yp1; yp1; yp2; yp2];  % Get the x coordinates in the output image

% Compute homography (from im2 to im1 coord system) code from planewarpdemo
p1 = xpts; p2 = ypts;
p3 = xprimes; p4 = yprimes;
vec1 = ones(size(p1,1),1);
vec0 = zeros(size(p1,1),1);
Amat = [p3 p4 vec1 vec0 vec0 vec0 -p1.*p3 -p1.*p4; vec0 vec0 vec0 p3 p4 vec1 -p2.*p3 -p2.*p4];
bvec = [p1; p2];
h = Amat \ bvec;

% Warp im1 forward into im2 coord system code from planewarpdemo
[xx, yy] = meshgrid(1:nc, 1:nr);
denom = h(7)*xx + h(8)*yy + 1;
hxintrp = (h(1)*xx + h(2)*yy + h(3)) ./ denom;
hyintrp = (h(4)*xx + h(5)*yy + h(6)) ./ denom;
for b = 1:nb
    dest(:,:,b) = interp2(double(source(:,:,b)), hxintrp, hyintrp, 'linear') / 255.0;
end

% Display original
figure;
imshow(source);

% Display result
figure;
imshow(dest);
