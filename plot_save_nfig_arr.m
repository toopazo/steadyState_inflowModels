function plot_save_nfig_arr(str1, str2, nfig_arr, delay)
    pause(delay);
    
    for nfig = nfig_arr       
        fig = figure(nfig);
        % set(fig,'units', 'centimeters', 'position', [0, 0, 20, 10]);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);            
    end
end

