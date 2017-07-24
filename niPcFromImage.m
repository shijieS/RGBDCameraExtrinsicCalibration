function [ pc ] = niPcFromImage( imgD )
%niPcFromImage get the point cloud from depth image
%   imgD:       The depth image

% the common parameters
s = size(imgD);
H = s(1);
W = s(2);
xyzPts = zeros(H, W, 3);
s = 1;

% primesense parameter
hFov = deg2rad(45);
vFov = deg2rad(57);
cx = W/2;
cy = H/2;
fx = W/(2*tan(hFov/2));
fy = H/(2*tan(vFov/2));

for r = 1 : H
    for c = 1 : W
        d = double(imgD(r, c))*s;
        if imgD(r, c)==0
            xyzPts(r, c, :) = NaN;
            continue;
        end
        x = (c-cx)/fx*d;
        y = (r-cy)/fy*d;
        z = d;
        xyzPts(r, c, :) = [x y z];
    end
end
pc = pointCloud(xyzPts);
end

