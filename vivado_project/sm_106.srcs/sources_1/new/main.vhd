----------------------------------------------------------------------------------
-- Company: University of Deusto
-- Engineers: Imanol Gutierrez, Oier Fernandez, Endika Alonso
-- 
-- Create Date: 05.06.2022 12:57:32
-- Design Name: sensor_mockup_106
-- Module Name: main - Behavioral
-- Project Name: sensor_mockup_106
-- Target Devices: basys 3
-- Tool Versions: 1.0
-- Description: code for the mockup in lab 106
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity main is
Port (
   clk: in std_logic;
   inicio: in std_logic;
   enableSw: in std_logic;
   enableSwS: in std_logic;
   enable_seg: out std_logic_vector(3 downto 0);
   segmentos: out std_logic_vector(6 downto 0);
   modo: in std_logic_vector(1 downto 0);
   alarma: out std_logic;
   paro: in std_logic;
   
   btnU: in std_logic;
   btnD: in std_logic;
   btnL: in std_logic;
   btnR: in std_logic;   
   
   cale: out std_logic;
   
   dcEnc: in std_logic_vector (1 downto 0);
   pwmEnt: in std_logic_vector(3 downto 0);
   pwmPos: out std_logic;
   pwmNeg: out std_logic;  
    
   enableSteper: out std_logic;
   fc2Tarj: in std_logic;
   fc1Calle: in std_logic;
   led: out std_logic_vector(15 downto 0);
   sw: in std_logic_vector(3 downto 0);
   dir: out std_logic;
   step: out std_logic;
   echo: in std_logic;
   trigger: out std_logic; 
    
   crc_en: OUT STD_LOGIC;
   -- data_out_lsb: out std_logic_vector (7 downto 0);
   -- data_out_msb: out std_logic_vector (3 downto 0);
   ds_data_bus: INOUT	STD_LOGIC
   );
end main;

architecture Behavioral of main is

------------------------------signals para control
signal rDist: integer range 0 to 1023;
signal rTemp: integer range 0 to 1023;
signal rHall: integer range 0 to 1023;
signal riesgo: std_logic;

------------------------------signals para filtrado de btn
--Up
signal estadoU: std_logic_vector (1 downto 0);
--Down
signal estadoD: std_logic_vector (1 downto 0);
--Left
signal estadoL: std_logic_vector (1 downto 0);
--R
signal estadoR: std_logic_vector (1 downto 0);
-------------------------------signals para pwmDC
-- mot pwm
signal estadoPWM: std_logic_vector(2 downto 0);
signal contPWM: integer range 0 to 500000;
signal tope: integer range 0 to 500000;
signal pwm: std_logic;
signal sentido: std_logic;
--PID
signal error: integer range -50000 to 50000;
-------------------------------signals para hallDC
signal cont_baseDC: integer range 0 to 100000000;
signal contador_ticks: integer range 0 to 100000; --contador de microsegundos ticks de reloj
signal contador_ticks_2: integer range 0 to 100000; --contador de microsegundos ticks de reloj
signal rpm: integer range 0 to 9999;
signal aux_rpm: integer range 0 to 9999;
signal cont_microsDC: integer range 0 to 100000;
signal estado_hall: std_logic_vector (2 downto 0);
signal sentidoGiro: std_logic;
-- conexion del sensor hall
signal hall: std_logic_vector (1 downto 0);
signal cont_hall: integer range 0 to 1000;

--------------------------------signals para distancia
signal cont_micros: integer range 0 to 60000;
signal cont_baseDist: integer range 0 to 100;
signal cont_echo: integer range 0 to 60000;
signal distancia_entero: integer range 0 to 1023;

--------------------------------signals para stepper
signal dirAux: std_logic;
signal reloj_paso_paso: integer range 0 to 10000000; --para generar la frecuencia de 50 Hz
signal paso_paso_aux: std_logic; --para generar la salida
signal tope_frecuencia_paso_paso: integer range 0 to 1000000000; --para controlar la velocidad
signal frecuencia_paso_paso_entero: integer range 0 to 10000;

--------------------------------signal para PT100
TYPE STATE_TYPE is (WAIT_800ms, RESET, PRESENCE, SEND, WRITE_BYTE, WRITE_LOW, WRITE_HIGH, GET_DATA, READ_BIT);
SIGNAL state: STATE_TYPE;
SIGNAL data	: STD_LOGIC_VECTOR(71 downto 0);
SIGNAL S_reset	: STD_LOGIC;
SIGNAL i			: INTEGER RANGE 0 TO 799999;
SIGNAL write_command : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL presence_signal		: STD_LOGIC;
SIGNAL WRITE_BYTE_CNT	: INTEGER RANGE 0 TO 8	:= 0;	-- citac pro odesilany bajt
SIGNAL write_low_flag	: INTEGER RANGE 0 TO 2	:= 0;	-- priznak pozice ve stavu WRITE_LOW
SIGNAL write_high_flag	: INTEGER RANGE 0 TO 2	:= 0;	--	priznak pozice ve stavu WRITE_HIGH
SIGNAL read_bit_flag		: INTEGER RANGE 0 TO 3	:= 0;	-- priznak pozice ve stavu READ_BIT
SIGNAL GET_DATA_CNT		: INTEGER RANGE 0 TO 72	:= 0;	-- citac pro pocet prectenych bitu
SIGNAL CONT_AUX: integer range 0 to 100; --125; 				--chez a propochet ringa rangu
signal dataOut			: STD_LOGIC_VECTOR(71 downto 0);

---------------------------------signals para bin2bcd
signal vector_aux: std_logic_vector (29 downto 0);
signal estado: std_logic_vector (1 downto 0);
signal cont_bits: integer range 0 to 13;
signal fin: std_logic;

signal sal_mux: std_logic_vector (3 downto 0);
signal unidades: std_logic_vector (3 downto 0);
signal decenas: std_logic_vector (3 downto 0);
signal centenas: std_logic_vector (3 downto 0);
signal millares: std_logic_vector (3 downto 0);
signal enable_aux: std_logic_vector (3 downto 0);
signal cont_base_enable: integer range 0 to 100000;

signal cont: integer range 0 to 100000000;

---------------------------------signals para intercomunicar Cajas
signal relojData: std_logic_vector(15 downto 0);
signal TempData: std_logic_vector(8 downto 0);
signal distData: std_logic_vector(13 downto 0);
signal to7seg: std_logic_vector(15 downto 0);
signal muxSensores: std_logic_vector(13 downto 0);
signal bcdData: std_logic_vector(15 downto 0);
signal selLSB: std_logic_vector(1 downto 0);
signal hallData: std_logic_vector(13 downto 0);
signal sel: std_logic_vector(2 downto 0);
signal rDistData: std_logic_vector(14 downto 0);

signal der: std_logic;
signal izq: std_logic;
signal menos: std_logic;
signal mas: std_logic;

signal controlSt: std_logic_vector(1 downto 0);
signal controlDC: std_logic;

-------------------------------------------------signal para 7seg
signal salida_ver: std_logic_vector (3 downto 0); 

-------------------------------------------------signals para Reloj
signal cont_seg_uni: std_logic_vector (3 downto 0);
signal cont_seg_dec: std_logic_vector (3 downto 0);
signal cont_min_uni: std_logic_vector (3 downto 0);
signal cont_min_dec: std_logic_vector (3 downto 0);

signal cont_riesgo: integer range 0 to 9999;
signal cont_base: integer range 0 to 100000000;
signal cont_enable_aux: integer range 0 to 100000;
signal enable_seg_aux: std_logic_vector (3 downto 0);

begin

led <= sel & "0110111101111";
selLSB <= sel(1 downto 0);
hall <= dcEnc;

---------------------------------------------filtrado de pulsadores
--U
process(inicio, clk)
begin
if inicio='1' then
    estadoU<="00";
elsif rising_edge(clk) then
    case estadoU is
    when "00" =>
        if btnU='0' then
            estadoU<="00";
        else
            estadoU<="01";
        end if;           
    when "01" =>
        if btnU='0' then
            estadoU<="10";
        else
            estadoU<="01";
        end if;
    when "10" =>
        estadoU<="00";
    when others =>
        estadoU<="00";
    end case;
end if;
end process; 

process(estadoU)
begin
case estadoU is
when "00" => mas<='0';
when "01" => mas<='0';
when "10" => mas<='1';
when others => mas<='0';
end case;
end process;

--D
process(inicio, clk)
begin
if inicio='1' then
    estadoD<="00";
elsif rising_edge(clk) then
    case estadoD is
    when "00" =>
        if btnD='0' then
            estadoD<="00";
        else
            estadoD<="01";
        end if;           
    when "01" =>
        if btnD='0' then
            estadoD<="10";
        else
            estadoD<="01";
        end if;
    when "10" =>
        estadoD<="00";
    when others =>
        estadoD<="00";
    end case;
end if;
end process; 

process(estadoD)
begin
case estadoD is
when "00" => menos<='0';
when "01" => menos<='0';
when "10" => menos<='1';
when others => menos<='0';
end case;
end process;

--L
process(inicio, clk)
begin
if inicio='1' then
    estadoL<="00";
elsif rising_edge(clk) then
    case estadoL is
    when "00" =>
        if btnL='0' then
            estadoL<="00";
        else
            estadoL<="01";
        end if;           
    when "01" =>
        if btnL='0' then
            estadoL<="10";
        else
            estadoL<="01";
        end if;
    when "10" =>
        estadoL<="00";
    when others =>
        estadoL<="00";
    end case;
end if;
end process; 

process(estadoL)
begin
case estadoL is
when "00" => izq<='0';
when "01" => izq<='0';
when "10" => izq<='1';
when others => izq<='0';
end case;
end process;

--R
process(inicio, clk)
begin
if inicio='1' then
    estadoR<="00";
elsif rising_edge(clk) then
    case estadoR is
    when "00" =>
        if btnR='0' then
            estadoR<="00";
        else
            estadoR<="01";
        end if;           
    when "01" =>
        if btnR='0' then
            estadoR<="10";
        else
            estadoR<="01";
        end if;
    when "10" =>
        estadoR<="00";
    when others =>
        estadoR<="00";
    end case;
end if;
end process; 

process(estadoR)
begin
case estadoR is
when "00" => der<='0';
when "01" => der<='0';
when "10" => der<='1';
when others => der<='0';
end case;
end process;
----------------------------------------------------------------------------
----------------------------CONTROL-----------------------------------------
----------------------------------------------------------------------------

--generacion de lineas de control
process(inicio, clk, modo)
begin
if inicio = '1'then
    controlSt <= "00";
elsif rising_edge(clk) then
case modo is
    when "00"=> --modo ida y vuelta continuo
        cale <= '0';
        controlSt <= "11"; 
        controlDC <= '0';
    when "01"=> --ida y vuelta hasta temperatura de riesgo
        controlDC <= '0';
        if riesgo = '1' then
        controlSt <= "00";
        cale <= '0';
        else
        controlSt <= "11";
        cale <= '1';
        end if;
    when "10" =>    --poner stepper a distancia especificada
        controlDC <= '0';
        cale <= '0';
        if(rDist > distData)then
            controlSt <= "01";
        elsif rDist < distData then
            controlSt <= "10";
        else controlSt <= "00";
        end if;
    when "11" =>
        cale <= '0';
        controlSt <= "00"; 
        controlDC <= '1';
    when others => controlSt <= "00";
end case;
end if;
end process;

--insercion de datos por btns
process(clk, inicio, sel)
begin
if inicio = '1' then
--    rDist <= 0;
--    rHall <= 0;
--    rTemp <= 0;
    riesgo <= '0';
elsif rising_edge(clk) then
    case sel is
    when "101" =>
        if mas = '1' then
            rTemp <= rTemp +1;
        elsif menos = '1'then
            rTemp <= rTemp -1;
        end if;
    when "110" => 
        if mas = '1' then
            rDist <= rDist +1;
        elsif menos = '1'then
            rDist <= rDist -1;
        end if;
    when "111" => 
        if paro = '0'then
        if mas = '1' then
            rHall <= rHall +1;
        elsif menos = '1'then
            rHall <= rHall -1;
        end if;
        end if;
    when others =>
    end case;
end if;
if(TempData > rTemp)then
    riesgo <= '1';
else
    riesgo <= '0';
end if;
end process;
--generacion de sel
process(clk, inicio)
begin
if inicio = '1' then
    sel <= "000";
elsif rising_edge(clk) then
    if(der = '1')then
        sel<= sel +1;
    elsif(izq = '1')then
        sel <= sel -1;
    end if;
end if;
end process;

---------------------------------------------process para pwmDC


process(controlDC, pwmEnt, clk, inicio)
begin
if controlDC = '0'then
    case pwmEnt is
    when "0000" => tope <= 0;
    when "0001" => tope <= 50000;
    when "0010" => tope <= 100000;
    when "0011" => tope <= 150000;
    when "0100" => tope <= 200000;
    when "0101" => tope <= 250000;
    when "0110" => tope <= 300000;
    when "0111" => tope <= 350000;
    when "1000" => tope <= 400000;
    when "1001" => tope <= 450000;
    when "1010" => tope <= 500000;
    when others => tope <= 0;
    end case;
else
    --PID
    if inicio = '1'then 
        error <= 0;
    elsif rising_edge(clk)then
        error <= (rHall - rpm) *10;
        if error > 50000 then
            tope <= 50000;
        
        end if;
--        if(rHall > rpm)then
--            tope <= tope +10;
--        elsif(rHall < rpm)then
--            tope <= tope -10;
--        else
--            tope <= tope;
--        end if;
    end if;
end if;

end process;


process(sentido)
begin
if(sentido = '0')then
    pwmPos <= pwm;
    pwmNeg <= '0';
else
    pwmPos <= '0';
    pwmNeg <= pwm;
end if;
end process;



process(inicio, clk)
begin
if inicio = '1' then
    contPWM <= 0;
    estadoPWM <= "000";
elsif rising_edge(clk)then
    case estadoPWM is
    when "000" => 
        contPWM <= 0;
        if(tope = 0) then
            estadoPWM <= "001";
        else
            estadoPWM <= "010";
        end if;
    when "001" =>                                                                                                                                                                                            
        contPWM <= 1;
        estadoPWM <= "011";
    when "010" => 
        contPWM <= 1;
        estadoPWM <= "100";   
     when "011" =>
        contPWM <= contPWM +1;
        if (contPWM = 500000 and tope = 0)then
            estadoPWM <= "001";
        elsif (contPWM = 500000)then
            estadoPWM <= "010";
        end if;
     when "100" =>
        contPWM <= contPWM +1;
        if (contPWM = tope and tope = 500000)then
            estadoPWM <= "010";
        elsif (contPWM = tope)then
            estadoPWM <= "011";
        end if;
     when others => 
        contPWM <= 0;
        estadoPWM <= "000";
    end case;
end if;
end process;

process(estadoPWM)
begin
case estadoPWM is
when "000" => pwm <= '0';
when "001" => pwm <= '0';
when "010" => pwm <= '1';
when "011" => pwm <= '0';
when "100" => pwm <= '1';
when others => pwm <= '0';
end case;
end process;

---------------------------------------------process para hallDC
-- cuenta las revoluciones del motor cada segundo y luego las pasa a la variable rev_per_seg
process(clk, inicio)
begin
if rising_edge(clk) then
    if inicio='1' then
        contador_ticks <= 0;
        cont_microsDC <= 0;
        rpm <= 0;
        aux_rpm <= 0;
        estado_hall <= "000";
        cont_hall <= 0;
    else
        if contador_ticks = 100 then
            case estado_hall is
                when "000" => -- estado_hall inicial
                   
                    cont_microsDC <= 0;
                   
                    if  hall = "00" then
                        estado_hall <= "001";
                    end if;
                   
                when "001" =>
                    cont_microsDC <= cont_microsDC + 1;
                    rpm <= rpm;
                   
                    if cont_microsDC >= 60000 then
                        rpm <= 0;
                        estado_hall <= "000";
                    elsif hall = "01" then
                        sentidoGiro <= '0';
                        estado_hall <= "010";
                    elsif hall = "10" then
                        sentidoGiro <= '1';
                        estado_hall <= "011";
                    end if;
                   
                 when "010" =>
                   cont_microsDC <= cont_microsDC + 1;
                   
                    if cont_microsDC >= 60000 then
                        rpm <= 0;
                        estado_hall <= "000";
                    elsif hall = "00" then
                        estado_hall <= "100";
                    end if;
                   
                 when "011" =>
                    cont_microsDC <= cont_microsDC + 1;
                   
                    if cont_microsDC >= 60000 then
                        rpm <= 0;
                        estado_hall <= "000";
                    elsif hall = "00" then
                        estado_hall <= "100";
                    end if;
               
                when "100" =>
                    aux_rpm <= (60000000 / (cont_microsDC * 8 * 120));
                    if cont_hall = 100 and (aux_rpm < rpm - 2 or aux_rpm > rpm + 2) then
                        rpm <= aux_rpm;
                        cont_hall <= 0;
                    else
                        cont_hall <= cont_hall + 1;
                    end if;
                    estado_hall <= "000";
                   
                when others =>
                    estado_hall <= "000";
                end case;

            contador_ticks <= 0;
        else
            contador_ticks <= contador_ticks + 1;
        end if;
    end if;
end if;
if paro = '0' then
hallData <= std_logic_vector(to_unsigned(rpm, 14));
end if;
end process;




---------------------------------------------process para distancia
-- Contador de micros y generacion del ciclo de 60 ms
process(clk, inicio)
begin
if inicio='1' then
    cont_baseDist<=0;
elsif rising_edge(clk) then
    if cont_baseDist=100 then
        cont_baseDist<=0;
        if cont_micros=60000 then
            cont_micros<=0;
        else
            cont_micros<=cont_micros+1;
        end if;                   
    else
        cont_baseDist<=cont_baseDist+1;
    end if;
end if;
end process;

-- generador del trigger
process(cont_micros)
begin
if cont_micros<10 then
    trigger<='1';
else
    trigger<='0';
end if;
end process;

-- Contador de echo 
process(clk, inicio)
begin
if inicio='1' then
    cont_echo<=0;
elsif rising_edge(clk) then
    if cont_micros=0 then
        cont_echo<=0;
    else
        if cont_baseDist=0 then
            if echo='1' then
                cont_echo<=cont_echo+1;
            end if;
        end if;
    end if;
end if;
end process;                                

-- Registro y calculo de la distancia por cada ciclo
process(inicio, clk)
begin
if inicio='1' then
    distancia_entero<=0;
elsif rising_edge(clk) then
    if cont_micros=60000 then
        distancia_entero<=cont_echo/58;
    end if;
end if;
end process; 
distData <= "0000" & std_logic_vector(to_unsigned(distancia_entero, 10));


----------------------------------------------process para stepper
frecuencia_paso_paso_entero<=to_integer(unsigned(sw & "00000"));
tope_frecuencia_paso_paso<=(100000000/frecuencia_paso_paso_entero)/2;

--control de Stepper
process(clk, inicio, controlST)
begin 
if inicio = '1' then
    dirAux <= '0';
    enableSteper <= enableSwS;
elsif rising_edge(clk) then
    case controlSt is
    when "00" =>    --parado
        enableSteper <= '0';
    when "01" =>    --en direccion calle
     dirAux <= '1';
     if(fc1Calle = '1')then
        enableSteper <= '0';
        else
        enableSteper <= enableSwS;
        end if;
    when "10" =>    --en direccion placa
        dirAux <= '0';
        if(fc2Tarj = '1')then
        enableSteper <= '0';
        else
        enableSteper <= enableSwS;
        end if;
    when "11" =>    --en las 2 direcciones
        enableSteper <= enableSwS;
        
--        if(fc2Tarj = '0' and fc1Calle = '0')then
--          dirAux <= dirAux;
--         else
--             if(fc2Tarj = '1')then
--             dirAux <= '1';
--             else
--               dirAux <= '0';
--             end if;
--         end if;      
    
    if(fc2Tarj = '0' and fc1Calle = '0')then
        dirAux <= dirAux;
    else
        if(fc2Tarj = '1')then
            dirAux <= '1';
        else
            dirAux <= '0';
        end if;
    end if;
    when others =>
       dirAux <= '0';
    enableSteper <= enableSwS; 
    end case;
end if;
end process;

process(clk)
begin
if inicio='1' then
    reloj_paso_paso<=0;
elsif rising_edge(clk) then
   if reloj_paso_paso=tope_frecuencia_paso_paso then --0 then
        reloj_paso_paso<=0;
   else
        reloj_paso_paso<=reloj_paso_paso+1;
   end if;
end if;
end process;

process(clk)
begin
if clk='1' and clk'event then
    if reloj_paso_paso=0 then -- con el A
        paso_paso_aux<=not(paso_paso_aux);
    end if;
end if;
end process;
dir<=dirAux;

process(clk, enableSw)
begin
if(rising_edge(clk))then
    if(enableSw = '1')then
        step<=paso_paso_aux;
    else
        step <= '0';
    end if;
end if;
end process;

----------------------------------------------process para PT100
process(clk)
CONSTANT PRESENCE_ERROR_DATA: STD_LOGIC_VECTOR(71 downto 0):= "111111111111111111111111111111111111111111111111111111111111111111111111";

	VARIABLE bit_cnt: INTEGER RANGE 0 TO 71;	-- prave cteny bit
	VARIABLE flag: INTEGER RANGE 0 TO 5;		-- priznak pro odesilany prikaz

	begin
		if rising_edge(clk) and cont_aux=0 then
			case	state is
				when RESET =>																-- stav pro reset senzoru
					S_reset <= '0';														-- reset citace
					if (i = 0) then 
						ds_data_bus <= '0';												--	zacatek resetovaciho pulzu
					elsif (i = 485) then 
						ds_data_bus <= 'Z'; --aqui												-- uvolneni sbernice
					elsif (i = 550) then
						presence_signal <= ds_data_bus;								-- odebrani vzorku pro zjisteni pritomnosti senzoru 
					elsif (i = 1000) then 
						state <= PRESENCE;												-- prechod do stavu PRESENCE	
					end if;
			
				when PRESENCE =>															-- stav pro zjisteni pritomnosti senzoru na sbernici
					-- detekce senzoru na sbernici
					if (presence_signal = '0' and ds_data_bus = '1') then		-- senzor byl detkovan
						S_reset <= '1';													-- reset citace
						state	  <= SEND;													-- inicializace dokoncena, prechod do stavu SEND
					else																		-- senzor nebyl detekovan
						S_reset	<= '1';													-- reset citace
						dataOut 	<= PRESENCE_ERROR_DATA;								-- nastaveni dat indikujicich chybu na vystup
						crc_en	<= '1';													-- zahajeni vypoctu CRC
						state		<= WAIT_800ms;											-- prechod do stavu WAIT_800ms
					end if;

				when SEND =>																-- stav pro odesilani prikazu pro senzor
					-- sekvence odesilanych prikazu rizena priznakem flag
					if (flag = 0) then													-- prvni prikaz
						flag := 1;
						write_command <="11001100"; 									-- prikaz CCh - SKIP ROM
						state 		  <= WRITE_BYTE;									-- prechod do stavu WRITE BYTE
					elsif (flag = 1) then												-- druhy prikaz
						flag := 2;
						write_command <="01000100"; 									-- prikaz 44h - CONVERT TEMPERATURE
						state 		  <= WRITE_BYTE;									-- prechod do stavu WRITE BYTE
					elsif (flag = 2) then												-- treti prikaz
						flag := 3;	
						state <= WAIT_800ms; 											-- prechod do stavu WAIT_800ms, cekani na ukonceni prikazu 44h
					elsif (flag = 3) then												-- treti prikaz
						flag := 4;
						write_command <="11001100"; 									-- prikaz CCh - SKIP ROM
						state			  <= WRITE_BYTE;									-- prechod do stavu WRITE BYTE
					elsif (flag = 4) then												-- ctvrty prikaz
						flag := 5;
						write_command <="10111110"; 									-- prikaz BEh - READ SCRATCHPAD
						state			  <= WRITE_BYTE;									-- prechod do stavu WRITE BYTE
					elsif (flag = 5) then												-- ukonceni vysilani prikazu
						flag := 0;															-- reset priznaku pro odesilany prikaz
						state <= GET_DATA;												-- prechod do stavu GET_DATA
					end if;

				when  WAIT_800ms =>														-- stav cekani po dobu 800 ms
					CRC_en <= '0';															-- reset priznaku pro zahajeni vypoctu CRC
					S_reset <= '0';														-- spusteni citace
					if (i = 799) then													-- konec periody citace
						S_reset <='1';														-- resetovani citace
						state	  <= RESET;													-- navrat do stavu RESET
					end if;

				when GET_DATA =>															-- stav pro precteni pameti scratchpad
					case GET_DATA_CNT is													-- pozice ve stavu GET_DATA
						when 0 to 71=>														-- cteni jednotlivych bitu pameti scratchpad
							ds_data_bus  <= '0';											-- zahajeni cteni na sbernici
							GET_DATA_CNT <= GET_DATA_CNT + 1;						-- inkrementace citace pro prave cteny bit
							state 		 <= READ_BIT;									-- prechod do stavu READ_BIT
						when 72=>															-- pamet prectena (72 bitu)
							bit_cnt := 0;													-- reset citace pro prave cteny bit
							GET_DATA_CNT <=0;												-- reset citace prectenych bitu
							dataOut 	 <= data(71 downto 0);							-- odeslani prectenych dat na vystupni port
							CRC_en 		 <= '1';											-- spusteni vypoctu CRC prectenych dat
							state 		 <= WAIT_800ms;								-- navrat do stavu WAIT_800ms
						when others =>	 													-- chyba ve stavu GET_DATA
							read_bit_flag <= 0;											-- reset pozice ve stavu READ_BIT
							GET_DATA_CNT  <= 0; 											-- reset citace pro pocet prectenych bitu
					end case;

				when READ_BIT =>															-- stav pro cteni bitu
					-- sekvence cteni bitu rizena priznakem read_bit_flag
					case read_bit_flag is												-- pozice ve stavu READ_BIT
						when 0=>																-- vyslani zacatku casoveho slotu pro cteni
							read_bit_flag <= 1;
						when 1=>																
							ds_data_bus <= 'Z';--aqui											-- uvolneni sbernice pro prijem bitu ze senzoru
							S_reset 		<= '0';											-- zapnuti citace
							if (i = 13) then												-- cekani 14 us
								S_reset		 <= '1';										-- reset citace
								read_bit_flag <= 2;
							end if; 
						when 2=>																-- odebrani vzorku dat ze sbernice
							data(bit_cnt)	<= ds_data_bus;							-- ulozeni vzorku dat do registru
							bit_cnt := bit_cnt + 1;										-- zvyseni citace pro prave cteny bit
							read_bit_flag	<= 3;
						when 3=>																-- dokonceni casoveho slotu
							S_reset <= '0';												-- zapnuti citace
							if (i = 63) then												-- cekani 62 us
								S_reset<='1';												-- reset citace
								read_bit_flag <= 0;										-- reset pozice ve stavu READ_BIT
								state 		  <= GET_DATA;								-- navrat do stavu GET_DATA
							end if;
						when others => 													-- chyba ve stavu READ_BIT
							read_bit_flag <= 0;											-- reset pozice ve stavu READ_BIT
							bit_cnt		  := 0;											-- reset citace pro prave cteny bit
							GET_DATA_CNT  <= 0;											-- reset citace prectenych bitu
							state			  <= RESET;										-- reset senzoru
					end case;

				when WRITE_BYTE =>														-- stav pro zapis bajtu dat na sbernici
					-- sekvence zapisu bajtu dat rizena citacem WRITE_BYTE_CNT
					case WRITE_BYTE_CNT is												-- pozice ve stavu WRITE_BYTE
						when 0 to 7=>														-- odesilani bitu 0-7
							if (write_command(WRITE_BYTE_CNT) = '0') then		-- odesilany bit ma hodnotu log. 0
								state <= WRITE_LOW; 										-- prechod do stavu WRITE_LOW
							else																-- odesilany bit ma hodnotu log. 1
								state <= WRITE_HIGH;										-- prechod do stavu WRITE_HIGH
							end if;
							WRITE_BYTE_CNT <= WRITE_BYTE_CNT + 1;					-- inkrementace citace odesilaneho bitu
						when 8=>																-- odesilani bajtu dokonceno
							WRITE_BYTE_CNT <= 0;											-- reset citace odesilaneho bitu
							state				<= SEND;										-- navrat do stavu SEND
						when others=>														-- chyba ve stavu WRITE_BYTE
							WRITE_BYTE_CNT  <= 0;										-- reset citace odesilaneho bitu
							write_low_flag  <= 0;										-- reset pozice ve stavu WRITE_LOW
							write_high_flag <= 0;										-- reset pozice ve stavu WRITE_HIGH
							state 		   <= RESET;									-- reset senzoru
						end case;

				when WRITE_LOW =>															-- stav pro zapis log. 0 na sbernici
					-- casovy slot pro zapis log 0 rizeny priznakem write_low_flag
					case write_low_flag is												-- pozice ve stavu WRITE_LOW
						when 0=>																-- vyslani zacatku casoveho slotu pro zapis log. 0
							ds_data_bus <= '0';											-- zacatek casoveho slotu
							S_reset 		<= '0';											-- zapnuti citace
							if (i = 59) then												-- cekani 60 us
								S_reset		   <='1';										-- reset citace
								write_low_flag <= 1;
							end if;
						when 1=>																-- uvolneni sbernice pro ukonceni casoveho slotu
							ds_data_bus <= 'Z';--aqui											-- uvolneni sbernice
							S_reset 		<= '0';											-- zapnuti citace
							if (i = 3) then												-- cekani 4 us na ustaleni sbernice 
								S_reset 		   <= '1';									-- reset citace
								write_low_flag <= 2;
							end if;
						when 2=>																-- konec zapisu log. 0
							write_low_flag <= 0;											-- reset pozice ve stavu WRITE_LOW
							state 		   <= WRITE_BYTE;								-- navrat do stavu WRITE_BYTE
						when others=>														-- chyba zapisu log. 0
							WRITE_BYTE_CNT  <= 0;										-- reset citace odesilaneho bitu
							write_low_flag  <= 0;										-- reset pozice ve stavu WRITE_LOW
							state 		    <= RESET;									-- reset senzoru
					end case;

				when WRITE_HIGH =>														-- stav pro zapis log. 1 na sbernici
					-- casovy slot pro zapis log 1 rizeny priznakem write_high_flag
					case write_high_flag is												-- pozice ve stavu WRITE_HIGH
						when 0=>																-- vyslani zacatku casoveho slotu pro zapis log. 1
							ds_data_bus <= '0';											-- zacatek casoveho slotu
							S_reset <= '0';												-- zapnuti citace
							if (i = 9) then												-- cekani 10 us
								S_reset 			<= '1';									-- reset citace
								write_high_flag <= 1;
							end if;
						when 1=>																-- uvolneni sbernice pro ukonceni casoveho slotu
							ds_data_bus <= 'Z';											-- uvolneni sbernice--aqui
							S_reset 		<= '0';											-- zapnuti citace
							if (i = 53) then												-- cekani 54 us
								S_reset			<= '1';									-- reset citace
								write_high_flag <= 2;
							end if;
						when 2=>																-- konec zapisu log. 1
							write_high_flag <= 0;										-- reset pozice ve stavu WRITE_HIGH
							state 			 <= WRITE_BYTE;							-- navrat do stavu WRITE BYTE
						when others =>														-- chyba zapisu log. 1
							WRITE_BYTE_CNT  <= 0;										-- reset citace odesilaneho bitu
							write_high_flag <= 0;										-- reset pozice ve stavu WRITE_HIGH
							state 		    <= RESET;									-- reset senzoru
					end case;

				when others =>																-- chyba FSM
					state <= RESET;														-- reset senzoru
					
			end case;
		end if;
	end process;

	-- Proces citace se synchronnim resetem
	process(clk, S_reset)

	begin
		if (rising_edge(clk)) then
		  if cont_aux=100 then --=125 then
			 cont_aux<=0;
		  	 if (S_reset = '1')then		-- reset citace
				    i <= 0;						-- vynulovani citace
			 else
				    i <= i + 1;				-- inkrementace citace
			 end if;
		   else
		   cont_aux<=cont_aux+1;
		   end if; 
		  end if;

	end process;

--data_out_lsb<=dataOut(7 downto 0);
--data_out_msb<=dataOut(11 downto 8);

TempData <= dataOut(12 downto 4);

-----------------------------------------------process para Reloj
process(inicio, clk, riesgo)
begin
if inicio = '1' or not(modo = "01") then
    cont_riesgo <= 0;
    alarma <= '0';
elsif rising_edge(clk) then
    if(riesgo = '1' and cont_base = 100000000)then
        alarma <= '1';
        if(cont_riesgo = 9999) then
            cont_riesgo <= 0;
        else
            cont_riesgo <= cont_riesgo +1;
        end if;
    else
        cont_riesgo <= 0;
    end if;
end if;
end process;

process(inicio, clk)
begin
if inicio='1' then
	cont_base<=0;
elsif rising_edge(clk) then
if cont_base=100000000 then
	cont_base<=0;
else
	cont_base<=cont_base+1;
end if;
end if;
end process;

--descripcion del contador BCD
process(inicio, clk)
begin
if inicio='1' then
cont_seg_uni<="0000";
elsif rising_edge(clk) then
    if cont_base=100000000 then
        if cont_seg_uni="1001" then
            cont_seg_uni<="0000";
        else
            cont_seg_uni<=cont_seg_uni+1;
        end if;
    end if;      
end if;
end process;

process(inicio, clk)
begin
if inicio='1' then
	cont_seg_dec<="0000";
elsif rising_edge(clk) then
	if cont_base=100000000 and cont_seg_uni=9 then
		if cont_seg_dec=5 then
			cont_seg_dec<="0000";
		else
			cont_seg_dec<=cont_seg_dec+1;
		end if;
	end if;
end if;
end process;

process(inicio, clk)
begin
if inicio='1' then
cont_min_uni<="0000";
elsif rising_edge(clk) then
    if cont_base=100000000 and cont_seg_uni=9 and cont_seg_dec=5 then
        if cont_min_uni="1001" then
            cont_min_uni<="0000";
        else
            cont_min_uni<=cont_min_uni+1;
        end if;
    end if;      
end if;
end process;

process(inicio, clk)
begin
if inicio='1' then
	cont_min_dec<="0000";
elsif rising_edge(clk) then
	if cont_base=100000000 and cont_seg_uni=9 and cont_seg_dec=5 and cont_min_uni=9 then
		if cont_min_dec=5 then
			cont_min_dec<="0000";
		else
			cont_min_dec<=cont_min_dec+1;
		end if;
	end if;
end if;
end process;

process(clk, inicio)
begin
if inicio='1' then
	enable_seg_aux<="1110";
elsif rising_edge(clk) then
	if cont_enable_aux= 100000 then--100000 then
		enable_seg_aux<=enable_seg_aux(2 downto 0)&enable_seg_aux(3);
end if;
end if;
end process;

process(inicio, clk)
begin
if inicio='1' then
	cont_enable_aux<=0;
elsif rising_edge(clk) then
	if cont_enable_aux= 100000 then--100000 then
		cont_enable_aux<=0;
	else
		cont_enable_aux<=cont_enable_aux+1;
	end if;
end if;
end process;

relojData <= cont_min_dec & cont_min_uni & cont_seg_dec & cont_seg_uni;

-----------------------------------------------mux datos
process(inicio, clk, sel)
begin
case(sel) is

   when "001" => muxSensores <= "00000" & TempData;
   when "010" => muxSensores <= distData;
   when "011" => muxSensores <= hallData;--hallData;
   
   when "100" => muxSensores <= std_logic_vector(to_unsigned(cont_riesgo, 14));
   when "101" => muxSensores <= std_logic_vector(to_unsigned(rTemp, 14));
   when "110" => muxSensores <= std_logic_vector(to_unsigned(rDist, 14));
   when "111" => muxSensores <= std_logic_vector(to_unsigned(rHall, 14));
   when others => muxSensores <= "00000000000000";
end case;
end process;


--------------------------------------------- conv bin2bcd
process(clk, inicio)
begin
if inicio='1' then
    cont<=0;
elsif rising_edge(clk) then
    if cont=100000000 then
        cont<=0;
    else
        cont<=cont+1;
    end if;
end if;
end process;                        

process(clk, inicio)
begin
if inicio='1' then
    vector_aux<="0000000000000000"&muxSensores;
    estado<="00";
    cont_bits<= 0;
    unidades<="0011";
    decenas<="0011";
    centenas<="0011";
    millares<="0011";
    fin<='0';
elsif rising_edge(clk) then
--if cont=0 then
    case estado is
    when "00" =>    cont_bits<=0;
                    fin<='0';
                    vector_aux<="0000000000000000"&muxSensores;
                    if enableSw='1' then
                        estado<="01";
                    end if;        
    when "01" =>    cont_bits<=cont_bits+1;
                    fin<='0';
                    vector_aux<=vector_aux(28 downto 0)&'0';
                    if cont_bits<13 then
                        estado<="10";
                    else
                        estado<="11";
                    end if;
    when "10" =>    cont_bits<=cont_bits;
                    fin<='0';
                    if vector_aux(21 downto 18)>4 then
                        vector_aux(21 downto 18)<=vector_aux(21 downto 18)+"0011";
                    end if;
                    if vector_aux(17 downto 14)>4 then
                        vector_aux(17 downto 14)<=vector_aux(17 downto 14)+"0011";
                    end if;
                    if vector_aux(25 downto 22)>4 then
                        vector_aux(25 downto 22)<=vector_aux(25 downto 22)+"0011";
                    end if;
                    if vector_aux(29 downto 26)>4 then
                        vector_aux(29 downto 26)<=vector_aux(29 downto 26)+"0011";
                    end if;
                    estado<="01";
    when "11" =>    cont_bits<=0;
                    fin<='1';
                    decenas<=vector_aux(21 downto 18);
                    unidades<=vector_aux(17 downto 14);
                    centenas<=vector_aux(25 downto 22);
                    millares<=vector_aux(29 downto 26);
                    estado<="00";
    when others =>  cont_bits<=0;
                    fin<='0';
                    estado<="00";
    end case;
end if;
--end if;
end process;--final de decodificador BCD-7seg

bcdData <= millares & centenas & decenas & unidades;

----------------------------------------------mux reloj
process(sel)
begin
if(sel = "000")then
    to7seg <= relojData;
else
    to7seg <= bcdData;
end if;
end process;

----------------------------------------------process para 7seg
--mux 7seg
process(enable_seg_aux)
begin
case enable_seg_aux is
when "1110" => salida_ver<=to7seg(3 downto 0);
when "1101" => salida_ver<=to7seg(7 downto 4);
when "1011" => salida_ver<=to7seg(11 downto 8);
when "0111" => salida_ver<=to7seg(15 downto 12);
when others => salida_ver<="0000";
end case;
end process;

enable_seg <= enable_seg_aux;

--bcd2 7seg
process(salida_ver)
begin
case salida_ver is
when "0000" => segmentos<="0000001";
when "0001" => segmentos<="1001111";
when "0010" => segmentos<="0010010";
when "0011" => segmentos<="0000110";
when "0100" => segmentos<="1001100";
when "0101" => segmentos<="0100100";
when "0110" => segmentos<="1100000";
when "0111" => segmentos<="0001111";
when "1000" => segmentos<="0000000";
when "1001" => segmentos<="0001100";
when others => segmentos<="0110000";
end case;
end process;

end Behavioral;
