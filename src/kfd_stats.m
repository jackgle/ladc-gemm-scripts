kfdv_BWG = zeros(1,size(fields_BWG,1));
kfdv_C = zeros(1,size(fields_C,1));
kfdv_G = zeros(1,size(fields_G,1));

for i = 1:size(fields_BWG,1)
kfdv_BWG(i) = kfd(click_proc_BWG.(fields_BWG{i}).sig);
end
for i = 1:size(fields_C,1)
kfdv_C(i) = kfd(click_proc_C.(fields_C{i}).sig);
end
for i = 1:size(fields_G,1)
kfdv_G(i) = kfd(click_proc_G.(fields_G{i}).sig);
end

std_kfdBWG = std(kfdv_BWG);
std_kfdC = std(kfdv_C);
std_kfdG = std(kfdv_G);
mean_kfdBWG = mean(kfdv_BWG);
mean_kfdC = mean(kfdv_C);
mean_kfdG = mean(kfdv_G);