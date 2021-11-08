clc;
clear all;
close all;

I=imread('peppers.tiff');
[R, C,Z]=size(I);
if Z==3
    I=rgb2gray(I);
end
I=imresize(I,[512,512]);

H=imhist(I);

[Height, Peak]=max(H);
PixPeak=Peak-1;
I1=I;
for x=1:R
    for y=1:C
        if I(x,y)>PixPeak && I(x,y)<255
            I1(x,y)=I1(x,y)+1;
        end
    end
end
H1=imhist(I1);
figure;imshow(I);title('Original image');
figure;imshow(I1);title('Image After shifting');

%Data Hiding

D=randi([0,1],1,Height);
K=1;
IS=I1;
for x=1:R
    for y=1:C
        if I(x,y)==PixPeak 
            DB=D(1,K);
            if DB==1
                IS(x,y)=IS(x,y)+1;
            end
            K=K+1;
        end
    end
end

figure;imshow(IS,[]);title('Stego Image');



IR=uint8(zeros(R,C));
ED=zeros(1,Height);
K=1;

for x=1:R
    for y=1:C
        if IS(x,y)==PixPeak 
            ED(1,K)=0;
            K=K+1;
        elseif IS(x,y)==(PixPeak+1)
            ED(1,K)=1;
            K=K+1;
        end
   
        
        
        if IS(x,y)<=PixPeak 
            IR(x,y)=IS(x,y);
        end
        
        if IS(x,y)>PixPeak 
            IR(x,y)=IS(x,y)-1;
        end
            
        
    end
end






            

