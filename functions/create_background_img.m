function background_img = create_background_img(img)

background_img = std(img, 0, 3);
background_img = background_img ./ max(background_img(:));