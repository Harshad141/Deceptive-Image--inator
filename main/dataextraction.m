clc;
clear all;
close all;

%Input Stego Image
data_image=imread('Dataimage.bmp');
[R,C,Z]=size(data_image);
%Height and Peak value we need to take input same as the original image
%as they are the keys using which we extract the data and recover the image
Height=4628;
Peak=249;
PixPeak=Peak-1;
%initializing an array "Extracted_data" with all zeros of size == "Height" 
Extracted_data=zeros(1,Height);
%initializing a 2D array "recovered_red" to store the data of red plane after
%data is extracted and to recover the plane
recovered_red=uint8(zeros(R,C));
%dividing the image into 3 different planes
red=data_image(:,:,1);
green=data_image(:,:,2);
blue=data_image(:,:,3);
%operations with red plane as we have embeeded our data into red plane
K=1;
for x=1:R
    for y=1:C
        if red(x,y)==PixPeak
            Extracted_data(1,K)=0;
            %if pixelvalue==peakpixel value then extract 0 as the data bit 
            K=K+1;
        elseif red(x,y)==(PixPeak+1)
            Extracted_data(1,K)=1;
            %if pixelvalue==peakpixel value +1 then extract 1 as the data bit
            K=K+1;
        end
        %append all the data bit values in the array initialized earlier "Extracted_data"
        
        %recovery of the pixel values after data extraction
        if red(x,y) <= PixPeak
            recovered_red(x,y)=red(x,y);
            %if currrent pixelvalue <= peakpixel value then no change in
            %the pixel value
        elseif red(x,y) > PixPeak
            recovered_red(x,y)=red(x,y)-1;
            %if current pixelvalue > peakpixel value than decrement it by 1
        end
    end
end
%concatinate all the three planes into one single recoverd image
recovered_image=cat(3,recovered_red,green,blue);
imshow(recovered_image);
