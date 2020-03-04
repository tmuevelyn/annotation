clear all 
imds0 = imageDatastore('C:\Users\owner\Desktop\06195089\0','FileExtensions',{'.dcm'});
imds1 = imageDatastore('C:\Users\owner\Desktop\06195089\1','FileExtensions',{'.dcm'});

txt = cell(size(imds0.Files, 1), 5);
txt(1, 1) = cellstr('seriesuid');
txt(1, 2) = cellstr('coordX');
txt(1, 3) = cellstr('coordY');
txt(1, 4) = cellstr('coordZ');
txt(1, 5) = cellstr('diameter_mm');

 for i=1:size(imds0.Files, 1)
    U = dicomread(imds0.Files{i});
    
    V = dicomread(imds1.Files{i});
    info = dicominfo(imds1.Files{i});
    disp('Spacing Between Slices');
    info.SpacingBetweenSlices,
    disp('Series Instance UID');
    txt(i+1, 1) = cellstr(info.SeriesInstanceUID),
    
    U = imresize(U, [info.Width*info.PixelSpacing(1) info.Height*info.PixelSpacing(2)]);
    V = imresize(V, [info.Width*info.PixelSpacing(1) info.Height*info.PixelSpacing(2)]);
    imshowpair (V, U);
    [row,col] = find(U>0);
    
    txt(i+1, 2) = num2cell(0); % coordX
    txt(i+1, 3) = num2cell(0); % coordY
    txt(i+1, 4) = num2cell(i*info.SpacingBetweenSlices); % coordZ
    txt(i+1, 5) = num2cell(0); % diameter_mm
        
    if size(row, 1)>0
        minrow = min(row(:));
        maxrow = max(row(:));
        mincol = min(col(:));
        maxcol = max(col(:));
        y = (maxrow+minrow)/2;
        x = (maxcol+mincol)/2;
        if (maxcol-mincol) > (maxrow-minrow)
            r = (maxcol-mincol)/2;
        else
            r = (maxrow-minrow)/2;
        end
        txt(i+1, 2) = num2cell(x); % coordX
        txt(i+1, 3) = num2cell(y); % coordY
        txt(i+1, 4) = num2cell(i*info.SpacingBetweenSlices); % coordZ
        txt(i+1, 5) = num2cell(r); % diameter_mm
        circle(x, y, r);
        
        saveas(gcf,sprintf('%03d.png', i));
    end
end
xlswrite('annotations.xls', txt);
 
 
function h = circle(x,y,r) 
    d = r*2;
    px = x-r;
    py = y-r;
    h = rectangle('Position',[px py d d],'EdgeColor','w','Curvature',[1,1]);
    %daspect([1,1,1])
end