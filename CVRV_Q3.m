% QUESTION 3.1
cells = imread('cells.png');
bwcells = rgb2gray(cells);
[thresh, EM] = graythresh(bwcells);
BW = imbinarize(bwcells, thresh);
%imshow(BW), title('ONLY GRAYTHRESH');

%trying with multithresh
[thresh2, EM2] = multithresh(cells);
BW2 = imquantize(bwcells, thresh2);
%imshow(BW2, []), title('ONLY MULTITHRESH');

%trying with imadjust
cells_cont = imadjust(cells, [0.19 0.2]);
%imshow(cells_cont), title('ONLY CONTRAST');

%trying with imadjust + graythresh
[thresh3, EM3] = graythresh(cells_cont);
bw_cont = rgb2gray(cells_cont);
BW3 = imbinarize(bw_cont, thresh3);

%trying with KMEANS
lab_cells = rgb2lab(cells);
ab = lab_cells(:,:,2:3);
ab = im2single(ab);
nColors = 2;
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
mask1 = pixel_labels==1;
cluster1 = cells_cont .* uint8(mask1);
mask2 = pixel_labels==2;
cluster2 = cells_cont .* uint8(mask2);

figure;
subplot(1,3,1);
imshow(BW),title('OTSU''s method')
subplot(1,3,2);
imshow(cells_cont),title('Contrast using imadjust')
subplot(1,3,3);
imshow(cluster2),title('Clustering using k-means')
figure;


% QUESTION 3.2
I = bw_cont;
[~,threshold] = edge(I,'sobel');
fudgeFactor = 1;
BWs = edge(I,'sobel',threshold * fudgeFactor);
se90 = strel('line',4,90);
se0 = strel('line',4,0);
BWsdil = imdilate(BWs,[se90 se0]);
BWdfill = imfill(BWsdil,'holes');
seD = strel('diamond',2);
BWfinal = imerode(BWdfill,seD);
%imshow(BWfinal)


% QUESTION 3.3.1
stats = regionprops('table',BW,'Area')
avg_area = mean([stats.Area]);
std_dev_area = std([stats.Area]);
imshow(labeloverlay(cells,BWfinal)), title('Final mask over the original image');
disp(avg_area);
disp(std_dev_area);

%writematrix(stats.Area, 'individual areas (Q3 3 1)');

lb = bwlabel(BW);
stats2 = regionprops('table',BW,lb,'MeanIntensity')
avg_brightness = mean([stats2.MeanIntensity]);
std_dev_brightness = std([stats2.MeanIntensity]);
disp(avg_brightness);
disp(std_dev_brightness);

%writematrix(stats2.MeanIntensity, 'individual mean brightness (Q3 3 2)');


