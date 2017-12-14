
function showDepthSensorModel(location, orientation, pc, model, pc_new, isUsed)
if ~isUsed
    return ;
end

subplot(2, 3, 4);
pcshow(pc);hold on
plot(model);
plotCamera('Location',zeros(1,3), 'Orientation',eye(3),'Size',60);
xlabel('X_C(mm)');ylabel('Y_C(mm)'); zlabel('Z_C(mm)');
hold off;

subplot(2, 3, 5);
pcshow(pc_new);hold on;
plotCamera('AxesVisible', true, 'Location',location,'Orientation',orientation,'Size',60);
xlabel('X_W(mm)');ylabel('Y_W(mm)'); zlabel('Z_W(mm)');
hold off;
end