function showColorSensorModel(orientation, location, squareSizeInMM, worldPoints, imagePoints, isUsed)
if ~isUsed
    return ;
end
subplot(2, 3, 1);hold on;
plot(imagePoints(:, 1), imagePoints(:, 2), 'ro');
hold off

subplot(2, 3, 3)
showCameraModel( location, orientation, squareSizeInMM, worldPoints );
end

