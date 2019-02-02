for image_counter=1:6
  clc;close all;clearvars('-except','image_counter');
  img_files = {'IMG_0855.jpg','IMG_0856.jpg','IMG_0857.jpg','IMG_0863.jpg','IMG_0864.jpg','IMG_0865.jpg'};
  img_out_files = {'IMG_0855_out.jpg','IMG_0856_out.jpg','IMG_0857_out.jpg','IMG_0863_out.jpg','IMG_0864_out.jpg','IMG_0865_out.jpg'};  
  img_file = char(img_files(image_counter));
  img_out_file = char(img_out_files(image_counter));



  I = imread(img_file);
  I1 = rgb2gray(I);
  [height, width]=size(I1);
      for k=1:height
          if ((I1(k,j) > 160))
              fg(k,j) = 1;
          else
              fg(k,j) = 0;
          end
      end
  end

  height_30 = 5;
  width_50 = 5;
  op = strel('rectangle',[height_30,height_30]);
  openI = imopen(fg,op);
  se = strel('rectangle',[width_50,width_50]);
  closeI = imclose(openI,se);


  k = 0;
  max_num_X = 0;
  max_place_X = 0;
  x_start_pos = 0;
  x_end_pos = 0;
  X = zeros(width);

  for i = 1:width
    X(i) = sum(closeI(:,i));
    if X(i) >= max_num_X
        max_num_X = X(i);
        max_place_X = i;
    end
    if X(i)>50
        if k == 0
            x_start_pos = i;
            k = 1;
        end
    else 
      if k == 1;
          x_end_pos = i;
          k = 2;
      end
    end
  end
  k = 0;
  X_dis = abs(x_start_pos - x_end_pos);

  max_num_Y = 0;
  max_place_Y = 0;
  y_start_pos = 0;
  y_end_pos = 0;
  Y = zeros(height);
     for i = 1:height
        Y(i) = sum(closeI(i,:));
        if Y(i) >= max_num_Y
        max_num_Y = Y(i);
        max_place_Y = i;
        end
        if Y(i)> 50
            if k == 0
                y_start_pos = i;
                k = 1;
            end
        else 
          if k == 1;
              y_end_pos = i;
              k = 2;
          end
        end
     end
  Y_dis = abs(y_start_pos-y_end_pos);

  YY = 0;
  Y1 = zeros(height);
  XX = 0;
  X1 = zeros(width);
  if (X_dis >= Y_dis)
      dis_start = abs(max_place_X - x_start_pos);
      dis_end = abs(max_place_X - x_end_pos);
      if dis_start > dis_end
          fig_pos_X = x_start_pos;
      else
          fig_pos_X = x_end_pos;
      end
      for i = 1:height
          Y1(i) = sum(closeI(i,fig_pos_X-30:fig_pos_X+30));
          if Y1(i) > 5 && YY == 0
              fig_pos_Y_start = i;
              YY = 1;
          elseif Y1(i)<=5 && YY ==1;
              fig_pos_Y_end = i;
              YY = 2;
              break
          end
      end
      fig_pos_Y = round((fig_pos_Y_start + fig_pos_Y_end)/2);
        
  else    %ÊÖÊú×Å
      dis_start = abs(max_place_Y - y_start_pos);
      dis_end = abs(max_place_Y - y_end_pos);   
      if dis_start > dis_end
          fig_pos_Y = y_start_pos;
      else
          fig_pos_Y = y_end_pos;
      end    
      for i = 1:width
          X1(i) = sum(closeI(fig_pos_Y-30:fig_pos_Y+30,i));
          if X1(i) > 5 && XX == 0
              fig_pos_X_start = i;
              XX = 1;
          elseif X1(i)<=5 && XX ==1;
              fig_pos_X_end = i;
              XX = 2;
              break
          end
      end
      fig_pos_X = round((fig_pos_X_start + fig_pos_X_end)/2);
  end

  for i = 1:10
      for j = 1:10
          closeI(fig_pos_Y-5+j,fig_pos_X-5+i) = 5;
      end
  end
  closeI = closeI * 40;
  image(closeI);
  map = jet;
  imwrite(closeI,map,img_out_file)

end