function [ F1, F2 ] = show_Complexes( Complexes, phis, main_Complexes, main_phis, w_inter_hemi, w_intra_hemi, options)

% This function shows complexes and main complexes in demo_split_brain.m.
%
%   input : Complexes, phis, main_Complexes, main_phis, w_inter_hemi, w_intra_hemi
%   output : figures showing which elements compose complexes and main
%   complexes and the value of their phi
%
% In the upper figure, 2 big black circles represent hemispheres and 
% each of them contains 4 elemnts represented by a small circle.
% Elements filled with same color compose same complex (or main complex).
% One element can have several colors when it composes several complexes.
% Note the lines between elements don't represent the connectivity matrix.
%
%
%
%
for g = 1:2
    switch g
        case 1
            Complexes = Complexes;
            phis = phis;
        case 2
            Complexes = main_Complexes;
            phis = main_phis;
    end
    

    X_1 = 5; 
    X_2 = 17;
    Y = 3;
    R = 3;

    x = zeros(1,8);
    y = zeros(1,8);
    x(1) = X_1;
    x(2) = X_1 - R*2*sqrt(2)/3;
    x(3) = X_1;
    x(4) = X_1 + R*2*sqrt(2)/3;
    x(5) = X_2;
    x(6) = X_2 - R*2*sqrt(2)/3;
    x(7) = X_2;
    x(8) = X_2 + R*2*sqrt(2)/3;
    y(1) = Y + R;
    y(2) = Y - R/3;
    y(3) = Y - R;
    y(4) = Y + R/3;
    y(5) = y(1);
    y(6) = y(2);
    y(7) = y(3);
    y(8) = y(4);
    z = [x.',y.']; % coordinates of each element

    ind=[1,2;1,3;1,4;2,3;2,4;3,4;5,6;5,7;5,8;6,7;6,8;7,8];
    ind_2=[1,5;2,6;3,7;4,8];

    a = size(Complexes,1);
    clrs = hsv(a);

    Z = zeros(a,8);
    for i = 1 : a
        comp = cell2mat(Complexes(i));
        aa = length(comp);
        for j = 1 : aa
           Z(i,comp(j)) = 1;
        end
    end

    xx = zeros(a,8);
    yy = zeros(a,8);
    for i = 1 : a
        xx(i,:) = Z(i,:) .* x;
        yy(i,:) = Z(i,:) .* y;
    end

    switch g
        case 1
            F1 = figure;
        case 2
            F2 = figure;
    end
    subplot(2,1,1)
    hold on;
    RR = 5;
    [XXX, YYY] = draw_circle( X_1, Y, RR );
    plot(XXX,YYY,'k')
    [XXX, YYY] = draw_circle( X_2, Y, RR );
    plot(XXX,YYY,'k')

    RR = 1.4;
    for i = 1 : 8
        [XXX, YYY] = draw_circle( x(1,i), y(1,i), RR );
        plot(XXX,YYY,'k')
    end

    axis([-7 30 -4 10])
    axis equal

    for k=1:size(ind,1)
        plot(z(ind(k,:),1),z(ind(k,:),2),'m','LineWidth',0.6)
    end

    for k=1:size(ind_2,1)
        plot(z(ind_2(k,:),1),z(ind_2(k,:),2),'--r')
    end
    
    text(X_1, 9, 'Left hemisphere', 'FontSize', 10, 'HorizontalAlignment','center')
    text(X_2, 9, 'Right hemisphere', 'FontSize', 10,'HorizontalAlignment', 'center')
    txt = ['w inter hemi = ', num2str(w_inter_hemi)];
    text(23, 8.5, txt, 'FontSize', 10)
    txt2 = ['w intra hemi = ', num2str(w_intra_hemi)];
    text(23, 7, txt2, 'FontSize', 10)
%     txt3 = ['type of \Phi = ', options.type_of_phi];
%     text(23, 5.5, txt3, 'FontSize', 10)


%     for i = 1 : a
%         elem = elem + Z(i,:);
%         for j = 1 : 8
%             r = 1250;
%             if xx(i,j) ~= 0          
%                 if elem(j) > 1
%                     r = (1250)*(4.01 - elem(j))/4;
%                     scatter(xx(i,j),yy(i,j),r,clrs(i,:),'filled')
%                 elseif elem(j) == 1
% %                     scatter(xx(i,j),yy(i,j),r,clrs(a,:),'filled')
%                     scatter(xx(i,j), yy(i,j), 1250, clrs(i,:), 'filled')
%                 end
%             end
%         end
%     end
    emm = zeros(1,8);

    for i = 1 : a
        if size(Z,1) == 1
            elem = Z;
        else
            elem = sum(Z);
        end
        emm = emm + Z(i,:);
        for j = 1 : 8
            if Z(i,j) ~= 0
            RR = (1.4)*(elem(j) + 1 - emm(j))/elem(j);
%             scatter(xx(i,j),yy(i,j),r,clrs(i,:),'filled')
            [XXX, YYY] = draw_circle( xx(i,j), yy(i,j), RR );
            plot(XXX, YYY, 'color', clrs(i,:))
            fill(XXX, YYY, clrs(i,:))
            end
        end
    end
    
    switch g
        case 1
            title('Complexes','FontSize',20)                
        case 2
            title('Main Complexes','FontSize',20)          
    end
%     
%     cord = zeros(a, 2);
%     for i = 1 : a
%         cord(i,2) = 9 - i*1.7 + 1;
%     end
%     cord(:,1) = 23;
% 
%     for i = 1 : a
%         txt = ['\Phi = ', num2str(phis(i,1))];
%         text(cord(i,1), cord(i,2), txt, 'Color', clrs(i,:), 'FontSize', 14)
%     end

    hold off;
    
    subplot(2,1,2);
    data1 = phis.';
    for i = 1 : a
        data1(1,:) = NaN;
        data1(1,i) = phis(i,1);
        if a == 1
            data2 = [0 , data1, 0];
            bar(data2, 'FaceColor', clrs(i,:))
        else
            bar(data1, 'FaceColor', clrs(i,:))
        end
        hold on
    end
    
    
    complexes_str = cell(size(Complexes));
    if a == 1
        complexes_str{2} =  num2str(Complexes{1});
        complexes_str{1} =  'Nan';
        complexes_str{3} =  'Nan';
    else
        for i = 1:length(Complexes)
            complexes_str{i} =  num2str(Complexes{i});
        end
    end
    set(gca, 'xticklabel', complexes_str)
    
    
    
    
    title('Value of \Phi','FontSize',20) 
    ylabel('\Phi')
    switch g
        case 1
            xlabel('Complexes')
        case 2
            xlabel('Main Complexes')
    hold off
    end
    
end
end

