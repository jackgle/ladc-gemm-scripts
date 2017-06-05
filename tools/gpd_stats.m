gpv_BWG = zeros(1,size(fields_BWG,1));
gpv_C = zeros(1,size(fields_C,1));
gpv_G = zeros(1,size(fields_G,1));

for i = 1:size(fields_BWG,1)
gpv_BWG(i) = corr_dim(click_proc_BWG.(fields_BWG{i}).sig,3);
end
for i = 1:size(fields_C,1)
gpv_C(i) = corr_dim(click_proc_C.(fields_C{i}).sig,3);
end
for i = 1:size(fields_G,1)
gpv_G(i) = corr_dim(click_proc_G.(fields_G{i}).sig,3);
end

std_gpBWG = std(gpv_BWG);
std_gpC = std(gpv_C);
std_gpG = std(gpv_G);
mean_gpBWG = mean(gpv_BWG);
mean_gpC = mean(gpv_C);
mean_gpG = mean(gpv_G);