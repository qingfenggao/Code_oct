function [ReliabilityCoeficient,SEd,SDdiff,means,diffs,meanDiff,CI_agreement,CI_d,linFit,xlim] = BlandAltman(var1, var2, flag)
    % revise by gao at 2017/11/9
    %%%Plots a Bland-Altman Plot
    %%%INPUTS:
    %%% var1 and var2 - vectors of the measurements
    %%%flag - how much you want to plot
        %%% 0 = no plot
        %%% 1 = just the data
        %%% 2 = data and the difference and CR lines
        %%% 3 = above and a linear fit
    %%%
    %%%OUTPUTS:
    %%% ReliabilityCoeficient = Reliability Coeficient
    %%% SEd = Stardard Error of difference
    %%% means = the means of the data
    %%% diffs = the raw differences
    %%% meanDiff = the mean difference
    %%% CI_agreement = the 2SD confidence limits
    %%% CI_d = confidence limits(tn-1 * SEd), where t is the critical value of t-distribution at p = 0.05 
    %%% linfit = the paramters for the linear fit
    
    
    if (nargin<1)
       %%%Use test data
       var1=[512,430,520,428,500,600,364,380,658,445,432,626,260,477,259,350,451];%,...
       var2=[525,415,508,444,500,625,460,390,642,432,420,605,227,467,268,370,443];
       flag = 3;
    end
    
    if nargin==2
        flag = 0;
    end
    
    means = mean([var1;var2]);
    diffs = var1-var2;
    
    meanDiff = mean(diffs);
    SDdiff = std(diffs);
    CI_agreement = [meanDiff + 2 * SDdiff, meanDiff - 2 * SDdiff]; %%95% confidence range
    ReliabilityCoeficient = 2*sqrt(sum(diffs.^2)/(length(var1)));
    SEd = SDdiff/sqrt(length(var1));
    CI_d = [meanDiff + 2.228 * SEd, meanDiff - 2.228 * SEd];
    
    linFit = polyfit(means,diffs,1); %%%work out the linear fit coefficients
    
    %%%plot results unless flag is 0
    figure('position',[400 100 800 600]);
    Deta = 0.000001;
    if flag ~= 0
%         plot(means,diffs,'',...
%             'MarkerSize',10,...
%             'MarkerEdgeColor','none',...
%             'MarkerFaceColor',[0 0 0])
        scatter(means,diffs,'square','k','filled');
%         plot(means,diffs,'o')
        hold on
        if flag > 1
            xlim = get(gca,'Xlim');
            Xlim = [xlim(1)+Deta,xlim(2)-Deta];
            plot(Xlim,[1,1].*CI_d(1),'k--');
            plot(Xlim,[1,1].*CI_d(2),'k--');
            plot(Xlim,zeros(1,length(Xlim)),'k'); %%%plot zero

%           line([xlim(1)+Deta,xlim(2)-Deta],[0,0]);
        end
        if flag > 2
            plot(means, means.*linFit(1)+linFit(2),'k--'); %%%plot the linear fit
        end
%         title('Bland-Altman Plot')
    end
    
end