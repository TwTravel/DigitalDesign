function bars=histogram(I)
tic
bars=zeros(1,256);
for value=0:255
    bars(value+1)=sum(value==I(:));
end
bars=bars./numel(I);
toc