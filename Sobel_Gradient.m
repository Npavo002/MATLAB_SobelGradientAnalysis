Image=imread('POS3_O2_S27.lif_RS_O2_ch02.tif');
Image2=flipud(Image);
J = im2uint8(Image2); 
Maska = (J>20); %Mask made through matlab with a threshold over 20
Maska = imfill(Maska, 'holes'); %Fill in holes in mask
Maskb=im2double(Maska);
I1 = double(J); %convert interger to double
I2 = I1.*cast(Maskb,class(I1)); %multiply
ROI = J;
ROI(Maskb == 0) = 0;


I2(I2 == 0) = NaN; %changes all pixels of 0 intensity to NaN to stop them from forming quivers
MP = max(I2(:)); %Identify max pixel intensity for normalizing data
I3 = I2/MP; %Normalize data to 1
%numberOfPixels = numel(J); %Counts all pixels in the image
PixelGradient = sum(I3,2)/1024
figure(1)
plot(PixelGradient)
set(gca,'XDir','reverse');


[m,n] = size(I3);
[u,v] = imgradientxy(I3,'sobel'); %calculate integer to double


%[Gx,Gy] = imgradient(I2,'sobel')
[Gmag,Gdir] = imgradient(I3,'sobel'); %Gdir finds angle between -180-180

[y,x] = ndgrid(1:m,1:n); %x,y grid
ind = find( abs(u) > 0 & abs(v) > 0); %Use only if you want to plot quivers for pixels above a certain intensity
ii = ind(1:1:numel(ind));

%mean of u and v
mu = mean(u,'all','omitnan')
mv = mean(v,'all','omitnan')

%sum of u and v
su = sum(u,'all','omitnan')
sv = sum(v,'all','omitnan')


PC = length(u(~isnan(u))); %Count of all pixels being used in calculations. Here we use the 'u' direction as our filter to find all relevant pixels
SumMag = sum(Gmag,'all','omitnan');
NormalizedMag = SumMag/PC
MeanMag = mean(Gmag,'all','omitnan')


GradientDirection = atan2(sv,su) %Answer is in Radians and needs to be converted to degrees. We use atan2 because it returns the four quadrant inverse tangent(tan^-1) of Y and X.
GradientAngle = rad2deg(GradientDirection) 

%flipud if not matching up
imshow(ROI);
hp = impixelinfo;
set(hp,'position', [5 1 300 20]);
hold on
%plot(520,520, 'r+', 'Markersize', 1, 'LineWidth', 3);
quiver(x,y,u,v,'color', [0 0 1],'linewidth',2);
set(gca,'YDir','normal');
axis on
hold off

figure;quiver(0,0,mu,mv,'color', [0 0 1],'linewidth',3);
if abs(mv) > abs(mu)
    set(gca,'XLim',[-abs(mv) abs(mv)]);
set(gca,'YLim',[-abs(mv) abs(mv)]);
set(gca,'YDir','normal');
else
    set(gca,'XLim',[-abs(mu) abs(mu)]);
set(gca,'YLim',[-abs(mu) abs(mu)]);
set(gca,'YDir','normal');
end
hold on
plot(0,0, 'r+', 'Markersize', 1, 'LineWidth', 3);