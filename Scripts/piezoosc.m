gf = visa('ni','USB0::0x0699::0x0346::C034165::INSTR');
osc = visa('ni','USB0::0x0699::0x0363::C108012::INSTR');
%%


%abre la sesión Visa de comunicación con el generador de funciones y
%osciloscopio
fopen(gf);
fopen(osc);

%%
fprintf(gf,'FREQ 50097.3')
freq_gf = query(gf,'FREQ?')

fprintf(gf,'SOURce:PHASe:ADJust ')
query(gf,'PHAse?')


%%
str=sprintf('DATA:SOURCE CH%d',2);
fprintf(osc,str);

period_osc = query(osc,'MEASU:IMMED:VAL?')
freq_osc = 1./num2str(period_osc)

query(osc,'MEASU:IMMed:TYPe?')



query(osc,'MEASUrement:MEAS1:VAL?')
fprintf(osc,'MEASUrement:MEAS2:TYPe {PHAse}')
query(osc,'MEASUrement:MEAS3:VAL?')
%%
%loop seteando la frecuencia


n=4;
VOLTS=[];
FREQ1=49500:10:50089;
FREQ2=50090:0.05:50109;
FREQ3=50110:10:50249;
FREQ4=50250:0.05:50300;
FREQ5=50301:10:50500;
FREQ= FREQ4 %horzcat(FREQ1,FREQ2,FREQ3,FREQ4,FREQ5);
data=[];

for i=1:(length(FREQ))
    str=sprintf('FREQ %f',FREQ(i));
    fprintf(gf,str);
    voltaje=query(osc,'MEASUrement:MEAS1:VAL?');
    voltaje_num = str2num(voltaje);
    if voltaje_num <= 0.002*n
        fprintf(osc,'CH2:VOL 0.001');
    elseif voltaje_num > 0.002*n & voltaje_num <= 0.005*n
        fprintf(osc,'CH2:VOL 0.002');
    elseif voltaje_num > 0.005*n & voltaje_num <= 0.01*n
        fprintf(osc,'CH2:VOL 0.005');
    elseif voltaje_num > 0.01*n & voltaje_num <= 0.02*n
        fprintf(osc,'CH2:VOL 0.01');
    elseif voltaje_num > 0.02*n & voltaje_num <= 0.05*n
        fprintf(osc,'CH2:VOL 0.02');
    elseif voltaje_num > 0.05*n & voltaje_num <= 0.1*n
        fprintf(osc,'CH2:VOL 0.05');
    elseif voltaje_num > 0.1*n & voltaje_num <= 0.2*n
        fprintf(osc,'CH2:VOL 0.1');
    elseif voltaje_num > 0.2*n & voltaje_num <= 0.5*n
        fprintf(osc,'CH2:VOL 0.2');
    elseif voltaje_num > 0.5*n & voltaje_num <= 1*n
        fprintf(osc,'CH2:VOL 0.5');
    else
        fprintf(osc,'CH2:VOL 1');
    end
    pause(0.3);

    voltaje=query(osc,'MEASUrement:MEAS1:VAL?');
    pause(0.3); 
    voltaje_num = str2num(voltaje);
    VOLTS(i)=voltaje_num;
    
    figure(1)
    hold on
    plot(FREQ(1:i), VOLTS(1:i),'.')
    xlabel('Frecuencia (Hz)')
    ylabel('Voltaje (V)')
    
    dat=[FREQ(i)' VOLTS(i)'];
    data=[data; dat];
    
    save('detalleantiresonancia.txt','data','-ascii')

end

 



%%



%cierra la sesión Visa de comunicación con el generador de funciones
fclose(gf);
fclose(osc);

