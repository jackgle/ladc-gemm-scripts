function view_struct_v1( click_struct )

% This function plots extracts in a 4x4 grid with the ability to advance
% the plotted frames using the left and right arrow keys. This version is
% for the outdated click structure format which holds frames in distinct
% fields.

fields = fieldnames(click_struct);


i=1;
j=1;
clf;
while(1)
    if i == 1
        for j = 1:4
            if (i-1)+j > size(fields,1)
                break;
            end
            fields{(i-1)+j} = char(fields((i-1)+j));
            subplot(2,2,j);
            plot(click_struct.(fields{(i-1)+j}).time_win,click_struct.(fields{(i-1)+j}).sig);
            axis tight
            title(fields{(i-1)+j},'FontSize',14);
            xlabel('Sample');
        end
    else
        k = waitforbuttonpress;
        switch k
            case 1
                key = get(k,'currentcharacter');
                modifier = get(k,'currentModifier');
                switch key
                    case 28
                        if i<9
                            continue;
                        end
                        i = i - 8;
                        for j = 1:4
                            subplot(2,2,j);
                            plot(click_struct.(fields{(i-1)+j}).time_win,click_struct.(fields{(i-1)+j}).sig);
                            axis tight
                            title(fields{(i-1)+j},'FontSize',14);
                            xlabel('Sample')
                        end
                    case 29
                        if ((i-1)+j) > size(fields,1) && mod(size(fields,1),4)==0
                            continue;
                        end
                        if  i > size(fields,1)
                            continue;
                        end
                        if ((i-1)+j) > size(fields,1)-4
                            clf;
                        end
                        for j = 1:4
                            if ((i-1)+j) > size(fields,1)
                                break;
                            end
                            subplot(2,2,j);
                            plot(click_struct.(fields{(i-1)+j}).time_win,click_struct.(fields{(i-1)+j}).sig);
                            axis tight
                            title(fields{(i-1)+j},'FontSize',14);
                            xlabel('Sample')
                        end
                    case 27
                        break;
                    otherwise
                        continue;
                end
            otherwise
                continue;
        end
    end
    i = i + 4;
end
close(k);



end

