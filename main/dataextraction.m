clc;
close all;
clear all;
E=imread('man.tiff');
[R,C,Z]=size(E);
H=imhist(E);
[Height, Peak]=max(H);
PixPeak=Peak-1;
IR=uint8(zeros(R,C));
ED=zeros(1,Height);%extracted data
k=1;
for x=1:R
    for y=1:C
        if E(x,y)==PixPeak
            ED(1,K)=0;
            k=k+1;
        elseif E(x,y)==(PixPeak+1)
            ED(1,k)=1;
            k=k+1;
        end
        if E(x,y)<=PixPeak
            IR(x,y)=E(x,y);
        elseif E(x,y) > PixPeak
            IR(x,y)=E(x,y);
        end
    end
end
imshow(IR);title('recovered image');
        
          
            
