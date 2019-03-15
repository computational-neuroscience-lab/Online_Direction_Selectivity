function output_matrix = extractTiffData(input_file)

input_file = char(input_file);

stack_info = imfinfo(input_file);
stack_w = stack_info(1).Width;
stack_h = stack_info(1).Height;
stack_n = length(stack_info);

output_matrix = zeros(stack_h, stack_w, stack_n, 'double');

TifLink = Tiff(input_file, 'r');
for i = 1:stack_n
   TifLink.setDirectory(i);
   output_matrix(:,:,i) = TifLink.read();
end
TifLink.close();

