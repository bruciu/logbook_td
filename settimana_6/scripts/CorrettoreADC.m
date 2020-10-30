classdef CorrettoreADC < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DAC_vals = 0;
        ADC_mean = 0;
        ADC_var = 0;
    end
    
    methods
        
        function [valore_centrale, dev_std, varianza] = correggi(obj, valori)
            [valore_centrale, dev_std, varianza] = erroriADC(ADC_val, DAC_vals, ADC_mean, ADC_var);
        end
        
        
    end
    
end



function [media, dev_std, varianza] = erroriADC(ADC_val, DAC_vals, ADC_mean, ADC_var) 
%ERRORIADC Summary of this function goes here
%   Detailed explanation goes here

if (numel(ADC_val) > 1)
    media = zeros(1, numel(ADC_val));
    dev_std = zeros(1, numel(ADC_val));
    varianza = zeros(1, numel(ADC_val));
    for i = 1:numel(ADC_val)
        [media(i), dev_std(i), varianza(i)] = erroriADC_implementazione(ADC_val(i), DAC_vals, ADC_mean, ADC_var);
    end
else
    [media, dev_std, varianza] = erroriADC_implementazione(ADC_val, DAC_vals, ADC_mean, ADC_var);
end

end


function [media, dev_std, varianza] = erroriADC_implementazione(ADC_val, DAC_vals, ADC_mean, ADC_var) 
%ERRORIADC Summary of this function goes here
%   Detailed explanation goes here


N = numel(ADC_mean);
xx = DAC_vals;

ratio = 1/10;
tmp = (xx > (ADC_val - ratio * 4095)) & (xx < (ADC_val + ratio * 4095));
[~, indice_min] = find(tmp, 1, 'first');
[~, indice_max] = find(tmp, 1, 'last');
ADC_mean = ADC_mean(indice_min:indice_max);
ADC_var = ADC_var(indice_min:indice_max);
xx = xx(indice_min:indice_max);
N = numel(ADC_mean);

if (ADC_val > 500)
    jknfrj = 1;
end

weights = normpdf(ADC_val, ADC_mean, ADC_var);
media = sum(xx .* weights) / sum(weights);
varianza = sum(((xx - media).^2 + 0 * ADC_var.^2) .* weights) / sum(weights);
dev_std = sqrt(varianza);
end

