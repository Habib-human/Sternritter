clc
clear all

%% LOADING THE IMAGE

original_image = imread('bloodcell.jpg');
figure;
subplot(2,2,1);
imshow(original_image);

%% TO GRAYSCALE

grayscaled_image = rgb2gray(original_image);
subplot(2,2,2);
imshow(grayscaled_image)

%% Only showing RED and BLUE CHANNEL

red_channel = original_image(:,:,1);
figure;
subplot(2,2,1);
imshow(red_channel);

subplot(2,2,2);
blue_channel = original_image(:,:,3);
imshow(blue_channel);

%% SEPARATING NEUCLEUS OF WBC 

[W,D]=size(red_channel);
White_cell_count = zeros([W D]);
for i=1:W
   for j=1:D
      if red_channel(i,j)<140
          red_channel(i,j)=255;
          White_cell_count(i,j)=255;
      end
   end
end

WBC_neucleotide = imbinarize(red_channel);
figure'
subplot(2,2,1);
imshow(WBC_neucleotide);
White_cell_count = imopen(White_cell_count, strel('disk',2));
White_cell_count = imclose(White_cell_count, strel('disk',3));
imshow(White_cell_count);
%% SEPARATING RBC 

[W,D]=size(blue_channel);
for i=1:W
   for j=1:D
      if blue_channel(i,j)>175
          blue_channel(i,j)=255;
      end
   end
end

Red_blood_cell_count = imbinarize(blue_channel);
figure;
subplot(2,2,2);
imshow(Red_blood_cell_count);

%% Removal of WBC neucleotide to avoid complications
Only_red_blood_cell = WBC_neucleotide + Red_blood_cell_count;
subplot(2,2,3);
imshow(Only_red_blood_cell);

inverted_only_RBC = ~Only_red_blood_cell;
subplot(2,2,4);
imshow(inverted_only_RBC);

%% Counting the circles 
figure;
imshow(original_image);
hold on;
% Count number of RBC
[rcenters, rradii, rmetric] = imfindcircles(inverted_only_RBC,[8 10],'ObjectPolarity','bright','Sensitivity',0.95,'Method','twostage');
rh = viscircles(rcenters,rradii, 'Color', 'r');

[rm,rn]=size(rcenters);
fprintf('Number of RBC: %d\n', rm) %RBC COUNT

% Count number of WBC
[B,L] = bwboundaries(White_cell_count);
visboundaries(B, 'Color','b');
fprintf('Number of WBC: %d', length(B));%WBC COUNT