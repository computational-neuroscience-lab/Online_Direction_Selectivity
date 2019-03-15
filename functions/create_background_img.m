function background_img = create_background_img(tiff_file)

background_img = std(extract_from_tiff(tiff_file), 0, 3);
background_img = background_img ./ max(background_img(:));