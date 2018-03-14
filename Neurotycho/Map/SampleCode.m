load('ChibiMAP_bipolar.mat')

figure
image(I);axis equal
hold on
for i=1:64
plot(X(i),Y(i),'ro');
end
hold off