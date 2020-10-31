classdef CorrettoreADC < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        DAC_vals = 0;
        A0_mean = 0;
        A0_var = 0;
        A1_mean = 0;
        A1_var = 0;
    end
    
    methods
        
        function [valore_centrale, dev_std, varianza] = correggiA0(obj, valori)
            [valore_centrale, dev_std, varianza] = erroriADC(valori, obj.DAC_vals, obj.A0_mean, obj.A0_var + 0.01);
        end
        function [valore_centrale, dev_std, varianza] = correggiA1(obj, valori)
            [valore_centrale, dev_std, varianza] = erroriADC(valori, obj.DAC_vals, obj.A1_mean, obj.A1_var + 0.01);
        end
        
        function salva(obj, fileName)
            DAC_vals = obj.DAC_vals;
            A0_mean = obj.A0_mean;
            A0_var = obj.A0_var;
            A1_mean = obj.A1_mean;
            A1_var = obj.A1_var;
            
            save(fileName, 'DAC_vals', 'A0_mean', 'A0_var', 'A1_mean', 'A1_var');
        end
        
        function carica(obj, fileName)
            load(fileName, 'DAC_vals', 'A0_mean', 'A0_var', 'A1_mean', 'A1_var');
            
            obj.DAC_vals = DAC_vals;
            obj.A0_mean = A0_mean;
            obj.A0_var = A0_var;
            obj.A1_mean = A1_mean;
            obj.A1_var = A1_var;
        end
        
        function run(obj, mini)
            N_onda = 100;
            N_samples = 1000;
            PS = 1200;
            
            mini.setNSkip(2);
            mini.setNSamples(N_samples);
            mini.setPrescaler(PS);
            
            % questi sono vetori dei valori medi e varianze per ogni punto sul
            % partitore
            % A0_medio;
            % A0_var;
            % A1_medio;
            % A1_var;
            N = 4096;
            wb = waitbar(0);
            tic; t = 1;
            tmp_factor = 0.2;
            for i = 1:N
                t = t * (1 - tmp_factor) + toc * tmp_factor;
                waitbar(i/N, wb, sprintf("indice %d / %d (%.1f %%), ETA: %.1f minuti", ...
                    i, N, i/N*100, (N - i) * t / 60));
                tic;
                %disp(i);
                
                funz = @(x) 4095*(i-1)/(N-1);
                mini.setWaveFun(funz, N_onda);
                
                
                [~, y0, y1]= mini.DACADC();
                
                A0_medio_tmp(i) = mean(y0);
                A0_var_tmp(i) = var(y0);
                A1_medio_tmp(i) = mean(y1);
                A1_var_tmp(i) = var(y1);
            end
            close(wb);
            DAC_values = (0:N-1)*4095 / (N-1);
            
            obj.DAC_vals = DAC_values;
            obj.A0_mean = A0_medio_tmp;
            obj.A0_var = A0_var_tmp;
            obj.A1_mean = A1_medio_tmp;
            obj.A1_var = A1_var_tmp;
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

