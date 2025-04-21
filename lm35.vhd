library ieee;
use ieee.std_logic_1164.all; 


entity lm35 is 
port ( 
	   clk : in std_logic;
		int :in std_logic_vector (7 downto 0) ;
      start :out std_logic;    --bat dau chuyen doi 
		start_uart :inout std_logic;
      eoc :in std_logic; 		-- ket thuc qua trinh chuyen doi
      --out_en : out std_logic ; --cho phep tin hieu dau ra
      ale  : out std_logic ; --cho phep chon kenh 
      --adc : out std_logic_vector (0 to 2); --chon kenh adc 
      clk_adc :out bit ;  --cap clk adc
		tx : out std_logic
	);
end lm35;


architecture LogicFunction_UART_TX of lm35 is
	
	signal data_temp : std_logic_vector(7 downto 0);
	--signal start : std_logic:='1';
	signal temp: bit :='0';     --bien tam thoi dung cho chia tan
	signal d: integer := 0;
	
	component UART_TX PORT (	
	clk : in std_logic ;
	tx  : out std_logic ;
	data:in std_logic_vector(7 downto 0);
	start :inout std_logic
	
	);
	
	end component ;
	
begin 
process (clk)      -- chia tan so de cap cho adc
			begin 
				if (clk'event and clk = '1')then
				d <= d+1;
		if(d=49 ) then     --xung clock cua fpga co tan so la 50MHz, xung cap cho adc la 500kHz nen chia 100
			d <= 0;
			temp <= not temp;
		end if;
	end if;
end process;
clk_adc <= temp;

process (eoc,int,data_temp,clk)
variable dem : integer range 0 to 500001 :=0;
			begin
			if(rising_edge (clk)) then
			dem := dem +1;
			if(dem = 100) then
					ale <= '1'; -- chot kenh adc
					start <='1';    -- bat dau chuyen doi
			end if;
			if(dem=300) then
			
					ale <='0';
					start <='0';
			end if;
			if((dem >=300) and (eoc='1')) then
				
						for i in 7 downto 0 loop
						data_temp(i)<=int(i);   -- sao chep du lieu adc vào tín hiệu data
					end loop; 
					start_uart <='1';
			end if;
			if(dem=50000000) then
			start <='0';
			dem:=0;
			
			end if;
		end if;
end process;
U1:UART_TX PORT MAP(clk,tx,data_temp,start_uart);
end LogicFunction_UART_TX;