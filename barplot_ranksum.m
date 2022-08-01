function [f,ax,p,mx,sx,my,sy] =  barplot_ranksum(x,y,ylab,xticklab,varargin)

% ranksum -----------------------------------------------------------------
[p,h,stats] = ranksum(x,y,varargin{:});

% means and standard dev --------------------------------------------------
mx = nanmean(x);
my = nanmean(y);
sx = nanstd(x)/sqrt(length(x));
sy = nanstd(y)/sqrt(length(y));;

% constants ---------------------------------------------------------------
col1 = 1/255 * [103,169,207];
col2 = 1/255 * [239,138,98];
col3 = [0.4 0.4 0.4];
lwidth = 1.5;
prct_offset = 0.05;

% plot figure -------------------------------------------------------------
[f,ax] = my_figure();
hold on
my_bar(1,mx,col1,col3);
my_bar(2,my,col2,col3);
my_errorbar(1,mx,sx,col3);
my_errorbar(2,my,sy,col3);
comparison(mx,sx,my,sy,p,col3);
xlim([0.5 2.5])
ylabel(ylab)
ax.XTickLabel = xticklab;

    function [f,ax] = my_figure()
        f = figure('Units','pixels',...
            'Position',[0 0 480 480]);
        ax = axes;
        ax.Box = 'on';
            ax.LineWidth = lwidth;
        ax.FontSize = 16;
        ax.XTick = [1 2];
    end

    function my_bar(x,m,facecol,edgecol)
        bar(x,m,...
            'FaceColor',facecol,...
            'EdgeColor',edgecol,...
            'LineWidth',lwidth);
    end

    function  my_errorbar(x,m,s,edgecol)
        plot([x x],[m m+s],...
            'Color',edgecol,...
            'LineWidth',lwidth);
        plot([x-0.05 x+0.05],[m+s m+s],...
            'Color',edgecol,...
            'LineWidth',lwidth);
    end

    function comparison(mx,sx,my,sy,p,edgecol)

        lims = ylim();
        height = diff(lims);
        offset = prct_offset * height;
        top = max(mx+sx ,my+sy) + 2*offset;
        bot1 = mx+sx+offset;
        bot2 = my+sy+offset;
        xp = 1.5;
        yp = top+offset;

        % plot bridge
        plot([1 1],[bot1 top],...
            'Color',edgecol,...
            'LineWidth',lwidth);
        plot([1 2],[top top],...
            'Color',edgecol,...
            'LineWidth',lwidth);
        plot([2 2],[top bot2],...
            'Color',edgecol,...
            'LineWidth',lwidth);
        
        % asterisk p-val
        if p < 0.001
            my_asterisk(xp,yp,'***')
        elseif p < 0.01
            my_asterisk(xp,yp,'**')
        elseif p < 0.05
            my_asterisk(xp,yp,'*')
        else
            my_asterisk(xp,yp,'ns')
        end
    
        ylim([lims(1) yp+offset])

        function my_asterisk(x,y,txt)
            text(x,y,txt,...
                'HorizontalAlignment','center',...
                'Color',edgecol,...
                'FontSize',20)

        end
    end
end