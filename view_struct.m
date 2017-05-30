function view_struct( cstruct )

% fields = fieldnames(click_struct);

len = length(cstruct);

i=1;
j=1;
clf;
while(1)
    if i == 1
        for j = 1:4
            if (i-1)+j > len
                break;
            end
%             fields{(i-1)+j} = char(fields((i-1)+j));
            subplot(2,2,j);
            plot(cstruct((i-1)+j).time_win,cstruct((i-1)+j).sig);
            axis tight
            title((i-1)+j,'FontSize',14);
            xlabel('Time');
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
                            plot(cstruct((i-1)+j).time_win,cstruct((i-1)+j).sig);
                            axis tight
                            title((i-1)+j,'FontSize',14);
                            xlabel('Time')
                        end
                    case 29
                        if ((i-1)+j) > len && mod(len,4)==0
                            continue;
                        end
                        if  i > len
                            continue;
                        end
                        if ((i-1)+j) > len-4
                            clf;
                        end
                        for j = 1:4
                            if ((i-1)+j) > len
                                break;
                            end
                            subplot(2,2,j);
                            plot(cstruct((i-1)+j).time_win,cstruct((i-1)+j).sig);
                            axis tight
                            title((i-1)+j,'FontSize',14);
                            xlabel('Time')
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

