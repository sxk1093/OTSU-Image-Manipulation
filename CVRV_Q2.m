dom = imread('dom.jpg');
gaus = imnoise(dom, 'gaussian',0.3,0.5);
salpep = imnoise(dom, 'salt & pepper',0.075);
speckle = imnoise(dom, 'speckle');

dom = rgb2gray(dom);
gaus = rgb2gray(gaus);
salpep = rgb2gray(salpep);
speckle = rgb2gray(speckle);

figure;
subplot(2,2,1);
imshow(dom)
title('original image')
subplot(2,2,2);
imshow(gaus)
title('Gaussian noise')
subplot(2,2,3);
imshow(salpep)
title('Salt&Pepper noise')
subplot(2,2,4);
imshow(speckle)
title('Speckle noise')
figure;


%average filters
I = gaus;
[x,y] = size(I);
for i = 2:x-1
    for j = 2:y-1
        sum = 0;
        sum=int32(sum);
        for ii = i-1:i+1  
            for jj = j-1:j+1
                tmp=I(ii,jj);
                tmp=int32(tmp);
                sum = sum + tmp;
                sum=int32(sum);
            end
        end
        I2(i,j) = ceil(sum/9);
    end
end
mean_gaus = uint8(I2);



I = salpep;
[x,y] = size(I);
for i = 2:x-1
    for j = 2:y-1
        sum = 0;
        sum=int32(sum);
        for ii = i-1:i+1  
            for jj = j-1:j+1
                tmp=I(ii,jj);
                tmp=int32(tmp);
                sum = sum + tmp;
                sum=int32(sum);
            end
        end
        I2(i,j) = ceil(sum/9);
    end
end
mean_salpep = uint8(I2);


%median filters
A = gaus;
modifyA=zeros(size(A)+4);
B=zeros(size(A));

        for x=1:size(A,1)
            for y=1:size(A,2)
                modifyA(x+1,y+1)=A(x,y);
            end
        end
       
for i= 1:size(modifyA,1)-2
    for j=1:size(modifyA,2)-2
        window=zeros(9,1);
        inc=1;
        for x=1:3
            for y=1:3
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        med=sort(window);
        B(i,j)=med(5);
       
    end
end

median_gaus=uint8(B);

for i= 1:size(modifyA,1)-4
    for j=1:size(modifyA,2)-4
        window=zeros(1,9);
        inc=1;
        for x=1:5
            for y=1:5
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        B(i,j)=min(window);
   
    end
end

min_gaus=uint8(B);

for i= 1:size(modifyA,1)-4
    for j=1:size(modifyA,2)-4
        window=zeros(1,9);
        inc=1;
        for x=1:5
            for y=1:5
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        B(i,j)=max(window);
   
    end
end

max_gaus=uint8(B);

A = salpep;
modifyA=zeros(size(A)+4);
B=zeros(size(A));

        for x=1:size(A,1)
            for y=1:size(A,2)
                modifyA(x+1,y+1)=A(x,y);
            end
        end
        
for i= 1:size(modifyA,1)-2
    for j=1:size(modifyA,2)-2
        window=zeros(9,1);
        inc=1;
        for x=1:3
            for y=1:3
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        med=sort(window);
        B(i,j)=med(5);
       
    end
end

median_salpep=uint8(B);

%max/min filters
for i= 1:size(modifyA,1)-4
    for j=1:size(modifyA,2)-4
        window=zeros(1,9);
        inc=1;
        for x=1:5
            for y=1:5
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        B(i,j)=min(window);
   
    end
end

min_salpep=uint8(B);

for i= 1:size(modifyA,1)-4
    for j=1:size(modifyA,2)-4
        window=zeros(1,9);
        inc=1;
        for x=1:5
            for y=1:5
                window(inc)=modifyA(i+x-1,j+y-1);
                inc=inc+1;
            end
        end
        B(i,j)=max(window);
   
    end
end

max_salpep=uint8(B);


%figure;
subplot(2,5,1);
imshow(gaus)
title('Image with Gaussian noise')
subplot(2,5,2);
imshow(min_gaus)
title('Gaussian noise 5x5 min filter')
subplot(2,5,3);
imshow(max_gaus)
title('Gaussian noise 5x5 max filter')
subplot(2,5,4);
imshow(mean_gaus)
title('Gaussian noise 5x5 mean filter')
subplot(2,5,5);
imshow(median_gaus)
title('Gaussian noise 5x5 median filter')
subplot(2,5,6);
imshow(salpep)
title('Image with Salt&Pepper noise')
subplot(2,5,7);
imshow(min_salpep)
title('Salt&Pepper noise 5x5 min filter')
subplot(2,5,8);
imshow(max_salpep)
title('Salt&Pepper noise 5x5 max filter')
subplot(2,5,9);
imshow(mean_salpep)
title('Salt&Pepper noise 5x5 mean filter')
subplot(2,5,10);
imshow(median_salpep)
title('Salt&Pepper noise 5x5 median filter')
figure;


% Feature Extraction
origPoints = detectSURFFeatures(salpep);
[origFeatures, origPoints] = extractFeatures(salpep, origPoints);

% Salpep + mean
meanPoints = detectSURFFeatures(mean_salpep);
[meanFeatures, meanPoints] = extractFeatures(mean_salpep, meanPoints);

meanPairs = matchFeatures(origFeatures, meanFeatures);
matchedOrigPoints = origPoints(meanPairs(:, 1), :);
matchedMeanPoints = meanPoints(meanPairs(:, 2), :);
showMatchedFeatures(salpep, mean_salpep, matchedOrigPoints, ...
    matchedMeanPoints, 'montage');
title('Feature matching: mean filter');

% Salpep + median
medPoints = detectSURFFeatures(median_salpep);
[medFeatures, medPoints] = extractFeatures(median_salpep, medPoints);

medPairs = matchFeatures(origFeatures, medFeatures);
matchedOrigPoints = origPoints(medPairs(:, 1), :);
matchedMedPoints = medPoints(medPairs(:, 2), :);
figure;
showMatchedFeatures(salpep, median_salpep, matchedOrigPoints, ...
    matchedMedPoints, 'montage');
title('Feature matching: median filter');

% Salpep + min
minPoints = detectSURFFeatures(min_salpep);
[minFeatures, minPoints] = extractFeatures(min_salpep, minPoints);

minPairs = matchFeatures(origFeatures, minFeatures);
matchedOrigPoints = origPoints(minPairs(:, 1), :);
matchedMinPoints = minPoints(minPairs(:, 2), :);
figure;
showMatchedFeatures(salpep, min_salpep, matchedOrigPoints, ...
    matchedMinPoints, 'montage');
title('Feature matching: min filter');

% Salpep + max
maxPoints = detectSURFFeatures(max_salpep);
[maxFeatures, maxPoints] = extractFeatures(max_salpep, maxPoints);

maxPairs = matchFeatures(origFeatures, maxFeatures);
matchedOrigPoints = origPoints(maxPairs(:, 1), :);
matchedMaxPoints = maxPoints(maxPairs(:, 2), :);
figure;
showMatchedFeatures(salpep, max_salpep, matchedOrigPoints, ...
    matchedMaxPoints, 'montage');
title('Feature matching: max filter');

