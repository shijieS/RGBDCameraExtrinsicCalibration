function [ ] = showCameraModel( location, orientation, squareSizeInMM, worldPoints )
%showCameraModel show the camera model in 3D space
%   h:   the figure handle
%   location: the camera location
%   orientation: the camera orientation
%   squareSizeInMM: the board size
%   worldPoints:    board point

plotCamera('AxesVisible', true, 'Location', location,'Orientation', orientation,'Size',squareSizeInMM*2);
%cameratoolbar('SetMode','orbit');
hold on
plot3(worldPoints(:, 1), worldPoints(:, 2), zeros(length(worldPoints), 1), '.');
plot3(0,0,0,'g.');
%set(gca,'CameraUpVector',[0 0 -1]); % make the z axis point down
offset = squareSizeInMM*5;
plot3(offset*[1 0 0 0 0],offset*[0 0 1 0 0],...
        offset*[0 0 0 0 1],'b-','linewidth',2);

grid on
axis equal
axis manual
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
xlim([-1000,1000]);
ylim([-500,1500]);
zlim([-1700, 200]);

hold off

end

