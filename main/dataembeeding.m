clc;
clear all;
close all;
original_image=imread('color.jpg');
%input original image
original_image=imresize(original_image,[512,512]);
%resize the original image
[R,C,Z]=size(original_image);
%Spiliting the RGB image into 3 planes i.e. red, blue and green planes
red=original_image(:,:,1);
green=original_image(:,:,2);
blue=original_image(:,:,3);
%finding out histogram of the red plain
H=imhist(red);
%finding the peak of histogram
[Height, Peak]=max(H);
PixPeak=Peak-1;
for x=1:R
    for y=1:C
        if red(x,y)>PixPeak && red(x,y)<255
            red(x,y)=red(x,y)+1;
           %incrementing all pixel values by 1 which are greater than
           %pixpeak value
        end
    end
end
Data=randi([0,1],1,Height);
%Data is nothing but the data is to be encoded and is random combination of
%0s and 1s 
K=1;
%using K to traverse "Data" array
for x=1:R
    for y=1:C
        if red(x,y)==PixPeak
            DB=Data(1,K);
            if DB==1
                red(x,y)=red(x,y)+1;
                %if databit ==1 then increment the peakpixek value by one
                %else no change in peakpixel value
            end
        K=K+1;
        end
    end
end
%concatinate all the three planes into 1 single RGB image
Data_image=cat(3,red,green,blue);

subplot(2,2,1); image(original_image);title('Original Image');
subplot(2,2,2); image(Data_image);title('Image with secret data');
%imwrite(Data_image,'Dataimage.bmp');





